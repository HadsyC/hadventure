import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/screens/data/import_schema.dart';

void main() {
  group('import schema contract', () {
    test('normalizes raw headers deterministically', () {
      expect(normalizeImportHeader('Address [en]'), equals('address_en'));
      expect(normalizeImportHeader('Price p.P.'), equals('price_p_p'));
      expect(normalizeImportHeader(' City / Region '), equals('city_region'));
    });

    test('maps raw aliases to canonical keys', () {
      final aliases = buildAliasToCanonical();

      expect(aliases['address_en'], equals('address_en'));
      expect(aliases['address_cn'], equals('address_local'));
      expect(aliases['address_local'], equals('address_local'));
      expect(aliases['amap_url'], equals('map_url'));
      expect(aliases['map_url'], equals('map_url'));
      expect(aliases['live_tracker_url'], equals('tracker_url'));
      expect(aliases['flight_id'], equals('flight_id'));
      expect(aliases['city_region'], equals('city_name'));
      expect(aliases['price_p_p'], equals('price_pp'));
      expect(aliases['price_p_p_p_night'], equals('price_pp_night'));
    });

    test('required zip tables remain stable', () {
      expect(
        requiredZipTables,
        containsAll({
          'trips',
          'cities',
          'flights',
          'trains',
          'hotels',
          'itinerary',
          'trip_tips',
        }),
      );
    });
  });
}
