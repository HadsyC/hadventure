import 'dart:io';
import 'package:csv/csv.dart';

void main() {
  final content = File('raw_files/cities.csv').readAsStringSync();
  final rows = const CsvToListConverter(eol: '\n').convert(content);
  print('rows_with_header=${rows.length}');
  if (rows.isNotEmpty) {
    print('data_rows=${rows.skip(1).where((r) => r.any((c) => c.toString().trim().isNotEmpty)).length}');
  }
}
