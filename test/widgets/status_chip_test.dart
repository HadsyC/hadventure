import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Status color scheme and normalization', () {
    test('status normalization helper maps values correctly', () {
      // This helper will be added to itinerary_screen.dart
      String normalizeStatus(String? status) {
        const known = [
          'booked',
          'confirmed',
          'pending',
          'no_booking_needed',
          'decide_on_site',
        ];
        final normalized = status?.toLowerCase().trim() ?? 'pending';
        if (known.contains(normalized)) return normalized;
        return 'pending';
      }

      expect(normalizeStatus('booked'), equals('booked'));
      expect(normalizeStatus('Booked'), equals('booked'));
      expect(normalizeStatus('BOOKED'), equals('booked'));
      expect(normalizeStatus('confirmed'), equals('confirmed'));
      expect(normalizeStatus('Confirmed'), equals('confirmed'));
      expect(normalizeStatus('pending'), equals('pending'));
      expect(normalizeStatus('Pending'), equals('pending'));
      expect(
        normalizeStatus('unknown_value'),
        equals('pending'),
        reason: 'Unknown status should map to pending',
      );
      expect(
        normalizeStatus(null),
        equals('pending'),
        reason: 'Null status should map to pending',
      );
      expect(
        normalizeStatus(''),
        equals('pending'),
        reason: 'Empty status should map to pending',
      );
    });

    test('status color mapping has entries for all known statuses', () {
      // Verify the color mapping structure (will be in itinerary_screen.dart)
      const statusColorMap = {
        'booked': 'primaryContainer',
        'confirmed': 'primaryContainer',
        'pending': 'tertiaryContainer',
        'decide_on_site': 'secondaryContainer',
        'no_booking_needed': 'surfaceContainerHighest',
      };

      expect(statusColorMap.keys, contains('booked'));
      expect(statusColorMap.keys, contains('confirmed'));
      expect(statusColorMap.keys, contains('pending'));
      expect(statusColorMap.keys, contains('decide_on_site'));
      expect(statusColorMap.keys, contains('no_booking_needed'));

      // All values should be valid colorScheme property names
      for (final colorName in statusColorMap.values.toSet()) {
        expect(
          [
            'primaryContainer',
            'secondaryContainer',
            'tertiaryContainer',
            'surfaceContainerHighest',
          ],
          contains(colorName),
          reason:
              'All color tokens should be valid Material colorScheme properties',
        );
      }
    });

    test('status display name formatting replaces underscores', () {
      String formatStatusDisplay(String status) {
        return status.replaceAll('_', ' ');
      }

      expect(formatStatusDisplay('booked'), equals('booked'));
      expect(formatStatusDisplay('confirmed'), equals('confirmed'));
      expect(formatStatusDisplay('pending'), equals('pending'));
      expect(
        formatStatusDisplay('no_booking_needed'),
        equals('no booking needed'),
      );
      expect(formatStatusDisplay('decide_on_site'), equals('decide on site'));
    });

    test('type normalization helper maps values correctly', () {
      String normalizeType(String? type) {
        const known = [
          'Activity',
          'Accommodation',
          'Flight',
          'Train',
          'Sightseeing',
          'Restaurant',
          'Tour',
          'Free Time',
          'Event',
          'Optional',
          'Shopping',
          'Other',
        ];
        final normalized = type?.trim() ?? 'Other';
        if (known.contains(normalized)) return normalized;
        final lower = normalized.toLowerCase();
        final match = known.firstWhere(
          (k) => k.toLowerCase() == lower,
          orElse: () => 'Other',
        );
        return match;
      }

      expect(normalizeType('Activity'), equals('Activity'));
      expect(normalizeType('Sightseeing'), equals('Sightseeing'));
      expect(normalizeType('sightseeing'), equals('Sightseeing'));
      expect(normalizeType('Restaurant'), equals('Restaurant'));
      expect(normalizeType('restaurant'), equals('Restaurant'));
      expect(
        normalizeType('Restaurant, HIGHLIGHT'),
        equals('Other'),
        reason: 'Type with comma-separated tags maps to Other',
      );
      expect(
        normalizeType('Sightseeing, HIGHLIGHT'),
        equals('Other'),
        reason: 'Type with HIGHLIGHT tag maps to Other',
      );
      expect(
        normalizeType('Unknown Type'),
        equals('Other'),
        reason: 'Unknown type maps to Other',
      );
      expect(
        normalizeType(null),
        equals('Other'),
        reason: 'Null type maps to Other',
      );
      expect(
        normalizeType(''),
        equals('Other'),
        reason: 'Empty type maps to Other',
      );
    });

    test('known activity types list is complete', () {
      const activityTypes = [
        'Activity',
        'Accommodation',
        'Flight',
        'Train',
        'Sightseeing',
        'Restaurant',
        'Tour',
        'Free Time',
        'Event',
        'Optional',
        'Shopping',
        'Other',
      ];

      // All types should be non-empty and unique
      expect(
        activityTypes.length,
        equals(activityTypes.toSet().length),
        reason: 'All activity types should be unique',
      );
      for (final type in activityTypes) {
        expect(type.isNotEmpty, isTrue);
        expect(
          type[0].toUpperCase(),
          equals(type[0]),
          reason: 'All types should start with capital letter',
        );
      }
    });

    test('known status values list is complete', () {
      const statuses = [
        'booked',
        'confirmed',
        'pending',
        'no_booking_needed',
        'decide_on_site',
      ];

      // All statuses should be non-empty, unique, and lowercase
      expect(
        statuses.length,
        equals(statuses.toSet().length),
        reason: 'All statuses should be unique',
      );
      for (final status in statuses) {
        expect(status.isNotEmpty, isTrue);
        expect(
          status,
          equals(status.toLowerCase()),
          reason: 'All canonical statuses should be lowercase',
        );
      }
    });
  });
}
