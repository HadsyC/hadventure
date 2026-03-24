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
    Activities,
    Flights,
    Trains,
    PackingItems,
    TripTips,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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

      // Some earlier schema v1 databases missed nullable columns despite
      // version number not changing; repair them defensively.
      await _repairLegacyColumns(this);
    },
    beforeOpen: (details) async {
      // Run lightweight schema repair on every open to handle legacy local DBs.
      await _repairLegacyColumns(this);
    },
  );
}

Future<void> _repairLegacyColumns(AppDatabase db) async {
  await _addColumnIfMissing(db, 'cities', 'notes', 'TEXT');
}

Future<void> _addColumnIfMissing(
  GeneratedDatabase db,
  String table,
  String column,
  String sqlType,
) async {
  final tableInfo = await db.customSelect('PRAGMA table_info($table)').get();
  final exists = tableInfo.any((r) => r.data['name'] == column);
  if (!exists) {
    await db.customStatement('ALTER TABLE $table ADD COLUMN $column $sqlType');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hadventure.db'));
    return NativeDatabase.createInBackground(file);
  });
}
