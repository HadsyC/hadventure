import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';

void main() {
  group('database schema', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase.forTest();
    });

    tearDown(() async {
      await testDb.close();
    });

    test('declared Drift columns exist in sqlite tables', () async {
      for (final table in testDb.allTables) {
        final sqliteColumns = await _getTableColumns(
          testDb,
          table.actualTableName,
        );
        final declaredColumns = table.$columns.map((c) => c.$name).toSet();

        expect(
          sqliteColumns,
          containsAll(declaredColumns),
          reason:
              'Table ${table.actualTableName} is missing declared columns. '
              'Declared: ${declaredColumns.join(', ')}; '
              'Actual: ${sqliteColumns.join(', ')}',
        );
      }
    });

    test('itinerary table includes expected columns', () async {
      final columns = await _getTableColumns(testDb, 'itinerary');

      final expectedColumns = {
        'id',
        'city_id',
        'lat',
        'lng',
        'date',
        'time',
        'title',
        'type',
        'location',
        'address_en',
        'address_local',
        'map_url',
        'notes',
        'url',
        'price',
        'currency',
        'duration',
        'availability',
        'status',
        'booked_at',
        'flight_id',
        'train_id',
        'hotel_id',
        'image',
      };

      expect(
        columns,
        containsAll(expectedColumns),
        reason:
            'Itinerary table missing required columns. '
            'Found: ${columns.join(", ")}',
      );
    });

    test('hotels table includes expected columns', () async {
      final columns = await _getTableColumns(testDb, 'hotels');

      final expectedColumns = {
        'id',
        'city_id',
        'lat',
        'lng',
        'name',
        'local_name',
        'check_in',
        'check_out',
        'check_in_time',
        'check_out_time',
        'confirmation',
        'phone',
        'website',
        'total_price',
        'price_per_person',
        'price_per_person_night',
        'map_url',
        'hotel_image',
        'address_en',
        'address_local',
      };

      expect(
        columns,
        containsAll(expectedColumns),
        reason:
            'Hotels table missing required columns. '
            'Found: ${columns.join(", ")}',
      );
    });

    test('migration includes locations table', () async {
      final tables = await _getTableNames(testDb);
      expect(
        tables,
        contains('locations'),
        reason: 'Locations table not created in migration v4+',
      );
    });

    test('can insert and retrieve trip data', () async {
      await testDb
          .into(testDb.trips)
          .insert(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
              currency: const drift.Value('EUR'),
              timezone: const drift.Value('Asia/Shanghai'),
            ),
          );

      final trips = await testDb.select(testDb.trips).get();
      expect(trips.length, equals(1));
      expect(trips.first.name, equals('Test Trip'));
    });

    test('can insert and retrieve city data', () async {
      final trip = await testDb
          .into(testDb.trips)
          .insertReturning(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      await testDb
          .into(testDb.cities)
          .insert(
            CitiesCompanion.insert(
              tripId: trip.id,
              name: 'Shanghai',
              country: 'China',
              arrivalDate: drift.Value(DateTime(2026, 4, 3)),
              departureDate: drift.Value(DateTime(2026, 4, 7)),
              notes: const drift.Value('Test city notes'),
            ),
          );

      final cities = await testDb.select(testDb.cities).get();
      expect(cities.length, equals(1));
      expect(cities.first.name, equals('Shanghai'));
      expect(cities.first.notes, equals('Test city notes'));
    });

    test('can insert and retrieve hotel bilingual fields', () async {
      final trip = await testDb
          .into(testDb.trips)
          .insertReturning(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      final city = await testDb
          .into(testDb.cities)
          .insertReturning(
            CitiesCompanion.insert(
              tripId: trip.id,
              name: 'Shanghai',
              country: 'China',
            ),
          );

      await testDb
          .into(testDb.hotels)
          .insertReturning(
            HotelsCompanion.insert(
              cityId: city.id,
              name: 'Test Hotel',
              addressEn: const drift.Value('123 Main St'),
              addressLocal: const drift.Value('主街123号'),
              phone: const drift.Value('+86 21 1234 5678'),
              website: const drift.Value('https://example.com'),
            ),
          );

      final hotels = await testDb.select(testDb.hotels).get();
      expect(hotels.length, equals(1));
      expect(hotels.first.name, equals('Test Hotel'));
      expect(hotels.first.addressEn, equals('123 Main St'));
      expect(hotels.first.addressLocal, equals('主街123号'));
    });

    test('can insert itinerary with optional foreign keys', () async {
      final trip = await testDb
          .into(testDb.trips)
          .insertReturning(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      final city = await testDb
          .into(testDb.cities)
          .insertReturning(
            CitiesCompanion.insert(
              tripId: trip.id,
              name: 'Shanghai',
              country: 'China',
            ),
          );

      await testDb
          .into(testDb.itinerary)
          .insert(
            ItineraryCompanion.insert(
              cityId: city.id,
              date: DateTime(2026, 4, 3),
              title: 'Check-in: Hotel',
              type: const drift.Value('Accommodation'),
              flightId: const drift.Value(null),
              trainId: const drift.Value(null),
              hotelId: const drift.Value(null),
            ),
          );

      final items = await testDb.select(testDb.itinerary).get();
      expect(items.length, equals(1));
      expect(items.first.title, equals('Check-in: Hotel'));
      expect(items.first.flightId, isNull);
      expect(items.first.trainId, isNull);
      expect(items.first.hotelId, isNull);
    });

    test('can insert itinerary with coordinates', () async {
      final trip = await testDb
          .into(testDb.trips)
          .insertReturning(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      final city = await testDb
          .into(testDb.cities)
          .insertReturning(
            CitiesCompanion.insert(
              tripId: trip.id,
              name: 'Shanghai',
              country: 'China',
            ),
          );

      await testDb
          .into(testDb.itinerary)
          .insert(
            ItineraryCompanion.insert(
              cityId: city.id,
              date: DateTime(2026, 4, 3),
              title: 'Bund Walk',
              lat: const drift.Value(31.2304),
              lng: const drift.Value(121.4737),
            ),
          );

      final items = await testDb.select(testDb.itinerary).get();
      expect(items.length, equals(1));
      expect(items.first.lat, equals(31.2304));
      expect(items.first.lng, equals(121.4737));
    });

    test('itinerary foreign keys are persisted correctly', () async {
      final trip = await testDb
          .into(testDb.trips)
          .insertReturning(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      final flight = await testDb
          .into(testDb.flights)
          .insertReturning(
            FlightsCompanion.insert(
              tripId: trip.id,
              flightNumber: 'LH732',
              origin: 'Frankfurt',
              destination: 'Shanghai',
              departure: DateTime(2026, 4, 2),
              arrival: DateTime(2026, 4, 3),
            ),
          );

      final city = await testDb
          .into(testDb.cities)
          .insertReturning(
            CitiesCompanion.insert(
              tripId: trip.id,
              name: 'Shanghai',
              country: 'China',
            ),
          );

      await testDb
          .into(testDb.itinerary)
          .insert(
            ItineraryCompanion.insert(
              cityId: city.id,
              date: DateTime(2026, 4, 3),
              title: 'Arrival',
              type: const drift.Value('Travel'),
              flightId: drift.Value(flight.id),
            ),
          );

      final items = await testDb.select(testDb.itinerary).get();
      expect(items.first.flightId, equals(flight.id));
    });

    test('can insert and retrieve trip tips', () async {
      final trip = await testDb
          .into(testDb.trips)
          .insertReturning(
            TripsCompanion.insert(
              name: 'Test Trip',
              startDate: DateTime(2026, 4, 2),
              endDate: DateTime(2026, 4, 20),
            ),
          );

      await testDb
          .into(testDb.tripTips)
          .insert(
            TripTipsCompanion.insert(
              tripId: trip.id,
              category: 'Safety Tips',
              title: 'Tap water warning',
              content: 'Do not drink tap water',
              language: const drift.Value('English'),
            ),
          );

      final tips = await testDb.select(testDb.tripTips).get();
      expect(tips.length, equals(1));
      expect(tips.first.category, equals('Safety Tips'));
    });
  });
}

Future<Set<String>> _getTableColumns(AppDatabase db, String tableName) async {
  final result = await db.customSelect('PRAGMA table_info($tableName)').get();
  return result.map((row) => row.read<String>('name')).toSet();
}

Future<Set<String>> _getTableNames(AppDatabase db) async {
  final result = await db
      .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
      .get();
  return result.map((row) => row.read<String>('name')).toSet();
}
