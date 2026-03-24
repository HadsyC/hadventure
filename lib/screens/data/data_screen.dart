import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'import_zip_validator.dart';
import 'import_schema.dart' as import_schema;
import 'package:drift/drift.dart' show Value;

class _ImportPayload {
  final String tableName;
  final List<String> headers;
  final List<List<dynamic>> dataRows;
  final String sourceName;

  const _ImportPayload({
    required this.tableName,
    required this.headers,
    required this.dataRows,
    required this.sourceName,
  });
}

class _ImportTableResult {
  final int insertedRows;
  final int rejectedRows;
  final List<String> diagnostics;

  const _ImportTableResult({
    required this.insertedRows,
    required this.rejectedRows,
    required this.diagnostics,
  });
}

class _TableImportSummary {
  final String tableName;
  final int insertedRows;
  final int rejectedRows;

  const _TableImportSummary({
    required this.tableName,
    required this.insertedRows,
    required this.rejectedRows,
  });
}

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  bool _isImporting = false;
  String? _lastMessage;
  bool _lastSuccess = false;
  List<_TableImportSummary> _lastImportSummary = const [];

  final Map<String, String> _aliasToCanonical = import_schema
      .buildAliasToCanonical();

  static const _importOrder = [
    'trips',
    'cities',
    'flights',
    'trains',
    'hotels',
    'locations',
    'itinerary',
    'trip_tips',
    'packing_items',
    'contacts',
  ];

  Future<void> _resetAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
          'This will permanently delete everything — trips, cities, itinerary, hotels, flights, trains, tips, packing and contacts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final db = DatabaseProvider.of(context);
    await db.delete(db.itinerary).go();
    await db.delete(db.hotels).go();
    await db.delete(db.flights).go();
    await db.delete(db.trains).go();
    await db.delete(db.tripTips).go();
    await db.delete(db.packingItems).go();
    await db.delete(db.contacts).go();
    await db.delete(db.locations).go();
    await db.delete(db.cities).go();
    await db.delete(db.trips).go();

    _setMessage('All data has been reset.', true);
  }

  // Detect table type from CSV headers
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

    // Backward compatibility for older itinerary exports.
    if (normalized.contains('city_name') &&
        (normalized.contains('activity_type') ||
            normalized.contains('itinerary_type'))) {
      return 'itinerary';
    }

    return null;
  }

  Future<void> _pickAndImport() async {
    final db = DatabaseProvider.of(context);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = File(result.files.single.path!);
    await _importZipArchive(db, file);
  }

  Future<void> _importZipArchive(AppDatabase db, File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final byTable = <String, _ImportPayload>{};
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

    if (byTable.isEmpty) {
      _setMessage(requiredZipFilesHelpMessage(), false);
      return;
    }

    final missingRequired = missingRequiredZipTables(byTable.keys);
    if (missingRequired.isNotEmpty) {
      _setMessage(missingRequiredZipFilesMessage(missingRequired), false);
      return;
    }

    final planned = byTable.keys.toSet();
    for (final table in planned) {
      final missingDep = await _checkDependenciesWithPlanned(table, planned);
      if (missingDep != null) {
        _setMessage(
          'Cannot import $table from ZIP — "$missingDep" must be present in DB or ZIP.',
          false,
        );
        return;
      }
    }

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ZipImportPreviewDialog(
        importsByTable: byTable,
        ignoredFiles: ignoredFiles,
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isImporting = true;
      _lastImportSummary = const [];
    });
    final tableSummaries = <_TableImportSummary>[];
    try {
      var totalInserted = 0;
      var totalRejected = 0;
      var totalTables = 0;
      final diagnostics = <String>[];

      for (final table in _importOrder) {
        final payload = byTable[table];
        if (payload == null) continue;
        final result = await _importTable(
          db,
          table,
          payload.headers,
          payload.dataRows,
        );
        totalInserted += result.insertedRows;
        totalRejected += result.rejectedRows;
        diagnostics.addAll(result.diagnostics);
        totalTables++;
        tableSummaries.add(
          _TableImportSummary(
            tableName: table,
            insertedRows: result.insertedRows,
            rejectedRows: result.rejectedRows,
          ),
        );
      }

      final diagnosticPreview = diagnostics.take(5).join(' | ');
      _setMessage(
        'Imported $totalInserted rows across $totalTables tables. Rejected $totalRejected rows.'
        '${diagnosticPreview.isEmpty ? '' : ' Details: $diagnosticPreview'}',
        true,
      );
    } catch (e) {
      _setMessage('ZIP import failed: $e', false);
    } finally {
      setState(() {
        _isImporting = false;
        _lastImportSummary = tableSummaries;
      });
    }
  }

  String _tableLabel(String tableName) {
    switch (tableName) {
      case 'trip_tips':
        return 'Tips & Phrases';
      case 'packing_items':
        return 'Packing List';
      default:
        return tableName
            .split('_')
            .map(
              (part) => part.isEmpty
                  ? part
                  : '${part[0].toUpperCase()}${part.substring(1)}',
            )
            .join(' ');
    }
  }

  _ImportPayload? _parseCsvPayload(
    String content, {
    required String sourceName,
  }) {
    final rows = const CsvToListConverter().convert(content);

    if (rows.isEmpty) {
      return null;
    }

    final headers = rows.first.map((e) => e.toString()).toList();
    final dataRows = rows
        .skip(1)
        .where((r) => r.any((c) => c.toString().trim().isNotEmpty))
        .toList();
    final tableName =
        _detectTable(headers) ?? _tableFromFileName(_baseName(sourceName));

    if (tableName == null) {
      return null;
    }

    return _ImportPayload(
      tableName: tableName,
      headers: headers,
      dataRows: dataRows,
      sourceName: sourceName,
    );
  }

  Future<String?> _checkDependenciesWithPlanned(
    String tableName,
    Set<String> plannedTables,
  ) async {
    final db = DatabaseProvider.of(context);
    final hasTripsInDb = (await db.select(db.trips).get()).isNotEmpty;
    final hasCitiesInDb = (await db.select(db.cities).get()).isNotEmpty;

    const needsTrip = {
      'cities',
      'flights',
      'trains',
      'packing_items',
      'trip_tips',
      'contacts',
    };
    const needsCityCompat = {'hotels', 'itinerary', 'activities'};

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

    return null;
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

  Future<_ImportTableResult> _importTable(
    AppDatabase db,
    String table,
    List<String> headers,
    List<List<dynamic>> rows,
  ) async {
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

      // Resolve ambiguous IDs based on current table context.
      if (table == 'flights' &&
          map['flight_number'] == null &&
          map['flight_id'] != null) {
        map['flight_number'] = map['flight_id'];
      }
      if (table == 'trains' &&
          map['train_number'] == null &&
          map['train_id'] != null) {
        map['train_number'] = map['train_id'];
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

      DateTime? parseDMY(String input, String separator) {
        final parts = input.split(separator);
        if (parts.length != 3) return null;
        final a = int.tryParse(parts[0]);
        final b = int.tryParse(parts[1]);
        final c = int.tryParse(parts[2]);
        if (a == null || b == null || c == null) return null;
        if (c < 1900) return null;
        // Prefer day/month for Notion exports with dots, month/day for slash formats.
        final monthFirst = separator == '/';
        final day = monthFirst ? b : a;
        final month = monthFirst ? a : b;
        return DateTime.tryParse(
          '${c.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
        );
      }

      try {
        return DateTime.parse(v);
      } catch (_) {
        final cleaned = v.split('(').first.trim();
        final normalized = cleaned.replaceAll('→', '-').replaceAll(',', '.');

        final dateAndTime = RegExp(
          r'^(\d{1,2})[\./](\d{1,2})[\./](\d{4})\s+(\d{1,2}):(\d{2})$',
        ).firstMatch(normalized);
        if (dateAndTime != null) {
          final a = int.parse(dateAndTime.group(1)!);
          final b = int.parse(dateAndTime.group(2)!);
          final y = int.parse(dateAndTime.group(3)!);
          final h = int.parse(dateAndTime.group(4)!);
          final min = int.parse(dateAndTime.group(5)!);
          final monthFirst = normalized.contains('/');
          final day = monthFirst ? b : a;
          final month = monthFirst ? a : b;
          return DateTime(y, month, day, h, min);
        }

        if (normalized.contains('/')) {
          return parseDMY(normalized, '/');
        }
        if (normalized.contains('.')) {
          return parseDMY(normalized, '.');
        }
        return null;
      }
    }

    double? dbl(Map m, String k) {
      final v = m[k];
      if (v == null || v.toString().trim().isEmpty) return null;
      return double.tryParse(v.toString().replaceAll('€', '').trim());
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

    int? resolveCityId(String? cityName) {
      final tripId = resolveTripId();
      final cityKey = normalize(canonicalCityName(cityName));
      if (tripId == null || cityKey == null) return null;
      return cityIdByTripAndName['$tripId|$cityKey'];
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
          await db.delete(db.trips).go();
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
          await db.delete(db.cities).go();
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
          await db.delete(db.flights).go();
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
          await db.delete(db.trains).go();
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
          await db.delete(db.hotels).go();
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final cityId = resolveCityId(str(m, 'city_name'));
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
          await db.delete(db.locations).go();
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
            final m = rowToMap(row);
            final tripId = resolveTripId();
            final cityId = resolveCityId(str(m, 'city_name'));
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
        case 'activities':
          await db.delete(db.itinerary).go();
          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];
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

            final addressEn = str(m, 'address_en') ?? str(m, 'location');
            final addressLocal = str(m, 'address_local');
            if (addressEn == null || addressLocal == null) {
              await rejectRow(
                'Map-ready itinerary row requires address_en and address_local',
                i,
              );
              continue;
            }

            await db
                .into(db.itinerary)
                .insert(
                  ItineraryCompanion.insert(
                    cityId: cityId,
                    date: dt(m, 'date')!,
                    title: str(m, 'title')!,
                    time: Value(str(m, 'time')),
                    type: Value(
                      str(m, 'itinerary_type') ?? str(m, 'activity_type'),
                    ),
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
          await db.delete(db.tripTips).go();
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
            final cityId = resolveCityId(str(m, 'city_name'));
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

        case 'packing_items':
          await db.delete(db.packingItems).go();
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
          await db.delete(db.contacts).go();
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

    return _ImportTableResult(
      insertedRows: insertedRows,
      rejectedRows: rejectedRows,
      diagnostics: diagnostics,
    );
  }

  void _setMessage(String msg, bool success) {
    if (!success) {
      debugPrint('[DataScreen][Error] $msg');
    }
    setState(() {
      _lastMessage = msg;
      _lastSuccess = success;
    });
  }

  Future<void> _exportTable(String table) async {
    // TODO: implement export
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Export for $table coming soon!')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const tables = [
      (name: 'trips', icon: Icons.luggage_outlined, label: 'Trips'),
      (name: 'cities', icon: Icons.location_city_outlined, label: 'Cities'),
      (name: 'flights', icon: Icons.flight_outlined, label: 'Flights'),
      (name: 'trains', icon: Icons.train_outlined, label: 'Trains'),
      (name: 'hotels', icon: Icons.hotel_outlined, label: 'Hotels'),
      (name: 'locations', icon: Icons.place_outlined, label: 'Locations'),
      (
        name: 'itinerary',
        icon: Icons.local_activity_outlined,
        label: 'Itinerary',
      ),
      (
        name: 'trip_tips',
        icon: Icons.tips_and_updates_outlined,
        label: 'Tips & Phrases',
      ),
      (
        name: 'packing_items',
        icon: Icons.backpack_outlined,
        label: 'Packing List',
      ),
      (name: 'contacts', icon: Icons.contacts_outlined, label: 'Contacts'),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Data')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Import button
                FilledButton.icon(
                  onPressed: _isImporting ? null : _pickAndImport,
                  icon: _isImporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload_file_outlined),
                  label: Text(_isImporting ? 'Importing...' : 'Import ZIP'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _resetAllData,
                  icon: Icon(
                    Icons.delete_sweep_outlined,
                    color: colorScheme.error,
                  ),
                  label: Text(
                    'Reset all data',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(color: colorScheme.error),
                  ),
                ),
                const SizedBox(height: 16),

                // Status message
                if (_lastMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _lastSuccess
                          ? colorScheme.primaryContainer
                          : colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _lastSuccess
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: _lastSuccess
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _lastMessage!,
                            style: TextStyle(
                              color: _lastSuccess
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_lastImportSummary.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last import summary',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._lastImportSummary.map((summary) {
                            final hasRejected = summary.rejectedRows > 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(_tableLabel(summary.tableName)),
                                  ),
                                  Text(
                                    '+${summary.insertedRows}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '-${summary.rejectedRows}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: hasRejected
                                          ? colorScheme.error
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Tables list
                Text(
                  'Tables',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: tables.asMap().entries.map((entry) {
                      final i = entry.key;
                      final t = entry.value;
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(t.icon, color: colorScheme.primary),
                            title: Text(t.name),
                            subtitle: Text(t.label),
                            trailing: IconButton(
                              icon: const Icon(Icons.download_outlined),
                              tooltip: 'Export ${t.label}',
                              onPressed: () => _exportTable(t.name),
                            ),
                          ),
                          if (i < tables.length - 1)
                            Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: colorScheme.outlineVariant,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PREVIEW DIALOG ───────────────────────────────────────────────────────────

class _ZipImportPreviewDialog extends StatelessWidget {
  final Map<String, _ImportPayload> importsByTable;
  final List<String> ignoredFiles;

  const _ZipImportPreviewDialog({
    required this.importsByTable,
    required this.ignoredFiles,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ordered = <String>[
      'trips',
      'cities',
      'flights',
      'trains',
      'hotels',
      'locations',
      'itinerary',
      'trip_tips',
      'packing_items',
      'contacts',
    ].where(importsByTable.containsKey).toList();

    final totalRows = ordered
        .map((t) => importsByTable[t]!.dataRows.length)
        .fold<int>(0, (a, b) => a + b);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.archive_outlined, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Import ZIP Archive'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ordered.length} tables · $totalRows rows detected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ordered.length,
                itemBuilder: (_, i) {
                  final table = ordered[i];
                  final payload = importsByTable[table]!;
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(table),
                    subtitle: Text(payload.sourceName),
                    trailing: Text('${payload.dataRows.length} rows'),
                  );
                },
              ),
            ),
            if (ignoredFiles.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${ignoredFiles.length} template file(s) ignored.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              'Existing data in each imported table will be replaced.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.upload),
          label: const Text('Import all'),
        ),
      ],
    );
  }
}
