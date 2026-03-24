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
    CitySummaries,
    Foods,
    Locations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Private constructor for test databases with in-memory storage
  AppDatabase._test(DatabaseConnection super.connection);

  /// Factory for creating test databases
  factory AppDatabase.forTest() {
    return AppDatabase._test(DatabaseConnection(NativeDatabase.memory()));
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Beta contract: keep a single canonical schema and rebuild on upgrades.
      await _wipeAndRecreateSchema(m);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _wipeAndRecreateSchema(Migrator m) async {
    await customStatement('PRAGMA foreign_keys = OFF');

    const tableNames = <String>[
      'contacts',
      'packing_items',
      'trip_tips',
      'city_summaries',
      'foods',
      'itinerary',
      'hotels',
      'flights',
      'trains',
      'locations',
      'cities',
      'trips',
    ];

    for (final table in tableNames) {
      await customStatement('DROP TABLE IF EXISTS $table');
    }

    await m.createAll();
    await customStatement('PRAGMA foreign_keys = ON');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hadventure.db'));
    return NativeDatabase.createInBackground(file);
  });
}
