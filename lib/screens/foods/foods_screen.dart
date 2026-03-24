import 'package:flutter/material.dart';
import 'package:hadventure/core/database/queries.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/widgets/linkify_text.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  bool _loading = true;
  List<Food> _foods = [];
  List<City> _cities = [];
  int? _selectedCityId;
  String? _selectedCategory;

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
        _foods = [];
        _cities = [];
        _loading = false;
      });
      return;
    }

    final foods = await db.foodsForTrip(trip.id);
    final cities = await db.citiesForTrip(trip.id);

    if (!mounted) return;
    setState(() {
      _foods = foods;
      _cities = cities;
      _loading = false;
    });
  }

  String _cityName(int cityId) {
    return _cities
            .where((c) => c.id == cityId)
            .map((c) => c.name)
            .firstOrNull ??
        'Unknown city';
  }

  List<String> get _categories {
    final values = _foods
        .map((e) => e.category?.trim())
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  List<Food> get _filtered {
    var list = List<Food>.from(_foods);
    if (_selectedCityId != null) {
      list = list.where((f) => f.cityId == _selectedCityId).toList();
    }
    if (_selectedCategory != null) {
      list = list.where((f) => f.category == _selectedCategory).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Restaurants')),
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
                    runSpacing: 8,
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
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All categories'),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      ),
                      ..._categories.map(
                        (category) => FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = category),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_foods.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No food recommendations imported yet.'),
                      ),
                    )
                  else if (_filtered.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No restaurants for this filter.'),
                      ),
                    )
                  else
                    ..._filtered.map((food) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.restaurant_outlined),
                          title: Text(food.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                [
                                  _cityName(food.cityId),
                                  if (food.category?.isNotEmpty == true)
                                    food.category!,
                                ].join(' · '),
                              ),
                              if (food.recommendedDishes?.trim().isNotEmpty ==
                                  true)
                                Text(
                                  'Dishes: ${food.recommendedDishes!.trim()}',
                                ),
                              if (food.avgPriceCny != null ||
                                  food.avgPriceEur != null)
                                Text(
                                  'Avg: ${food.avgPriceCny == null ? '-' : '¥${food.avgPriceCny!.toStringAsFixed(0)}'} / ${food.avgPriceEur == null ? '-' : '€${food.avgPriceEur!.toStringAsFixed(2)}'}',
                                ),
                              if (food.amapUrl?.trim().isNotEmpty == true)
                                LinkifyText(text: food.amapUrl!.trim()),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: food.category?.trim().isNotEmpty == true
                              ? Chip(label: Text(food.category!.trim()))
                              : null,
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
