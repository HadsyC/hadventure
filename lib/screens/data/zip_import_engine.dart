import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' show Value;
import 'package:hadventure/core/database/app_database.dart';
import 'package:hadventure/screens/data/import_schema.dart' as import_schema;
import 'package:hadventure/screens/data/import_zip_validator.dart';

String _timeStamp() => DateTime.now().toIso8601String().split('.')[0];

void _engineTimer(String label, {String? stage}) {
  final msg = stage == null ? label : '$label [$stage]';
  final line = '[${_timeStamp()}] ENGINE: $msg';
  stderr.writeln(line);
}

class ImportPayload {
  final String tableName;
  final List<String> headers;
  final List<List<dynamic>> dataRows;
  final String sourceName;

  const ImportPayload({
    required this.tableName,
    required this.headers,
    required this.dataRows,
    required this.sourceName,
  });
}

class ImportTableResult {
  final int insertedRows;
  final int rejectedRows;
  final List<String> diagnostics;

  const ImportTableResult({
    required this.insertedRows,
    required this.rejectedRows,
    required this.diagnostics,
  });
}

class TableImportSummary {
  final String tableName;
  final int insertedRows;
  final int rejectedRows;

  const TableImportSummary({
    required this.tableName,
    required this.insertedRows,
    required this.rejectedRows,
  });
}

class ZipParseResult {
  final Map<String, ImportPayload> byTable;
  final List<String> ignoredFiles;

  const ZipParseResult({required this.byTable, required this.ignoredFiles});
}

class ZipImportExecutionResult {
  final int totalInserted;
  final int totalRejected;
  final int totalTables;
  final List<String> diagnostics;
  final List<TableImportSummary> tableSummaries;

  const ZipImportExecutionResult({
    required this.totalInserted,
    required this.totalRejected,
    required this.totalTables,
    required this.diagnostics,
    required this.tableSummaries,
  });
}

class ZipImportEngine {
  const ZipImportEngine();

  static const importOrder = [
    'trips',
    'cities',
    'city_summaries',
    'flights',
    'trains',
    'hotels',
    'locations',
    'foods',
    'itinerary',
    'trip_tips',
    'packing_items',
    'contacts',
  ];

  Map<String, String> get _aliasToCanonical =>
      import_schema.buildAliasToCanonical();

  Future<ZipParseResult> parseZipFile(File file) async {
    _engineTimer('parseZipFile START: ${file.path}');

    _engineTimer('parseZipFile', stage: 'reading file bytes');
    final bytes = await file.readAsBytes();
    _engineTimer('parseZipFile', stage: 'read ${bytes.length} bytes');

    _engineTimer('parseZipFile', stage: 'decoding ZIP archive');
    final archive = ZipDecoder().decodeBytes(bytes);
    _engineTimer(
      'parseZipFile',
      stage: 'decoded, ${archive.files.length} entries',
    );

    _engineTimer('parseZipFile', stage: 'parsing archive');
    final result = parseArchive(archive);
    _engineTimer(
      'parseZipFile',
      stage: 'parsed, got ${result.byTable.length} tables',
    );

    _engineTimer('parseZipFile COMPLETE');
    return result;
  }

  ZipParseResult parseArchive(Archive archive) {
    final byTable = <String, ImportPayload>{};
    final ignoredFiles = <String>[];

    for (final entry in archive.files) {
      if (!entry.isFile) continue;

      final normalizedPath = entry.name.replaceAll('\\', '/').toLowerCase();
      if (!normalizedPath.endsWith('.csv')) continue;

      final baseName = _baseName(normalizedPath);
      if (normalizedPath.contains('/templates/') ||
          baseName.endsWith('_template.csv')) {
        ignoredFiles.add(entry.name);
        continue;
      }

      final rawContent = entry.content;
      final fileBytes = switch (rawContent) {
        List<int> v => v,
        String s => utf8.encode(s),
        _ => null,
      };
      if (fileBytes == null) continue;

      final content = utf8.decode(fileBytes, allowMalformed: true);
      final payload = _parseCsvPayload(content, sourceName: entry.name);
      if (payload == null) continue;

      byTable[payload.tableName] = payload;
    }

    return ZipParseResult(byTable: byTable, ignoredFiles: ignoredFiles);
  }

  Future<String?> checkDependenciesWithPlanned({
    required AppDatabase db,
    required String tableName,
    required Set<String> plannedTables,
  }) async {
    final hasTripsInDb = (await db.select(db.trips).get()).isNotEmpty;
    final hasCitiesInDb = (await db.select(db.cities).get()).isNotEmpty;

    const needsTrip = {
      'cities',
      'flights',
      'trains',
      'city_summaries',
      'foods',
      'packing_items',
      'trip_tips',
      'contacts',
    };
    const needsCityCompat = {'hotels', 'itinerary', 'activities'};
    const needsCity = {'city_summaries', 'foods'};

    if (needsTrip.contains(tableName) &&
        !hasTripsInDb &&
        !plannedTables.contains('trips')) {
      return 'trips';
    }

    if (needsCityCompat.contains(tableName) &&
        !hasCitiesInDb &&
        !plannedTables.contains('cities')) {
      return 'cities';
    }

    if (needsCity.contains(tableName) &&
        !hasCitiesInDb &&
        !plannedTables.contains('cities')) {
      return 'cities';
    }

    return null;
  }

  Future<ZipImportExecutionResult> importFromFile({
    required AppDatabase db,
    required File zipFile,
  }) async {
    final parsed = await parseZipFile(zipFile);
    return importParsed(db: db, byTable: parsed.byTable);
  }

  Future<ZipImportExecutionResult> importParsed({
    required AppDatabase db,
    required Map<String, ImportPayload> byTable,
  }) async {
    _engineTimer('importParsed START');

    _engineTimer('importParsed', stage: 'validating tables');
    if (byTable.isEmpty) {
      throw StateError(requiredZipFilesHelpMessage());
    }

    final missingRequired = missingRequiredZipTables(byTable.keys);
    if (missingRequired.isNotEmpty) {
      throw StateError(missingRequiredZipFilesMessage(missingRequired));
    }

    _engineTimer('importParsed', stage: 'checking dependencies');
    final planned = byTable.keys.toSet();
    for (final table in planned) {
      final missingDep = await checkDependenciesWithPlanned(
        db: db,
        tableName: table,
        plannedTables: planned,
      );
      if (missingDep != null) {
        throw StateError(
          'Cannot import $table from ZIP - "$missingDep" must be present in DB or ZIP.',
        );
      }
    }

    _engineTimer('importParsed', stage: 'clearing old data from 12 tables');
    await db.delete(db.itinerary).go();
    await db.delete(db.locations).go();
    await db.delete(db.hotels).go();
    await db.delete(db.foods).go();
    await db.delete(db.citySummaries).go();
    await db.delete(db.cities).go();
    await db.delete(db.flights).go();
    await db.delete(db.trains).go();
    await db.delete(db.tripTips).go();
    await db.delete(db.packingItems).go();
    await db.delete(db.contacts).go();
    await db.delete(db.trips).go();
    _engineTimer('importParsed', stage: 'old data cleared');

    var totalInserted = 0;
    var totalRejected = 0;
    var totalTables = 0;
    final diagnostics = <String>[];
    final tableSummaries = <TableImportSummary>[];

    _engineTimer(
      'importParsed',
      stage: 'importing ${byTable.length} tables in order',
    );
    for (final table in importOrder) {
      final payload = byTable[table];
      if (payload == null) continue;

      _engineTimer(
        'importParsed',
        stage: 'importing table: $table (${payload.dataRows.length} rows)',
      );
      final result = await importTable(
        db: db,
        table: table,
        headers: payload.headers,
        rows: payload.dataRows,
      );
      _engineTimer(
        'importParsed',
        stage:
            'table $table complete: ${result.insertedRows} inserted, ${result.rejectedRows} rejected',
      );
      if (result.rejectedRows > 0) {
        for (final line in result.diagnostics.take(5)) {
          _engineTimer('importParsed', stage: 'rejected: $line');
        }
      }

      totalInserted += result.insertedRows;
      totalRejected += result.rejectedRows;
      diagnostics.addAll(result.diagnostics);
      totalTables++;
      tableSummaries.add(
        TableImportSummary(
          tableName: table,
          insertedRows: result.insertedRows,
          rejectedRows: result.rejectedRows,
        ),
      );
    }

    _engineTimer(
      'importParsed COMPLETE: $totalTables tables, $totalInserted inserted, $totalRejected rejected',
    );
    if (totalRejected > 0) {
      _engineTimer('importParsed', stage: 'first rejected rows summary:');
      for (final line in diagnostics.take(10)) {
        _engineTimer('importParsed', stage: line);
      }
    }
    return ZipImportExecutionResult(
      totalInserted: totalInserted,
      totalRejected: totalRejected,
      totalTables: totalTables,
      diagnostics: diagnostics,
      tableSummaries: tableSummaries,
    );
  }

  Future<ImportTableResult> importTable({
    required AppDatabase db,
    required String table,
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) async {
    final diagnostics = <String>[];
    var insertedRows = 0;
    var rejectedRows = 0;

    Map<String, dynamic> rowToMap(List<dynamic> row) {
      final map = <String, dynamic>{};
      for (int i = 0; i < headers.length; i++) {
        final normalized = import_schema.normalizeImportHeader(headers[i]);
        final canonical = _aliasToCanonical[normalized] ?? normalized;
        map[canonical] = i < row.length ? row[i] : null;
      }

      return map;
    }

    String? str(Map m, String k) {
      final v = m[k];
      if (v == null || v.toString().trim().isEmpty) return null;
      return v.toString().trim();
    }

    DateTime? dt(Map m, String k) {
      final v = str(m, k);
      if (v == null) return null;
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }

    double? dbl(Map m, String k) {
      final v = m[k];
      if (v == null || v.toString().trim().isEmpty) return null;
      return double.tryParse(v.toString().trim());
    }

    int? intVal(Map m, String k) {
      final v = m[k];
      if (v == null || v.toString().trim().isEmpty) return null;
      return int.tryParse(v.toString().trim());
    }

    bool boolVal(Map m, String k) {
      final v = str(m, k)?.toLowerCase();
      return v == 'true' || v == '1' || v == 'yes';
    }

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

    Future<int?> resolveOrCreateCityId(String? cityName) async {
      final tripId = resolveTripId();
      final canonicalName = canonicalCityName(cityName);
      final cityKey = normalize(canonicalName);
      if (tripId == null || cityKey == null) return null;

      final existingId = cityIdByTripAndName['$tripId|$cityKey'];
      if (existingId != null) return existingId;

      final insertedId = await db
          .into(db.cities)
          .insert(
            CitiesCompanion.insert(
              tripId: tripId,
              name: canonicalName!,
              country: 'Unknown',
              notes: const Value('Auto-created from itinerary import'),
            ),
          );
      cityIdByTripAndName['$tripId|$cityKey'] = insertedId;
      return insertedId;
    }

    Future<void> rejectRow(String reason, int rowIndex) async {
      rejectedRows++;
      if (diagnostics.length < 20) {
        diagnostics.add('$table row ${rowIndex + 1}: $reason');
      }
    }

    await db.transaction(() async {
      switch (table) {
        case 'trips':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
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
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
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

        case 'flights':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) {
              await rejectRow('No trip found for flight row', i);
              continue;
            }
            if (str(m, 'flight_number') == null ||
                str(m, 'origin') == null ||
                str(m, 'destination') == null ||
                dt(m, 'departure') == null ||
                dt(m, 'arrival') == null) {
              await rejectRow('Missing required flight fields', i);
              continue;
            }
            await db
                .into(db.flights)
                .insert(
                  FlightsCompanion.insert(
                    tripId: tripId,
                    flightNumber: str(m, 'flight_number')!,
                    origin: str(m, 'origin')!,
                    destination: str(m, 'destination')!,
                    departure: dt(m, 'departure')!,
                    arrival: dt(m, 'arrival')!,
                    duration: Value(str(m, 'duration')),
                    airline: Value(str(m, 'airline')),
                    originTerminal: Value(str(m, 'origin_terminal')),
                    destinationTerminal: Value(str(m, 'destination_terminal')),
                    seat: Value(str(m, 'seat')),
                    bookingRef: Value(str(m, 'booking_ref')),
                    status: Value(str(m, 'status')),
                    trackerUrl: Value(str(m, 'tracker_url')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'trains':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) {
              await rejectRow('No trip found for train row', i);
              continue;
            }
            if (str(m, 'train_number') == null ||
                str(m, 'origin') == null ||
                str(m, 'destination') == null ||
                dt(m, 'departure') == null ||
                dt(m, 'arrival') == null) {
              await rejectRow('Missing required train fields', i);
              continue;
            }
            await db
                .into(db.trains)
                .insert(
                  TrainsCompanion.insert(
                    tripId: tripId,
                    trainNumber: str(m, 'train_number')!,
                    origin: str(m, 'origin')!,
                    destination: str(m, 'destination')!,
                    departure: dt(m, 'departure')!,
                    arrival: dt(m, 'arrival')!,
                    duration: Value(str(m, 'duration')),
                    platform: Value(str(m, 'platform')),
                    seat: Value(str(m, 'seat')),
                    bookingRef: Value(str(m, 'booking_ref')),
                    ticketPricePerPerson: Value(dbl(m, 'ticket_price_pp')),
                    bookingFeePerPerson: Value(dbl(m, 'booking_fee_pp')),
                    totalPricePerPerson: Value(dbl(m, 'total_price_pp')),
                    status: Value(str(m, 'status')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'hotels':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final cityId = await resolveOrCreateCityId(str(m, 'city_name'));
            if (cityId == null) {
              await rejectRow('Could not resolve city_name for hotel row', i);
              continue;
            }
            if (str(m, 'name') == null) {
              await rejectRow('Missing hotel name', i);
              continue;
            }
            await db
                .into(db.hotels)
                .insert(
                  HotelsCompanion.insert(
                    cityId: cityId,
                    name: str(m, 'name')!,
                    localName: Value(str(m, 'local_name')),
                    addressEn: Value(str(m, 'address_en')),
                    addressLocal: Value(str(m, 'address_local')),
                    checkIn: Value(dt(m, 'check_in_date')),
                    checkOut: Value(dt(m, 'check_out_date')),
                    checkInTime: Value(str(m, 'check_in_time')),
                    checkOutTime: Value(str(m, 'check_out_time')),
                    confirmation: Value(str(m, 'confirmation')),
                    phone: Value(str(m, 'phone')),
                    website: Value(str(m, 'website')),
                    totalPrice: Value(dbl(m, 'total_price')),
                    pricePerPerson: Value(dbl(m, 'price_pp')),
                    pricePerPersonNight: Value(dbl(m, 'price_pp_night')),
                    mapUrl: Value(str(m, 'map_url')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'locations':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            final cityId = await resolveOrCreateCityId(str(m, 'city_name'));
            if (tripId == null || cityId == null) {
              await rejectRow(
                'Could not resolve trip or city for location row',
                i,
              );
              continue;
            }
            if (str(m, 'name') == null || str(m, 'type') == null) {
              await rejectRow('Missing required location fields', i);
              continue;
            }

            await db
                .into(db.locations)
                .insert(
                  LocationsCompanion.insert(
                    tripId: tripId,
                    cityId: cityId,
                    name: str(m, 'name')!,
                    type: str(m, 'type')!,
                    category: Value(str(m, 'category')),
                    addressEn: Value(str(m, 'address_en')),
                    addressLocal: Value(str(m, 'address_local')),
                    mapUrl: Value(str(m, 'map_url')),
                    lat: Value(dbl(m, 'lat')),
                    lng: Value(dbl(m, 'lng')),
                    image: Value(str(m, 'image')),
                    notes: Value(str(m, 'notes')),
                    phone: Value(str(m, 'phone')),
                    website: Value(str(m, 'website')),
                    sourceTable: Value(str(m, 'source_table')),
                    sourceId: Value(str(m, 'source_id')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'itinerary':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final cityId = await resolveOrCreateCityId(str(m, 'city_name'));
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

        case 'trip_tips':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) {
              await rejectRow('No trip found for tip row', i);
              continue;
            }
            if (str(m, 'category') == null ||
                str(m, 'title') == null ||
                str(m, 'content') == null) {
              await rejectRow('Missing required tip fields', i);
              continue;
            }
            final cityId = await resolveOrCreateCityId(str(m, 'city_name'));
            await db
                .into(db.tripTips)
                .insert(
                  TripTipsCompanion.insert(
                    tripId: tripId,
                    cityId: Value(cityId),
                    category: str(m, 'category')!,
                    title: str(m, 'title')!,
                    content: str(m, 'content')!,
                    language: Value(str(m, 'language')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'city_summaries':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            final cityId = await resolveOrCreateCityId(str(m, 'city_name'));
            if (tripId == null || cityId == null) {
              await rejectRow(
                'Could not resolve trip or city for city summary row',
                i,
              );
              continue;
            }
            if (str(m, 'summary_text') == null) {
              await rejectRow('Missing summary_text', i);
              continue;
            }
            await db
                .into(db.citySummaries)
                .insert(
                  CitySummariesCompanion.insert(
                    tripId: tripId,
                    cityId: cityId,
                    summaryText: str(m, 'summary_text')!,
                    sourceLanguage: Value(str(m, 'source_language')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'foods':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            final cityId = await resolveOrCreateCityId(str(m, 'city_name'));
            if (tripId == null || cityId == null) {
              await rejectRow('Could not resolve trip or city for food row', i);
              continue;
            }
            if (str(m, 'name') == null) {
              await rejectRow('Missing food/restaurant name', i);
              continue;
            }
            await db
                .into(db.foods)
                .insert(
                  FoodsCompanion.insert(
                    tripId: tripId,
                    cityId: cityId,
                    name: str(m, 'name')!,
                    category: Value(str(m, 'category')),
                    amapUrl: Value(str(m, 'map_url')),
                    avgPriceCny: Value(dbl(m, 'avg_price_cny')),
                    avgPriceEur: Value(dbl(m, 'avg_price_eur')),
                    recommendedDishes: Value(str(m, 'recommended_dishes')),
                    notes: Value(str(m, 'notes')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'packing_items':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) {
              await rejectRow('No trip found for packing row', i);
              continue;
            }
            if (str(m, 'item') == null) {
              await rejectRow('Missing packing item name', i);
              continue;
            }
            await db
                .into(db.packingItems)
                .insert(
                  PackingItemsCompanion.insert(
                    tripId: tripId,
                    item: str(m, 'item')!,
                    category: Value(str(m, 'category')),
                    quantity: Value(intVal(m, 'quantity') ?? 1),
                    isPacked: Value(boolVal(m, 'is_packed')),
                    notes: Value(str(m, 'notes')),
                  ),
                );
            insertedRows++;
          }
          break;

        case 'contacts':
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) {
              await rejectRow('No trip found for contact row', i);
              continue;
            }
            if (str(m, 'name') == null) {
              await rejectRow('Missing contact name', i);
              continue;
            }
            await db
                .into(db.contacts)
                .insert(
                  ContactsCompanion.insert(
                    tripId: tripId,
                    name: str(m, 'name')!,
                    role: Value(str(m, 'role')),
                    phone: Value(str(m, 'phone')),
                    email: Value(str(m, 'email')),
                    notes: Value(str(m, 'notes')),
                  ),
                );
            insertedRows++;
          }
          break;
      }
    });

    return ImportTableResult(
      insertedRows: insertedRows,
      rejectedRows: rejectedRows,
      diagnostics: diagnostics,
    );
  }

  String? _detectTable(List<String> headers) {
    final normalized = headers
        .map(import_schema.normalizeImportHeader)
        .map((h) => _aliasToCanonical[h] ?? h)
        .toSet();

    for (final entry in import_schema.tableDetectionColumns.entries) {
      if (normalized.containsAll(entry.value)) {
        return entry.key;
      }
    }

    return null;
  }

  ImportPayload? _parseCsvPayload(
    String content, {
    required String sourceName,
  }) {
    final rows = _parseCsvRowsFlexible(content);

    if (rows.isEmpty) return null;

    final headers = rows.first.map((e) => e.toString()).toList();
    final dataRows = rows
        .skip(1)
        .where((r) => r.any((c) => c.toString().trim().isNotEmpty))
        .toList();
    // Prefer canonical filename mapping to avoid header-overlap collisions
    // (for example locations.csv also containing name/city_name/address_en).
    final tableName =
        _tableFromFileName(_baseName(sourceName)) ?? _detectTable(headers);

    if (tableName == null) return null;

    return ImportPayload(
      tableName: tableName,
      headers: headers,
      dataRows: dataRows,
      sourceName: sourceName,
    );
  }

  List<List<dynamic>> _parseCsvRowsFlexible(String content) {
    const separators = ['\r\n', '\n', '\r'];

    for (final eol in separators) {
      try {
        final rows = CsvToListConverter(eol: eol).convert(content);
        if (rows.length > 1) {
          return rows;
        }
      } catch (_) {
        // Try next line separator style.
      }
    }

    // Last attempt with package defaults to preserve previous behavior.
    return const CsvToListConverter().convert(content);
  }

  String _baseName(String path) {
    final parts = path.split(RegExp(r'[\\/]'));
    return parts.isEmpty ? path : parts.last;
  }

  String? _tableFromFileName(String fileName) {
    final normalized = fileName.toLowerCase().replaceAll('.csv', '');
    final root = normalized.endsWith('_template')
        ? normalized.substring(0, normalized.length - '_template'.length)
        : normalized;

    return import_schema.supportedImportTables.contains(root) ? root : null;
  }
}
