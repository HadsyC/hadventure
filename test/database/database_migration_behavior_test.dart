import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';

void main() {
  group('database migration behavior', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase.forTest();
    });

    tearDown(() async {
      await testDb.close();
    });

    test(
      'v5 normalization adds itinerary coordinates for legacy table shape',
      () async {
        await testDb.customStatement('DROP TABLE itinerary');
        await testDb.customStatement('''
        CREATE TABLE itinerary (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          city_id INTEGER NOT NULL,
          date INTEGER NOT NULL,
          time TEXT NULL,
          title TEXT NOT NULL,
          type TEXT NULL,
          location TEXT NULL,
          notes TEXT NULL,
          url TEXT NULL,
          price REAL NULL,
          currency TEXT NULL,
          duration INTEGER NULL,
          availability TEXT NULL,
          status TEXT NULL,
          booked_at INTEGER NULL,
          flight_id INTEGER NULL,
          train_id INTEGER NULL,
          hotel_id INTEGER NULL,
          image TEXT NULL
        )
      ''');

        final before = await _getTableColumns(testDb, 'itinerary');
        expect(before, isNot(contains('lat')));
        expect(before, isNot(contains('lng')));

        await testDb.runV5NormalizationForTest();

        final after = await _getTableColumns(testDb, 'itinerary');
        expect(after, contains('lat'));
        expect(after, contains('lng'));
      },
    );
  });
}

Future<Set<String>> _getTableColumns(AppDatabase db, String tableName) async {
  final result = await db.customSelect('PRAGMA table_info($tableName)').get();
  return result.map((row) => row.read<String>('name')).toSet();
}
