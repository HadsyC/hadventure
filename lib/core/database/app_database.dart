import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Trips,
    Contacts,
    Cities,
    Hotels,
    Itinerary,
    Flights,
    Trains,
    PackingItems,
    TripTips,
    Locations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Private constructor for test databases with in-memory storage
  AppDatabase._test(DatabaseConnection connection) : super(connection);

  /// Factory for creating test databases
  factory AppDatabase.forTest() {
    return AppDatabase._test(DatabaseConnection(NativeDatabase.memory()));
  }

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(hotels, hotels.checkInTime);
        await m.addColumn(hotels, hotels.checkOutTime);
        await m.addColumn(hotels, hotels.totalPrice);
        await m.addColumn(hotels, hotels.pricePerPerson);
        await m.addColumn(hotels, hotels.pricePerPersonNight);
        await m.addColumn(hotels, hotels.mapUrl);

        await m.addColumn(flights, flights.duration);

        await m.addColumn(trains, trains.duration);
        await m.addColumn(trains, trains.ticketPricePerPerson);
        await m.addColumn(trains, trains.bookingFeePerPerson);
        await m.addColumn(trains, trains.totalPricePerPerson);
      }

      if (from < 4) {
        // Create new Locations table for map pins with bilingual addresses
        await m.createTable(locations);
      }

      if (from < 5) {
        await _normalizeItineraryTableForV5(this, m);
      }

      if (from < 6) {
        await m.addColumn(itinerary, itinerary.addressEn);
        await m.addColumn(itinerary, itinerary.addressLocal);
        await m.addColumn(itinerary, itinerary.mapUrl);
      }
    },
  );

  Future<void> runV5NormalizationForTest() async {
    await _normalizeItineraryTableForV5(this, createMigrator());
  }
}

Future<void> _normalizeItineraryTableForV5(AppDatabase db, Migrator m) async {
  final originalColumns = await db
      .customSelect('PRAGMA table_info(itinerary)')
      .get();
  final names = originalColumns
      .map((r) => (r.data['name'] ?? '').toString())
      .toSet();

  // Fresh v4+ DBs already have the complete shape.
  if (names.contains('lat') && names.contains('lng')) {
    return;
  }

  await db.customStatement('ALTER TABLE itinerary RENAME TO itinerary_old_v4');
  await m.createTable(db.itinerary);

  String selectOrNull(String column) {
    return names.contains(column) ? column : 'NULL AS $column';
  }

  await db.customStatement('''
    INSERT INTO itinerary (
      id,
      city_id,
      lat,
      lng,
      date,
      time,
      title,
      type,
      location,
      address_en,
      address_local,
      map_url,
      notes,
      url,
      price,
      currency,
      duration,
      availability,
      status,
      booked_at,
      flight_id,
      train_id,
      hotel_id,
      image
    )
    SELECT
      id,
      city_id,
      ${selectOrNull('lat')},
      ${selectOrNull('lng')},
      date,
      time,
      title,
      type,
      location,
      ${selectOrNull('address_en')},
      ${selectOrNull('address_local')},
      ${selectOrNull('map_url')},
      notes,
      url,
      price,
      currency,
      duration,
      availability,
      status,
      booked_at,
      ${selectOrNull('flight_id')},
      ${selectOrNull('train_id')},
      ${selectOrNull('hotel_id')},
      ${selectOrNull('image')}
    FROM itinerary_old_v4
  ''');

  await db.customStatement('DROP TABLE itinerary_old_v4');
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hadventure.db'));
    return NativeDatabase.createInBackground(file);
  });
}
