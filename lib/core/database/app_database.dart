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
  int get schemaVersion => 4;

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
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hadventure.db'));
    return NativeDatabase.createInBackground(file);
  });
}
