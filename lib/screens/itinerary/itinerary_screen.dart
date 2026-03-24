import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/queries.dart';

class ItineraryScreen extends StatefulWidget {
  final String? filterCity;
  final DateTime? filterDate;

  const ItineraryScreen({super.key, this.filterCity, this.filterDate});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  int? _selectedCityId;
  List<City> _cities = [];
  List<Activity> _activities = [];
  bool _loading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadData();
    }
  }

  @override
  void didUpdateWidget(ItineraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterCity != oldWidget.filterCity ||
        widget.filterDate != oldWidget.filterDate) {
      _applyFilterFromWidget();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final db = DatabaseProvider.of(context);
    final trip = await db.currentTrip;
    print('DEBUG trip: $trip');
    if (trip == null) {
      setState(() => _loading = false);
      return;
    }
    final cities = await db.citiesForTrip(trip.id);
    print('DEBUG cities: ${cities.length}');
    final activities = await db.allActivitiesForTrip(trip.id);
    print('DEBUG activities: ${activities.length}');

    setState(() {
      _cities = cities;
      _activities = activities;
      _loading = false;
    });
    _applyFilterFromWidget();
  }

  void _applyFilterFromWidget() {
    if (widget.filterCity != null) {
      final match = _cities
          .where(
            (c) => c.name.toLowerCase() == widget.filterCity!.toLowerCase(),
          )
          .firstOrNull;
      if (match != null) setState(() => _selectedCityId = match.id);
    }
  }

  List<Activity> get _filtered {
    var list = List<Activity>.from(_activities);
    if (_selectedCityId != null) {
      list = list.where((a) => a.cityId == _selectedCityId).toList();
    }
    if (widget.filterDate != null) {
      final f = widget.filterDate!;
      list = list
          .where(
            (a) =>
                a.date.year == f.year &&
                a.date.month == f.month &&
                a.date.day == f.day,
          )
          .toList();
    }
    return list;
  }

  Map<String, List<Activity>> get _grouped {
    final Map<String, List<Activity>> grouped = {};
    for (final a in _filtered) {
      final city = _cities.firstWhere(
        (c) => c.id == a.cityId,
        orElse: () => City(id: 0, tripId: 0, name: '?', country: ''),
      );
      final key = '${city.name} · ${_formatDate(a.date)}';
      grouped.putIfAbsent(key, () => []).add(a);
    }
    return grouped;
  }

  void _openBottomSheet({Activity? activity}) {
    if (_cities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a city first before adding itinerary items.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ActivityForm(
        activity: activity,
        cities: _cities,
        onSaved: _loadData,
      ),
    );
  }

  Future<void> _deleteActivity(Activity a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete activity?'),
        content: Text('This will permanently delete "${a.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final db = DatabaseProvider.of(context);
      await (db.delete(db.activities)..where((a2) => a2.id.equals(a.id))).go();
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grouped = _grouped;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Itinerary'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                tooltip: 'Clear filter',
                onPressed: () => setState(() => _selectedCityId = null),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // City filter chips
          if (_cities.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedCityId == null,
                      onSelected: (_) => setState(() => _selectedCityId = null),
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
              ),
            ),

          // Body
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_activities.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No itinerary items yet.',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Import a CSV or tap + to add one.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (grouped.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No entries for this filter.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final keys = grouped.keys.toList();
                  final key = keys[index];
                  final entries = grouped[key]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          key,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Column(
                          children: entries.asMap().entries.map((e) {
                            final i = e.key;
                            final item = e.value;
                            return Column(
                              children: [
                                ListTile(
                                  leading: Text(
                                    item.time ?? '--:--',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  title: Text(item.title),
                                  subtitle: item.activityType != null
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.label_outline,
                                              size: 12,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.activityType!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            if (item.status != null) ...[
                                              const SizedBox(width: 8),
                                              _StatusChip(status: item.status!),
                                            ],
                                          ],
                                        )
                                      : null,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            _openBottomSheet(activity: item),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: colorScheme.error,
                                        ),
                                        onPressed: () => _deleteActivity(item),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _openBottomSheet(activity: item),
                                ),
                                if (i < entries.length - 1)
                                  Divider(
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    color: colorScheme.outlineVariant,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }, childCount: grouped.length),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cities.isEmpty ? null : () => _openBottomSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add activity'),
      ),
    );
  }
}

// ── STATUS CHIP ───────────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = {
      'booked': (colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
      'confirmed': (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      'pending': (
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
      ),
      'decide_on_site': (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      'no_booking_needed': (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
      ),
    };
    final (bg, fg) =
        colors[status] ??
        (colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ── ACTIVITY FORM (BOTTOM SHEET) ──────────────────────────────────────────────
class _ActivityForm extends StatefulWidget {
  final Activity? activity;
  final List<City> cities;
  final VoidCallback onSaved;

  const _ActivityForm({
    this.activity,
    required this.cities,
    required this.onSaved,
  });

  @override
  State<_ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<_ActivityForm> {
  late TextEditingController _title;
  late TextEditingController _time;
  late TextEditingController _location;
  late TextEditingController _notes;
  late TextEditingController _url;
  late TextEditingController _price;
  int? _selectedCityId;
  DateTime? _selectedDate;
  String? _selectedType;
  String? _selectedStatus;

  final _activityTypes = [
    'Sightseeing',
    'Restaurant',
    'Tour',
    'Flight',
    'Train',
    'Hotel',
    'Free Time',
    'Event',
    'Optional',
    'Shopping',
    'Other',
  ];
  final _statuses = [
    'booked',
    'confirmed',
    'pending',
    'no_booking_needed',
    'decide_on_site',
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.activity;
    _title = TextEditingController(text: a?.title ?? '');
    _time = TextEditingController(text: a?.time ?? '');
    _location = TextEditingController(text: a?.location ?? '');
    _notes = TextEditingController(text: a?.notes ?? '');
    _url = TextEditingController(text: a?.url ?? '');
    _price = TextEditingController(text: a?.price?.toString() ?? '');
    _selectedCityId = a?.cityId ?? widget.cities.firstOrNull?.id;
    _selectedDate = a?.date ?? DateTime.now();
    _selectedType = a?.activityType;
    _selectedStatus = a?.status;
  }

  @override
  void dispose() {
    _title.dispose();
    _time.dispose();
    _location.dispose();
    _notes.dispose();
    _url.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    if (widget.cities.isEmpty) return;

    final cityId = _selectedCityId ?? widget.cities.first.id;
    final db = DatabaseProvider.of(context);
    final companion = ActivitiesCompanion(
      cityId: Value(cityId),
      date: Value(_selectedDate ?? DateTime.now()),
      time: Value(_time.text.trim().isEmpty ? null : _time.text.trim()),
      title: Value(_title.text.trim()),
      activityType: Value(_selectedType),
      location: Value(
        _location.text.trim().isEmpty ? null : _location.text.trim(),
      ),
      notes: Value(_notes.text.trim().isEmpty ? null : _notes.text.trim()),
      url: Value(_url.text.trim().isEmpty ? null : _url.text.trim()),
      price: Value(double.tryParse(_price.text.trim())),
      status: Value(_selectedStatus),
    );

    if (widget.activity == null) {
      await db.into(db.activities).insert(companion);
    } else {
      await (db.update(
        db.activities,
      )..where((a) => a.id.equals(widget.activity!.id))).write(companion);
    }
    if (mounted) {
      Navigator.pop(context);
      widget.onSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEdit = widget.activity != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              isEdit ? 'Edit activity' : 'New activity',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // City
            DropdownButtonFormField<int>(
              value: _selectedCityId,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              items: widget.cities
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedCityId = v),
            ),
            const SizedBox(height: 12),

            // Date
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                _selectedDate != null
                    ? _formatDate(_selectedDate!)
                    : 'Pick a date',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
            const SizedBox(height: 12),

            // Time + Title
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _time,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                      hintText: '09:00',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Type + Status
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    items: _activityTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedType = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.check_circle_outline),
                    ),
                    items: _statuses
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.replaceAll('_', ' ')),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedStatus = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Location
            TextField(
              controller: _location,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            TextField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),

            // URL + Price
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _url,
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price (€)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.euro),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: Text(isEdit ? 'Save' : 'Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
}
