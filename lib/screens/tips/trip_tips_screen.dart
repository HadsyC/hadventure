import 'package:flutter/material.dart';
import 'package:hadventure/core/database/queries.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

class TripTipsScreen extends StatefulWidget {
  const TripTipsScreen({super.key});

  @override
  State<TripTipsScreen> createState() => _TripTipsScreenState();
}

class _TripTipsScreenState extends State<TripTipsScreen> {
  bool _loading = true;
  List<TripTip> _tips = [];
  List<City> _cities = [];
  int? _selectedCityId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = DatabaseProvider.of(context);
    final trip = await db.currentTrip;
    if (trip == null) {
      if (!mounted) return;
      setState(() {
        _tips = [];
        _cities = [];
        _loading = false;
      });
      return;
    }

    final tips = await (db.select(
      db.tripTips,
    )..where((t) => t.tripId.equals(trip.id))).get();
    final cities = await db.citiesForTrip(trip.id);

    tips.sort((a, b) {
      final cityCompare = (a.cityId ?? 0).compareTo(b.cityId ?? 0);
      if (cityCompare != 0) return cityCompare;
      final categoryCompare = a.category.compareTo(b.category);
      if (categoryCompare != 0) return categoryCompare;
      return a.title.compareTo(b.title);
    });

    if (!mounted) return;
    setState(() {
      _tips = tips;
      _cities = cities;
      _loading = false;
    });
  }

  String _cityName(int? cityId) {
    if (cityId == null) return 'General';
    return _cities
            .where((c) => c.id == cityId)
            .map((c) => c.name)
            .firstOrNull ??
        'Unknown city';
  }

  List<TripTip> get _filteredTips {
    if (_selectedCityId == null) return _tips;
    return _tips.where((t) => t.cityId == _selectedCityId).toList();
  }

  Map<String, List<TripTip>> get _grouped {
    final grouped = <String, List<TripTip>>{};
    for (final tip in _filteredTips) {
      final city = _cityName(tip.cityId);
      final key = '$city · ${tip.category}';
      grouped.putIfAbsent(key, () => <TripTip>[]).add(tip);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grouped = _grouped;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Trip Tips')),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All cities'),
                        selected: _selectedCityId == null,
                        onSelected: (_) =>
                            setState(() => _selectedCityId = null),
                      ),
                      ..._cities.map(
                        (city) => FilterChip(
                          label: Text(city.name),
                          selected: _selectedCityId == city.id,
                          onSelected: (_) =>
                              setState(() => _selectedCityId = city.id),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_tips.isEmpty)
                    const Card(
                      child: ListTile(title: Text('No tips imported yet.')),
                    )
                  else if (grouped.isEmpty)
                    const Card(
                      child: ListTile(title: Text('No tips for this filter.')),
                    )
                  else
                    ...grouped.entries.map((entry) {
                      final items = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              entry.key,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: items.map((tip) {
                              return ListTile(
                                title: Text(tip.title),
                                subtitle: Text(tip.content),
                                trailing:
                                    tip.language?.trim().isNotEmpty == true
                                    ? Chip(label: Text(tip.language!))
                                    : null,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
