import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:hadventure/core/database/queries.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

class PackingItemsScreen extends StatefulWidget {
  const PackingItemsScreen({super.key});

  @override
  State<PackingItemsScreen> createState() => _PackingItemsScreenState();
}

class _PackingItemsScreenState extends State<PackingItemsScreen> {
  bool _loading = true;
  List<PackingItem> _items = [];
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
        _items = [];
        _loading = false;
      });
      return;
    }

    final items = await (db.select(
      db.packingItems,
    )..where((p) => p.tripId.equals(trip.id))).get();

    items.sort((a, b) {
      final categoryCompare = (a.category ?? 'Other').compareTo(
        b.category ?? 'Other',
      );
      if (categoryCompare != 0) return categoryCompare;
      return a.item.compareTo(b.item);
    });

    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _togglePacked(PackingItem item, bool packed) async {
    final db = DatabaseProvider.of(context);
    await (db.update(db.packingItems)..where((p) => p.id.equals(item.id)))
        .write(PackingItemsCompanion(isPacked: Value(packed)));
    await _load();
  }

  Future<void> _setAllPacked(bool packed) async {
    final db = DatabaseProvider.of(context);
    for (final item in _filteredItems) {
      await (db.update(db.packingItems)..where((p) => p.id.equals(item.id)))
          .write(PackingItemsCompanion(isPacked: Value(packed)));
    }
    await _load();
  }

  List<String> get _categories {
    final values = _items
        .map((e) => e.category?.trim())
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  List<PackingItem> get _filteredItems {
    if (_selectedCategory == null) return _items;
    return _items.where((i) => i.category == _selectedCategory).toList();
  }

  Map<String, List<PackingItem>> get _grouped {
    final grouped = <String, List<PackingItem>>{};
    for (final item in _filteredItems) {
      final category = item.category?.trim().isNotEmpty == true
          ? item.category!.trim()
          : 'Other';
      grouped.putIfAbsent(category, () => <PackingItem>[]).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grouped = _grouped;
    final total = _filteredItems.length;
    final packed = _filteredItems.where((i) => i.isPacked).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Packing List')),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.checklist_outlined),
                      title: Text('$packed / $total packed'),
                      subtitle: LinearProgressIndicator(
                        value: total == 0 ? 0 : packed / total,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      ),
                      ..._categories.map(
                        (c) => FilterChip(
                          label: Text(c),
                          selected: _selectedCategory == c,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = c),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _filteredItems.isEmpty
                              ? null
                              : () => _setAllPacked(true),
                          icon: const Icon(Icons.done_all),
                          label: const Text('Mark all packed'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _filteredItems.isEmpty
                              ? null
                              : () => _setAllPacked(false),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Clear all'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_items.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No packing items imported yet.'),
                      ),
                    )
                  else if (grouped.isEmpty)
                    const Card(
                      child: ListTile(title: Text('No items for this filter.')),
                    )
                  else
                    ...grouped.entries.map((entry) {
                      final category = entry.key;
                      final items = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  4,
                                ),
                                child: Text(
                                  category,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...items.asMap().entries.map((e) {
                                final i = e.key;
                                final item = e.value;
                                return Column(
                                  children: [
                                    CheckboxListTile(
                                      value: item.isPacked,
                                      title: Text(item.item),
                                      subtitle: Text(
                                        [
                                          if (item.quantity > 1)
                                            'Qty: ${item.quantity}',
                                          if (item.notes?.trim().isNotEmpty ==
                                              true)
                                            item.notes!.trim(),
                                        ].join(' • '),
                                      ),
                                      onChanged: (value) {
                                        if (value == null) return;
                                        _togglePacked(item, value);
                                      },
                                    ),
                                    if (i < items.length - 1)
                                      Divider(
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                        color: colorScheme.outlineVariant,
                                      ),
                                  ],
                                );
                              }),
                            ],
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
