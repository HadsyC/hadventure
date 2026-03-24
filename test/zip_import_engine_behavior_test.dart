import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';
import 'package:hadventure/screens/data/import_zip_validator.dart';
import 'package:hadventure/screens/data/zip_import_engine.dart';

File _resolveZipFixture() {
  final preferred = File('raw_zip/hadventure_china_2026_simple_import.zip');
  if (preferred.existsSync()) return preferred;

  final fallback = File(
    'raw_zip/hadventure_china_2026_import_20260324_170444.zip',
  );
  if (fallback.existsSync()) return fallback;

  throw StateError(
    'No ZIP fixture found. Expected raw_zip/hadventure_china_2026_simple_import.zip or raw_zip/hadventure_china_2026_import_20260324_170444.zip',
  );
}

void main() {
  group('ZIP import full flow (step-by-step)', () {
    late AppDatabase db;
    late ZipImportEngine engine;
    late File zipFile;

    setUp(() {
      db = AppDatabase.forTest();
      engine = const ZipImportEngine();
      zipFile = _resolveZipFixture();
    });

    tearDown(() async {
      await db.close();
    });

    test('step 1: parses real ZIP into expected tables', () async {
      final parsed = await engine.parseZipFile(zipFile);

      expect(parsed.byTable, isNotEmpty);
      expect(parsed.byTable.keys, containsAll(requiredZipTables));

      final itineraryPayload = parsed.byTable['itinerary'];
      expect(itineraryPayload, isNotNull);
      expect(itineraryPayload!.dataRows.length, greaterThan(0));
      expect(itineraryPayload.headers, contains('city_name'));
      expect(itineraryPayload.headers, contains('title'));
      expect(itineraryPayload.headers, contains('date'));
    });

    test('step 2: validates required-table contract before import', () async {
      final parsed = await engine.parseZipFile(zipFile);

      final missing = missingRequiredZipTables(parsed.byTable.keys);
      expect(missing, isEmpty);
      expect(hasAllRequiredZipTables(parsed.byTable.keys), isTrue);
    });

    test(
      'step 3: imports from ZIP through the full engine entrypoint',
      () async {
        final result = await engine.importFromFile(db: db, zipFile: zipFile);

        expect(result.totalTables, greaterThan(0));
        expect(result.totalInserted, greaterThan(0));

        final itinerarySummary = result.tableSummaries.firstWhere(
          (s) => s.tableName == 'itinerary',
        );
        expect(itinerarySummary.insertedRows, greaterThan(0));
      },
    );

    test(
      'step 4: persists expected rows and inferred city from itinerary',
      () async {
        final result = await engine.importFromFile(db: db, zipFile: zipFile);

        final cityNames = (await db.select(db.cities).get())
            .map((c) => c.name)
            .toSet();
        expect(cityNames.contains('Frankfurt'), isTrue);
        expect(cityNames.contains('Shanghai'), isTrue);

        final itinerary = await db.select(db.itinerary).get();
        final itineraryTitles = itinerary.map((r) => r.title).toSet();

        expect(itineraryTitles.contains('Flight to Shanghai'), isTrue);
        expect(itineraryTitles.contains('Arrival in Frankfurt'), isTrue);

        expect(
          result.diagnostics.any(
            (d) => d.contains('Missing itinerary title or date'),
          ),
          isTrue,
        );
      },
    );
  });
}
