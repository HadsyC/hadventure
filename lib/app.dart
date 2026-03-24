import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'navigation/app_shell.dart';

class HadventureApp extends StatelessWidget {
  const HadventureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hadventure',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}
