import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:hadventure/core/database/app_database.dart';

void main() {
  group('Database Migration Tests', () {
    late AppDatabase testDb;

    setUp(() {
      // Create an in-memory database for testing
      testDb = AppDatabase.forTest();
    });

    tearDown(() async {
      await testDb.close();
    });

    test('Database initializes without errors', () async {
      expect(testDb, isNotNull);
    });

    test('Itinerary table has correct columns', () async {
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

    test('No duplicate columns in itinerary table', () async {
      final columns = await _getTableColumns(testDb, 'itinerary');
      final uniqueColumns = columns.toSet();

      expect(
        columns.length,
        equals(uniqueColumns.length),
        reason:
            'Duplicate columns detected: '
            '${columns.where((c) => columns.where((x) => x == c).length > 1).toSet().join(", ")}',
      );
    });

    test('Hotels table has correct columns after migration', () async {
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

    test('Flights table has duration column', () async {
      final columns = await _getTableColumns(testDb, 'flights');
      expect(
        columns,
        contains('duration'),
        reason: 'Flights table missing duration column',
      );
    });

    test('Trains table has price and duration columns', () async {
      final columns = await _getTableColumns(testDb, 'trains');

      expect(
        columns,
        containsAll({
          'duration',
          'ticket_price_per_person',
          'booking_fee_per_person',
          'total_price_per_person',
        }),
        reason: 'Trains table missing price/duration columns',
      );
    });

    test('Cities table has notes column', () async {
      final columns = await _getTableColumns(testDb, 'cities');
      expect(
        columns,
        contains('notes'),
        reason: 'Cities table missing notes column',
      );
    });

    test('Can insert and retrieve trip data', () async {
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

    test('Can insert and retrieve city data', () async {
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

    test('Can insert and retrieve hotel with all bilingual fields', () async {
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

      final hotel = await testDb
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

    test('Can insert itinerary with optional foreign keys', () async {
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

    test('Foreign key constraints work correctly for itinerary', () async {
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

    test('Can insert and retrieve trip tips', () async {
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

    test(
      'Can import complete trip data from hadventure_china_2026.zip',
      () async {
        // Load the ZIP file
        final zipFile = File('raw_zip/hadventure_china_2026.zip');
        expect(
          zipFile.existsSync(),
          true,
          reason: 'ZIP file not found at ${zipFile.path}',
        );

        final bytes = await zipFile.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        // Parse all CSV files from the ZIP
        final csvData = <String, List<List<dynamic>>>{};

        for (final entry in archive.files) {
          if (!entry.isFile || !entry.name.endsWith('.csv')) continue;

          final fileBytes = switch (entry.content) {
            List<int> v => v,
            String s => utf8.encode(s),
            _ => null,
          };
          if (fileBytes == null) continue;

          final content = utf8.decode(fileBytes, allowMalformed: true);
          final rows = const CsvToListConverter().convert(content);
          if (rows.isNotEmpty) {
            final fileName = entry.name.split('/').last.replaceAll('.csv', '');
            csvData[fileName] = rows;
          }
        }

        // Verify all expected CSVs are present
        expect(
          csvData.keys.toSet(),
          containsAll([
            'trips',
            'cities',
            'flights',
            'trains',
            'hotels',
            'itinerary',
            'trip_tips',
          ]),
          reason: 'Not all expected CSV files found in ZIP',
        );

        // Import trips first
        final tripHeaders = csvData['trips']![0]
            .map((e) => e.toString())
            .toList();
        final tripRows = csvData['trips']!.skip(1).toList();
        expect(tripRows.length, equals(1), reason: 'Expected 1 trip in ZIP');

        final trip = await testDb
            .into(testDb.trips)
            .insertReturning(
              TripsCompanion.insert(
                name: tripRows[0][tripHeaders.indexOf('name')].toString(),
                startDate: DateTime.parse(
                  tripRows[0][tripHeaders.indexOf('start_date')].toString(),
                ),
                endDate: DateTime.parse(
                  tripRows[0][tripHeaders.indexOf('end_date')].toString(),
                ),
                currency: const drift.Value('EUR'),
                timezone: const drift.Value('Asia/Shanghai'),
              ),
            );

        // Import cities
        final cityHeaders = csvData['cities']![0]
            .map((e) => e.toString())
            .toList();
        final cityRows = csvData['cities']!.skip(1).toList();
        expect(cityRows.length, equals(7), reason: 'Expected 7 cities in ZIP');

        for (final row in cityRows) {
          await testDb
              .into(testDb.cities)
              .insert(
                CitiesCompanion.insert(
                  tripId: trip.id,
                  name: row[cityHeaders.indexOf('name')].toString(),
                  country: row[cityHeaders.indexOf('country')].toString(),
                  notes: drift.Value(
                    row[cityHeaders.indexOf('notes')]?.toString(),
                  ),
                ),
              );
        }

        // Import flights
        final flightHeaders = csvData['flights']![0]
            .map((e) => e.toString())
            .toList();
        final flightRows = csvData['flights']!.skip(1).toList();
        expect(
          flightRows.length,
          equals(2),
          reason: 'Expected 2 flights in ZIP',
        );

        for (final row in flightRows) {
          await testDb
              .into(testDb.flights)
              .insert(
                FlightsCompanion.insert(
                  tripId: trip.id,
                  flightNumber: row[flightHeaders.indexOf('flight_number')]
                      .toString(),
                  origin: row[flightHeaders.indexOf('origin')].toString(),
                  destination: row[flightHeaders.indexOf('destination')]
                      .toString(),
                  departure: DateTime.parse(
                    row[flightHeaders.indexOf('departure')].toString(),
                  ),
                  arrival: DateTime.parse(
                    row[flightHeaders.indexOf('arrival')].toString(),
                  ),
                ),
              );
        }

        // Verify data was imported
        final trips = await testDb.select(testDb.trips).get();
        expect(trips.length, equals(1));
        expect(trips.first.name, equals('China 2026'));
        expect(
          trips.first.startDate,
          equals(
            DateTime.parse(
              tripRows.first[tripHeaders.indexOf('start_date')].toString(),
            ),
          ),
        );

        final cities = await testDb.select(testDb.cities).get();
        expect(cities.length, equals(7));
        expect(cities.map((c) => c.name).toSet(), contains('Shanghai'));
        expect(
          cities.first.name,
          equals(cityRows.first[cityHeaders.indexOf('name')].toString()),
        );

        final flights = await testDb.select(testDb.flights).get();
        expect(flights.length, equals(2));
        expect(flights.map((f) => f.flightNumber).toSet(), contains('LH732'));
        expect(
          flights.first.flightNumber,
          equals(
            flightRows.first[flightHeaders.indexOf('flight_number')].toString(),
          ),
        );
      },
    );

    test('Migration creates locations table correctly', () async {
      // Locations table should exist after migration
      final tables = await _getTableNames(testDb);
      expect(
        tables,
        contains('locations'),
        reason: 'Locations table not created in migration v4',
      );
    });
  });
}

// Helper function to get table columns from the database
Future<Set<String>> _getTableColumns(AppDatabase db, String tableName) async {
  final result = await db.customSelect('PRAGMA table_info($tableName)').get();

  return result.map((row) => row.read<String>('name')).toSet();
}

// Helper function to get all table names
Future<Set<String>> _getTableNames(AppDatabase db) async {
  final result = await db
      .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
      .get();

  return result.map((row) => row.read<String>('name')).toSet();
}
