import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generated zip header contract', () {
    late Archive archive;

    setUpAll(() async {
      final file = File('raw_zip/hadventure_china_2026.zip');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'Missing generated ZIP artifact',
      );
      archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    });

    List<String> headersFor(String csvName) {
      final entry = archive.files.firstWhere(
        (f) => f.isFile && f.name.toLowerCase().endsWith(csvName),
        orElse: () => throw StateError('Missing $csvName in ZIP'),
      );
      final bytes = switch (entry.content) {
        List<int> value => value,
        String value => utf8.encode(value),
        _ => <int>[],
      };
      final rows = const CsvToListConverter().convert(
        utf8.decode(bytes, allowMalformed: true),
      );
      expect(rows, isNotEmpty, reason: '$csvName is empty');
      return rows.first.map((e) => e.toString()).toList();
    }

    test('hotels.csv uses generalized headers', () {
      final headers = headersFor('hotels.csv');

      expect(headers, contains('address_local'));
      expect(headers, contains('map_url'));
      expect(headers, isNot(contains('address_cn')));
      expect(headers, isNot(contains('amap_url')));
    });

    test('itinerary.csv uses generalized headers', () {
      final headers = headersFor('itinerary.csv');

      expect(headers, containsAll(['address_en', 'address_local', 'map_url']));
      expect(headers, isNot(contains('address_cn')));
      expect(headers, isNot(contains('amap_url')));
    });
  });
}
