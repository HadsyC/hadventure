import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/itinerary/itinerary_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/flights/flights_screen.dart';
import '../screens/hotels/hotels_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/data/data_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  String? _filterCity;
  DateTime? _filterDate;

  void _navigateTo(int index, {String? city, DateTime? date}) {
    setState(() {
      _selectedIndex = index;
      _filterCity = city;
      _filterDate = date;
    });
  }

  List<Widget> get _screens => [
    DashboardScreen(onNavigate: _navigateTo),
    ItineraryScreen(filterCity: _filterCity, filterDate: _filterDate),
    const MapScreen(),
    const FlightsScreen(),
    const HotelsScreen(),
    const SettingsScreen(),
    const DataScreen(),
  ];

  final List<({IconData icon, IconData selectedIcon, String label})>
  _destinations = const [
    (
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    (
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Itinerary',
    ),
    (icon: Icons.map_outlined, selectedIcon: Icons.map, label: 'Map'),
    (icon: Icons.flight_outlined, selectedIcon: Icons.flight, label: 'Flights'),
    (icon: Icons.hotel_outlined, selectedIcon: Icons.hotel, label: 'Hotels'),
    (
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
    (
      icon: Icons.import_export_outlined,
      selectedIcon: Icons.import_export,
      label: 'Data',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() {
                _selectedIndex = i;
                _filterCity = null;
                _filterDate = null;
              }),
              labelType: NavigationRailLabelType.none,
              minWidth: 64,
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      icon: Tooltip(
                        message: d.label,
                        preferBelow: false,
                        waitDuration: Duration.zero,
                        child: Icon(d.icon, size: 20),
                      ),
                      selectedIcon: Tooltip(
                        message: d.label,
                        preferBelow: false,
                        waitDuration: Duration.zero,
                        child: Icon(d.selectedIcon, size: 20),
                      ),
                      label: const SizedBox.shrink(),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _screens[_selectedIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() {
          _selectedIndex = i;
          _filterCity = null;
          _filterDate = null;
        }),
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
