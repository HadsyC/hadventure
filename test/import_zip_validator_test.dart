import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/screens/data/import_zip_validator.dart';

void main() {
  group('ZIP required tables validation', () {
    test('fails when a required table is missing', () {
      final available = {
        'trips',
        'cities',
        'flights',
        'trains',
        'hotels',
        'trip_tips',
        // Missing itinerary
      };

      final missing = missingRequiredZipTables(available);

      expect(missing, contains('itinerary'));
      expect(hasAllRequiredZipTables(available), isFalse);
    });

    test('passes when all required tables are present', () {
      final available = {
        'trips',
        'cities',
        'flights',
        'trains',
        'hotels',
        'itinerary',
        'trip_tips',
      };

      final missing = missingRequiredZipTables(available);

      expect(missing, isEmpty);
      expect(hasAllRequiredZipTables(available), isTrue);
    });
  });
}
