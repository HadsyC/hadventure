import 'package:flutter/material.dart';
import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';
import 'app.dart';

late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();
  runApp(DatabaseProvider(database: database, child: const HadventureApp()));
}
