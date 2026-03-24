import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';
import 'package:hadventure/core/database/database_provider.dart';
import 'package:hadventure/screens/data/data_screen.dart';

void main() {
  group('DataScreen', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase.forTest();
    });

    tearDown(() async {
      await testDb.close();
    });

    testWidgets('Reset button clears imported data after confirmation', (
      WidgetTester tester,
    ) async {
      // Seed DB with minimal data so reset has something to delete.
      await testDb
          .into(testDb.trips)
          .insert(
            TripsCompanion.insert(
              name: 'China 2026',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      await tester.pumpWidget(
        MaterialApp(
          home: DatabaseProvider(database: testDb, child: const DataScreen()),
        ),
      );

      // Tap reset and confirm in dialog.
      await tester.tap(find.text('Reset all data'));
      await tester.pumpAndSettle();

      expect(find.text('Reset all data?'), findsOneWidget);
      await tester.tap(find.text('Reset everything'));
      await tester.pumpAndSettle();

      // Verify seeded data is gone.
      final trips = await testDb.select(testDb.trips).get();
      final cities = await testDb.select(testDb.cities).get();
      final hotels = await testDb.select(testDb.hotels).get();
      final flights = await testDb.select(testDb.flights).get();
      final trains = await testDb.select(testDb.trains).get();
      final itinerary = await testDb.select(testDb.itinerary).get();
      final tips = await testDb.select(testDb.tripTips).get();
      final packing = await testDb.select(testDb.packingItems).get();
      final contacts = await testDb.select(testDb.contacts).get();

      expect(trips, isEmpty);
      expect(cities, isEmpty);
      expect(hotels, isEmpty);
      expect(flights, isEmpty);
      expect(trains, isEmpty);
      expect(itinerary, isEmpty);
      expect(tips, isEmpty);
      expect(packing, isEmpty);
      expect(contacts, isEmpty);
    });
  });
}
