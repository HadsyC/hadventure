import 'package:drift/drift.dart' show Value;
import 'package:hadventure/core/database/app_database.dart';
import 'package:hadventure/screens/data/import_schema.dart';

/// Testable import service that contains the actual import logic.
class ImportService {
  final AppDatabase db;

  ImportService(this.db);

  /// Import structured table data using real validation logic.
  Future<ImportResult> importTable(
    String tableName,
    List<String> headers,
    List<List<dynamic>> dataRows,
  ) async {
    int insertedRows = 0;
    int rejectedRows = 0;
    final diagnostics = <String>[];

    final rowToMap = _buildRowToMap(headers);
    final str = _buildStrGetter(rowToMap);
    final dt = _buildDateTimeGetter(rowToMap);
    final dbl = _buildDoubleGetter(rowToMap);
    final intVal = _buildIntGetter(rowToMap);

    String? normalize(String? v) {
      if (v == null) return null;
      final n = v.trim().toLowerCase();
      return n.isEmpty ? null : n;
    }

    String? canonicalCityName(String? value) {
      final source = value?.trim();
      if (source == null || source.isEmpty) return null;
      final noLink = source.split('(').first.trim();
      return noLink.isEmpty ? source : noLink;
    }

    Future<void> rejectRow(String reason, int rowIndex) async {
      rejectedRows++;
      if (diagnostics.length < 20) {
        diagnostics.add('$tableName row ${rowIndex + 1}: $reason');
      }
    }

    final allTrips = await db.select(db.trips).get();
    final allCities = await db.select(db.cities).get();
    final cityIdByTripAndName = <String, int>{
      for (final c in allCities)
        '${c.tripId}|${c.name.trim().toLowerCase()}': c.id,
    };

    int? resolveTripId() {
      if (allTrips.isEmpty) return null;
      return allTrips.first.id;
    }

    int? resolveCityId(String? cityName) {
      final tripId = resolveTripId();
      final cityKey = normalize(canonicalCityName(cityName));
      if (tripId == null || cityKey == null) return null;
      return cityIdByTripAndName['$tripId|$cityKey'];
    }

    await db.transaction(() async {
      switch (tableName) {
        case 'trips':
          await db.delete(db.trips).go();
          for (var i = 0; i < dataRows.length; i++) {
            final row = dataRows[i];
            final m = rowToMap(row);
            if (str(m, 'name') == null ||
                dt(m, 'start_date') == null ||
                dt(m, 'end_date') == null) {
              await rejectRow('Missing required trip fields', i);
              continue;
            }
            await db
                .into(db.trips)
                .insert(
                  TripsCompanion.insert(
                    name: str(m, 'name')!,
                    startDate: dt(m, 'start_date')!,
                    endDate: dt(m, 'end_date')!,
                    notes: Value(str(m, 'notes')),
                    currency: Value(str(m, 'currency')),
                    timezone: Value(str(m, 'timezone')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'cities':
          await db.delete(db.cities).go();
          for (var i = 0; i < dataRows.length; i++) {
            final row = dataRows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) {
              await rejectRow('No trip found for city row', i);
              continue;
            }
            if (str(m, 'name') == null || str(m, 'country') == null) {
              await rejectRow('Missing required city fields', i);
              continue;
            }
            await db
                .into(db.cities)
                .insert(
                  CitiesCompanion.insert(
                    tripId: tripId,
                    name: str(m, 'name')!,
                    country: str(m, 'country')!,
                    lat: Value(dbl(m, 'lat')),
                    lng: Value(dbl(m, 'lng')),
                    notes: Value(str(m, 'notes')),
                    arrivalDate: Value(dt(m, 'arrival_date')),
                    departureDate: Value(dt(m, 'departure_date')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'itinerary':
          await db.delete(db.itinerary).go();
          for (var i = 0; i < dataRows.length; i++) {
            final row = dataRows[i];
            final m = rowToMap(row);
            final cityId = resolveCityId(str(m, 'city_name'));
            if (cityId == null) {
              await rejectRow(
                'Could not resolve city_name for itinerary row',
                i,
              );
              continue;
            }
            if (str(m, 'title') == null || dt(m, 'date') == null) {
              await rejectRow('Missing itinerary title or date', i);
              continue;
            }

            final addressEn = str(m, 'address_en');
            final addressLocal = str(m, 'address_local') ?? addressEn;

            await db
                .into(db.itinerary)
                .insert(
                  ItineraryCompanion.insert(
                    cityId: cityId,
                    date: dt(m, 'date')!,
                    title: str(m, 'title')!,
                    time: Value(str(m, 'time')),
                    type: Value(str(m, 'itinerary_type')),
                    location: Value(str(m, 'location')),
                    addressEn: Value(addressEn),
                    addressLocal: Value(addressLocal),
                    mapUrl: Value(str(m, 'map_url')),
                    lat: Value(dbl(m, 'lat')),
                    lng: Value(dbl(m, 'lng')),
                    notes: Value(str(m, 'notes')),
                    url: Value(str(m, 'url')),
                    price: Value(dbl(m, 'price')),
                    currency: Value(str(m, 'currency')),
                    duration: Value(intVal(m, 'duration_minutes')),
                    availability: Value(str(m, 'availability')),
                    status: Value(str(m, 'status')),
                    flightId: Value(intVal(m, 'flight_id')),
                    trainId: Value(intVal(m, 'train_id')),
                    hotelId: Value(intVal(m, 'hotel_id')),
                  ),
                );
            insertedRows++;
          }
          break;

        default:
          await rejectRow('Unsupported table: $tableName', 0);
      }
    });

    return ImportResult(
      insertedRows: insertedRows,
      rejectedRows: rejectedRows,
      diagnostics: diagnostics,
    );
  }

  Map<String, String?> Function(List<dynamic>) _buildRowToMap(
    List<String> headers,
  ) {
    final aliasToCanonical = buildAliasToCanonical();
    return (List<dynamic> row) {
      final map = <String, String?>{};
      for (int i = 0; i < headers.length && i < row.length; i++) {
        final raw = headers[i];
        final normalized = normalizeImportHeader(raw).trim();
        final canonical = aliasToCanonical[normalized] ?? normalized;
        final value = (row[i] as dynamic).toString().trim();
        map[canonical] = value.isEmpty ? null : value;
      }
      return map;
    };
  }

  Function(Map<String, String?>, String) _buildStrGetter(
    Map<String, String?> Function(List<dynamic>) rowToMap,
  ) {
    return (Map<String, String?> m, String k) {
      final v = m[k]?.trim();
      return v?.isEmpty ?? true ? null : v;
    };
  }

  Function(Map<String, String?>, String) _buildDateTimeGetter(
    Map<String, String?> Function(List<dynamic>) rowToMap,
  ) {
    return (Map<String, String?> m, String k) {
      final v = m[k];
      if (v == null) return null;
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    };
  }

  Function(Map<String, String?>, String) _buildDoubleGetter(
    Map<String, String?> Function(List<dynamic>) rowToMap,
  ) {
    return (Map<String, String?> m, String k) {
      final v = m[k];
      if (v == null || v.toString().trim().isEmpty) return null;
      return double.tryParse(v.toString().trim());
    };
  }

  Function(Map<String, String?>, String) _buildIntGetter(
    Map<String, String?> Function(List<dynamic>) rowToMap,
  ) {
    return (Map<String, String?> m, String k) {
      final v = m[k];
      if (v == null || v.toString().trim().isEmpty) return null;
      return int.tryParse(v.toString().trim());
    };
  }
}

class ImportResult {
  final int insertedRows;
  final int rejectedRows;
  final List<String> diagnostics;

  ImportResult({
    required this.insertedRows,
    required this.rejectedRows,
    required this.diagnostics,
  });
}
