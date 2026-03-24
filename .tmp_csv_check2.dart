import 'dart:io';
import 'package:csv/csv.dart';

void main() {
  final content = File('raw_files/cities.csv').readAsStringSync();
  final rowsA = const CsvToListConverter(eol: '\n').convert(content);
  final rowsB = const CsvToListConverter().convert(content);
  print('with_eol_n=${rowsA.length}');
  print('default=${rowsB.length}');
}
