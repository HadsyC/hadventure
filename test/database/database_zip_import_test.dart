import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';

void main() {
  group('database zip import fixture', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase.forTest();
    });

    tearDown(() async {
      await testDb.close();
    });

    test('can import representative trip data from zip fixture', () async {
      final zipFile = File('raw_zip/hadventure_china_2026.zip');
      expect(
        zipFile.existsSync(),
        true,
        reason: 'ZIP file not found at ${zipFile.path}',
      );

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

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

      final tripHeaders = csvData['trips']![0]
          .map((e) => e.toString())
          .toList();
      final tripRows = csvData['trips']!.skip(1).toList();
      expect(tripRows, isNotEmpty, reason: 'Expected at least one trip row');
      expect(
        tripHeaders.toSet(),
        containsAll({'name', 'start_date', 'end_date'}),
        reason: 'Trips CSV missing required headers',
      );

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

      final cityHeaders = csvData['cities']![0]
          .map((e) => e.toString())
          .toList();
      final cityRows = csvData['cities']!.skip(1).toList();
      expect(cityRows, isNotEmpty, reason: 'Expected at least one city row');
      expect(
        cityHeaders.toSet(),
        containsAll({'name', 'country'}),
        reason: 'Cities CSV missing required headers',
      );

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

      final flightHeaders = csvData['flights']![0]
          .map((e) => e.toString())
          .toList();
      final flightRows = csvData['flights']!.skip(1).toList();
      expect(
        flightRows,
        isNotEmpty,
        reason: 'Expected at least one flight row',
      );
      expect(
        flightHeaders.toSet(),
        containsAll({'flight_number', 'origin', 'destination'}),
        reason: 'Flights CSV missing required headers',
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

      final trips = await testDb.select(testDb.trips).get();
      expect(trips.length, equals(tripRows.length));
      expect(
        trips.first.startDate,
        equals(
          DateTime.parse(
            tripRows.first[tripHeaders.indexOf('start_date')].toString(),
          ),
        ),
      );

      final cities = await testDb.select(testDb.cities).get();
      expect(cities.length, equals(cityRows.length));
      expect(
        cities.first.name,
        equals(cityRows.first[cityHeaders.indexOf('name')].toString()),
      );

      final flights = await testDb.select(testDb.flights).get();
      expect(flights.length, equals(flightRows.length));
      expect(
        flights.first.flightNumber,
        equals(
          flightRows.first[flightHeaders.indexOf('flight_number')].toString(),
        ),
      );

      final itineraryHeaders = csvData['itinerary']![0]
          .map((e) => e.toString())
          .toList();
      final itineraryRows = csvData['itinerary']!.skip(1).toList();
      expect(
        itineraryRows,
        isNotEmpty,
        reason: 'Expected at least one itinerary row',
      );
      expect(
        itineraryHeaders.toSet(),
        containsAll({
          'city_name',
          'date',
          'title',
          'address_en',
          'address_local',
        }),
        reason: 'Itinerary CSV missing required import headers',
      );

      final cityByName = {
        for (final city in cities) city.name.toLowerCase(): city,
      };

      var insertedItinerary = 0;
      for (final row in itineraryRows) {
        final cityName = row[itineraryHeaders.indexOf('city_name')]
            .toString()
            .toLowerCase();
        final city = cityByName[cityName];
        expect(city, isNotNull, reason: 'Missing city for itinerary row');

        final title = row[itineraryHeaders.indexOf('title')].toString();
        final date = DateTime.parse(
          row[itineraryHeaders.indexOf('date')].toString(),
        );
        final addressEn = row[itineraryHeaders.indexOf('address_en')]
            .toString()
            .trim();
        final addressLocal = row[itineraryHeaders.indexOf('address_local')]
            .toString()
            .trim();

        expect(addressEn, isNotEmpty, reason: 'address_en should not be empty');
        expect(
          addressLocal,
          isNotEmpty,
          reason: 'address_local should not be empty',
        );

        await testDb
            .into(testDb.itinerary)
            .insert(
              ItineraryCompanion.insert(
                cityId: city!.id,
                date: date,
                title: title,
                time: drift.Value(
                  row[itineraryHeaders.indexOf('time')]?.toString(),
                ),
                type: drift.Value(
                  row[itineraryHeaders.indexOf('itinerary_type')]?.toString(),
                ),
                location: drift.Value(
                  row[itineraryHeaders.indexOf('location')]?.toString(),
                ),
                addressEn: drift.Value(addressEn),
                addressLocal: drift.Value(addressLocal),
                mapUrl: drift.Value(
                  row[itineraryHeaders.indexOf('map_url')]?.toString(),
                ),
              ),
            );
        insertedItinerary++;
      }

      final itinerary = await testDb.select(testDb.itinerary).get();
      expect(itinerary.length, equals(insertedItinerary));
    });
  });
}
