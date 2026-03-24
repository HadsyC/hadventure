import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'import_zip_validator.dart';
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

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  bool _isImporting = false;
  String? _lastMessage;
  bool _lastSuccess = false;

  static const _importOrder = [
    'trips',
    'cities',
    'flights',
    'trains',
    'hotels',
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
    await db.delete(db.cities).go();
    await db.delete(db.trips).go();

    _setMessage('All data has been reset.', true);
  }

  // Detect table type from CSV headers
  String? _detectTable(List<String> headers) {
    final h = headers.map((e) => e.trim().toLowerCase()).toSet();
    if (h.contains('start_date') &&
        h.contains('end_date') &&
        h.contains('timezone'))
      return 'trips';
    if (h.contains('arrival_date') && h.contains('departure_date')) {
      return 'cities';
    }
    if (h.contains('flight_number') && h.contains('airline')) return 'flights';
    if (h.contains('train_number') && h.contains('departure')) return 'trains';
    if (h.contains('address_en') && h.contains('check_in_date'))
      return 'hotels';
    if ((h.contains('activity_type') || h.contains('itinerary_type')) &&
        h.contains('city_name')) {
      return 'itinerary';
    }
    if (h.contains('category') &&
        h.contains('content') &&
        h.contains('language'))
      return 'trip_tips';
    if (h.contains('item') && h.contains('is_packed')) return 'packing_items';
    if (h.contains('role') && h.contains('name')) return 'contacts';
    return null;
  }

  Future<String?> _checkDependencies(String tableName) async {
    final db = DatabaseProvider.of(context);

    final tripCount = await db.select(db.trips).get();
    final cityCount = await db.select(db.cities).get();

    // Tables that need trips to exist first
    const needsTrip = [
      'cities',
      'flights',
      'trains',
      'packing_items',
      'trip_tips',
      'contacts',
    ];
    // Tables that need cities to exist first
    const needsCity = ['hotels', 'itinerary', 'activities'];

    if (needsTrip.contains(tableName) && tripCount.isEmpty) return 'trips';
    if (needsCity.contains(tableName) && cityCount.isEmpty) return 'cities';

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
      _setMessage(
        'ZIP file must contain required CSV files: trips.csv, cities.csv, flights.csv, trains.csv, hotels.csv, itinerary.csv, trip_tips.csv.',
        false,
      );
      return;
    }

    final missingRequired = missingRequiredZipTables(byTable.keys);
    if (missingRequired.isNotEmpty) {
      final missingFiles = missingRequired.map((table) => '$table.csv').toList()
        ..sort();
      _setMessage(
        'ZIP is missing required files: ${missingFiles.join(', ')}.',
        false,
      );
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

    setState(() => _isImporting = true);
    try {
      var totalRows = 0;
      var totalTables = 0;

      for (final table in _importOrder) {
        final payload = byTable[table];
        if (payload == null) continue;
        await _importTable(db, table, payload.headers, payload.dataRows);
        totalRows += payload.dataRows.length;
        totalTables++;
      }

      _setMessage(
        'Successfully imported $totalRows rows across $totalTables tables from ZIP.',
        true,
      );
    } catch (e) {
      _setMessage('ZIP import failed: $e', false);
    } finally {
      setState(() => _isImporting = false);
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

    const supported = {
      'trips',
      'cities',
      'flights',
      'trains',
      'hotels',
      'itinerary',
      'activities',
      'trip_tips',
      'packing_items',
      'contacts',
    };

    return supported.contains(root) ? root : null;
  }

  Future<void> _importTable(
    AppDatabase db,
    String table,
    List<String> headers,
    List<List<dynamic>> rows,
  ) async {
    Map<String, dynamic> rowToMap(List<dynamic> row) {
      final map = <String, dynamic>{};
      for (int i = 0; i < headers.length; i++) {
        map[headers[i].trim()] = i < row.length ? row[i] : null;
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
      final cityKey = normalize(cityName);
      if (tripId == null || cityKey == null) return null;
      return cityIdByTripAndName['$tripId|$cityKey'];
    }

    await db.transaction(() async {
      switch (table) {
        case 'trips':
          await db.delete(db.trips).go();
          for (final row in rows) {
            final m = rowToMap(row);
            await db
                .into(db.trips)
                .insert(
                  TripsCompanion.insert(
                    name: str(m, 'name') ?? '',
                    startDate: dt(m, 'start_date') ?? DateTime.now(),
                    endDate: dt(m, 'end_date') ?? DateTime.now(),
                    notes: Value(str(m, 'notes')),
                    currency: Value(str(m, 'currency')),
                    timezone: Value(str(m, 'timezone')),
                  ),
                );
          }
          break;

        case 'cities':
          await db.delete(db.cities).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) continue;
            await db
                .into(db.cities)
                .insert(
                  CitiesCompanion.insert(
                    tripId: tripId,
                    name: str(m, 'name') ?? '',
                    country: str(m, 'country') ?? '',
                    lat: Value(dbl(m, 'lat')),
                    lng: Value(dbl(m, 'lng')),
                    notes: Value(str(m, 'notes')),
                    arrivalDate: Value(dt(m, 'arrival_date')),
                    departureDate: Value(dt(m, 'departure_date')),
                  ),
                );
          }
          break;

        case 'flights':
          await db.delete(db.flights).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) continue;
            await db
                .into(db.flights)
                .insert(
                  FlightsCompanion.insert(
                    tripId: tripId,
                    flightNumber: str(m, 'flight_number') ?? '',
                    origin: str(m, 'origin') ?? '',
                    destination: str(m, 'destination') ?? '',
                    departure: dt(m, 'departure') ?? DateTime.now(),
                    arrival: dt(m, 'arrival') ?? DateTime.now(),
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
          }
          break;

        case 'trains':
          await db.delete(db.trains).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) continue;
            await db
                .into(db.trains)
                .insert(
                  TrainsCompanion.insert(
                    tripId: tripId,
                    trainNumber: str(m, 'train_number') ?? '',
                    origin: str(m, 'origin') ?? '',
                    destination: str(m, 'destination') ?? '',
                    departure: dt(m, 'departure') ?? DateTime.now(),
                    arrival: dt(m, 'arrival') ?? DateTime.now(),
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
          }
          break;

        case 'hotels':
          await db.delete(db.hotels).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final cityId = resolveCityId(str(m, 'city_name'));
            if (cityId == null) continue;
            await db
                .into(db.hotels)
                .insert(
                  HotelsCompanion.insert(
                    cityId: cityId,
                    name: str(m, 'name') ?? '',
                    localName: Value(str(m, 'local_name')),
                    addressEn: Value(str(m, 'address_en')),
                    addressLocal: Value(str(m, 'address_cn')),
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
                    mapUrl: Value(str(m, 'amap_url')),
                  ),
                );
          }
          break;

        case 'itinerary':
        case 'activities':
          await db.delete(db.itinerary).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final cityId = resolveCityId(str(m, 'city_name'));
            if (cityId == null) continue;
            await db
                .into(db.itinerary)
                .insert(
                  ItineraryCompanion.insert(
                    cityId: cityId,
                    date: dt(m, 'date') ?? DateTime.now(),
                    title: str(m, 'title') ?? '',
                    time: Value(str(m, 'time')),
                    type: Value(
                      str(m, 'itinerary_type') ?? str(m, 'activity_type'),
                    ),
                    location: Value(str(m, 'location')),
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
          }
          break;

        case 'trip_tips':
          await db.delete(db.tripTips).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) continue;
            final cityId = resolveCityId(str(m, 'city_name'));
            await db
                .into(db.tripTips)
                .insert(
                  TripTipsCompanion.insert(
                    tripId: tripId,
                    cityId: Value(cityId),
                    category: str(m, 'category') ?? '',
                    title: str(m, 'title') ?? '',
                    content: str(m, 'content') ?? '',
                    language: Value(str(m, 'language')),
                  ),
                );
          }
          break;

        case 'packing_items':
          await db.delete(db.packingItems).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) continue;
            await db
                .into(db.packingItems)
                .insert(
                  PackingItemsCompanion.insert(
                    tripId: tripId,
                    item: str(m, 'item') ?? '',
                    category: Value(str(m, 'category')),
                    quantity: Value(intVal(m, 'quantity') ?? 1),
                    isPacked: Value(boolVal(m, 'is_packed')),
                    notes: Value(str(m, 'notes')),
                  ),
                );
          }
          break;

        case 'contacts':
          await db.delete(db.contacts).go();
          for (final row in rows) {
            final m = rowToMap(row);
            final tripId = resolveTripId();
            if (tripId == null) continue;
            await db
                .into(db.contacts)
                .insert(
                  ContactsCompanion.insert(
                    tripId: tripId,
                    name: str(m, 'name') ?? '',
                    role: Value(str(m, 'role')),
                    phone: Value(str(m, 'phone')),
                    email: Value(str(m, 'email')),
                    notes: Value(str(m, 'notes')),
                  ),
                );
          }
          break;
      }
    });
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
