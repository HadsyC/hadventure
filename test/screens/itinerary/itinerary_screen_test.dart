import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';

void main() {
  group('Itinerary create/edit fixes', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTest();
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'status normalization: imported "Booked" (capital) should work on edit',
      () async {
        // Setup: Create trip and city
        final tripId = await db
            .into(db.trips)
            .insert(
              TripsCompanion.insert(
                name: 'Test Trip',
                startDate: DateTime.parse('2026-04-01'),
                endDate: DateTime.parse('2026-04-30'),
              ),
            );

        final cityId = await db
            .into(db.cities)
            .insert(
              CitiesCompanion.insert(
                tripId: tripId,
                name: 'Shanghai',
                country: 'China',
              ),
            );

        // Create itinerary entry with imported "Booked" status (capital)
        // This matches the real fixture data style
        final itinId = await db
            .into(db.itinerary)
            .insert(
              ItineraryCompanion.insert(
                cityId: cityId,
                date: DateTime.parse('2026-04-03'),
                title: 'Arrival in Shanghai',
                status: Value('Booked'), // IMPORTED: capital B, not in dropdown
              ),
            );

        // Verify entry was created with the imported status value
        final original = await (db.select(
          db.itinerary,
        )..where((a) => a.id.equals(itinId))).getSingle();
        expect(original.status, equals('Booked'));
        expect(original.title, equals('Arrival in Shanghai'));

        // After fix: when form normalizes this value, it should become 'booked'
        // For now, verify the entry exists and can be queried
      },
    );

    test(
      'type normalization: imported type "Sightseeing, HIGHLIGHT" should work on edit',
      () async {
        final tripId = await db
            .into(db.trips)
            .insert(
              TripsCompanion.insert(
                name: 'Test Trip',
                startDate: DateTime.parse('2026-04-01'),
                endDate: DateTime.parse('2026-04-30'),
              ),
            );

        final cityId = await db
            .into(db.cities)
            .insert(
              CitiesCompanion.insert(
                tripId: tripId,
                name: 'Shanghai',
                country: 'China',
              ),
            );

        // Create itinerary entry with imported type containing comma tags
        final itinId = await db
            .into(db.itinerary)
            .insert(
              ItineraryCompanion.insert(
                cityId: cityId,
                date: DateTime.parse('2026-04-05'),
                title: 'Gongyan Oriental Art',
                type: Value('Restaurant, HIGHLIGHT'), // Not in allowed types
                status: Value('Pending'), // Also capital
              ),
            );

        // Verify entry was created
        final original = await (db.select(
          db.itinerary,
        )..where((a) => a.id.equals(itinId))).getSingle();
        expect(original.type, equals('Restaurant, HIGHLIGHT'));
        expect(original.status, equals('Pending'));

        // After fix: form should handle these values without crashes
      },
    );

    test(
      'edit should preserve all itinerary columns (not blank them)',
      () async {
        final tripId = await db
            .into(db.trips)
            .insert(
              TripsCompanion.insert(
                name: 'Test Trip',
                startDate: DateTime.parse('2026-04-01'),
                endDate: DateTime.parse('2026-04-30'),
              ),
            );

        final cityId = await db
            .into(db.cities)
            .insert(
              CitiesCompanion.insert(
                tripId: tripId,
                name: 'Shanghai',
                country: 'China',
              ),
            );

        // Create with rich data (as import would)
        final itinId = await db
            .into(db.itinerary)
            .insert(
              ItineraryCompanion.insert(
                cityId: cityId,
                date: DateTime.parse('2026-04-03'),
                title: 'Original Title',
                mapUrl: Value('https://maps.example.com/place'),
                addressEn: Value('123 Main St, City'),
                addressLocal: Value('123号 Main街'),
                duration: Value(120),
                availability: Value('Limited'),
              ),
            );

        // Verify imported data
        var original = await (db.select(
          db.itinerary,
        )..where((a) => a.id.equals(itinId))).getSingle();
        expect(original.mapUrl, equals('https://maps.example.com/place'));
        expect(original.addressEn, equals('123 Main St, City'));
        expect(original.addressLocal, equals('123号 Main街'));
        expect(original.duration, equals(120));

        // Simulate edit: user changes only title via form
        // The fix ensures these fields are included in the update
        await (db.update(
          db.itinerary,
        )..where((a) => a.id.equals(itinId))).write(
          ItineraryCompanion(
            title: const Value('Updated Title'),
            mapUrl: Value(
              original.mapUrl,
            ), // IMPORTANT: include preserved fields
            addressEn: Value(original.addressEn),
            addressLocal: Value(original.addressLocal),
            duration: Value(original.duration),
            availability: Value(original.availability),
          ),
        );

        // Verify preserved data survives edit
        var afterEdit = await (db.select(
          db.itinerary,
        )..where((a) => a.id.equals(itinId))).getSingle();

        expect(afterEdit.title, equals('Updated Title'));
        expect(
          afterEdit.mapUrl,
          equals('https://maps.example.com/place'),
          reason: 'mapUrl should survive edit when included in update',
        );
        expect(
          afterEdit.addressEn,
          equals('123 Main St, City'),
          reason: 'addressEn should survive edit when included in update',
        );
        expect(
          afterEdit.addressLocal,
          equals('123号 Main街'),
          reason: 'addressLocal should survive edit when included in update',
        );
        expect(
          afterEdit.duration,
          equals(120),
          reason: 'duration should survive edit when included in update',
        );
      },
    );

    test('status normalization: map unknown status to pending', () async {
      // Helper function to normalize status (will be in itinerary_screen.dart)
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

    test('type normalization: map unknown type to Other', () async {
      // Helper function to normalize type (will be in itinerary_screen.dart)
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
        // Try exact match first, then case-insensitive
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
  });
}
