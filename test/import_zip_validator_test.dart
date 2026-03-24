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
      expect(
        missingRequiredZipFilesMessage(missing),
        equals('ZIP is missing required files: itinerary.csv.'),
      );
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

    test('help message text is exact', () {
      expect(
        requiredZipFilesHelpMessage(),
        equals(
          'ZIP file must contain required CSV files: trips.csv, cities.csv, flights.csv, trains.csv, hotels.csv, itinerary.csv, trip_tips.csv.',
        ),
      );
    });

    test('missing-files message is sorted and exact', () {
      final msg = missingRequiredZipFilesMessage({'trains', 'cities'});
      expect(
        msg,
        equals('ZIP is missing required files: cities.csv, trains.csv.'),
      );
    });
  });
}
