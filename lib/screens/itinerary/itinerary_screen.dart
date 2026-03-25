import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/queries.dart';
import '../../core/widgets/linkify_text.dart';

// ── ITINERARY STATUS & TYPE HELPERS ──────────────────────────────────────────

const _knownStatuses = [
  'booked',
  'confirmed',
  'pending',
  'no_booking_needed',
  'decide_on_site',
];

const _knownActivityTypes = [
  'Activity',
  'Accommodation',
  'Flight',
  'Train',
  'Sightseeing',
  'Restaurant',
  'Tour',
  'Free Time',
  'Event',
  'Optional',
  'Shopping',
  'Other',
];

/// Normalize status value to canonical lowercase form, defaulting to 'pending' for unknown values.
String _normalizeStatus(String? status) {
  final normalized = status?.toLowerCase().trim() ?? 'pending';
  if (_knownStatuses.contains(normalized)) return normalized;
  return 'pending';
}

/// Normalize activity type, defaulting to 'Other' for unknown values.
String _normalizeActivityType(String? type) {
  final normalized = type?.trim() ?? 'Other';
  // Try exact match first
  if (_knownActivityTypes.contains(normalized)) return normalized;
  // Try case-insensitive match
  final lower = normalized.toLowerCase();
  final match = _knownActivityTypes.firstWhere(
    (k) => k.toLowerCase() == lower,
    orElse: () => 'Other',
  );
  return match;
}

/// Get (background color, foreground color) for a status value.
/// Uses Material colorScheme tokens for consistency with theme.
(Color, Color) _statusColors(String status, ColorScheme colorScheme) {
  final normalized = _normalizeStatus(status);
  final colorMap = {
    'booked': (colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
    'confirmed': (colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
    'pending': (colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
    'no_booking_needed': (
      colorScheme.surfaceContainerHighest,
      colorScheme.onSurfaceVariant,
    ),
    'decide_on_site': (
      colorScheme.secondaryContainer,
      colorScheme.onSecondaryContainer,
    ),
  };
  return colorMap[normalized] ??
      (colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant);
}

class ItineraryOpenRequest {
  final int tabIndex;
  final int? flightId;
  final int? trainId;
  final int? hotelId;

  const ItineraryOpenRequest({
    required this.tabIndex,
    this.flightId,
    this.trainId,
    this.hotelId,
  });
}

class ItineraryScreen extends StatefulWidget {
  final String? filterCity;
  final DateTime? filterDate;
  final ValueChanged<ItineraryOpenRequest>? onOpenLinkedView;

  const ItineraryScreen({
    super.key,
    this.filterCity,
    this.filterDate,
    this.onOpenLinkedView,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  static const String _autoCreatedImportCityNote =
      'Auto-created from itinerary import';
  int? _selectedCityId;
  List<City> _cities = [];
  List<ItineraryData> _itineraries = [];
  Map<int, String> _citySummariesByCityId = const {};
  final Set<int> _expandedCitySummaries = <int>{};
  bool _loading = true;
  bool _initialized = false;

  Future<void> _openExternalUrl(String href) async {
    final uri = Uri.tryParse(href);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
    if (trip == null) {
      setState(() => _loading = false);
      return;
    }
    final cities = await db.citiesForTrip(trip.id);
    final itineraries = await db.allItinerariesForTrip(trip.id);
    final summaries = await db.citySummariesForTrip(trip.id);

    final summaryByCity = <int, String>{};
    for (final summary in summaries) {
      final existing = summaryByCity[summary.cityId];
      if (existing == null || existing.isEmpty) {
        summaryByCity[summary.cityId] = summary.summaryText;
      } else {
        summaryByCity[summary.cityId] = '$existing\n\n${summary.summaryText}';
      }
    }

    setState(() {
      _cities = cities;
      _itineraries = itineraries;
      _citySummariesByCityId = summaryByCity;
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

  List<City> get _filterChipCities => _cities
      .where(
        (c) =>
            !(c.notes?.toLowerCase().contains(
                  _autoCreatedImportCityNote.toLowerCase(),
                ) ??
                false),
      )
      .toList();

  List<ItineraryData> get _filtered {
    var list = List<ItineraryData>.from(_itineraries);
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

  Map<String, List<ItineraryData>> get _grouped {
    final Map<String, List<ItineraryData>> grouped = {};
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

  DateTime _itineraryDateTime(ItineraryData item) {
    final rawTime = item.time?.trim();
    final hhmm = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(rawTime ?? '');
    if (hhmm == null) return item.date;

    final hour = int.tryParse(hhmm.group(1) ?? '') ?? 0;
    final minute = int.tryParse(hhmm.group(2) ?? '') ?? 0;
    return DateTime(
      item.date.year,
      item.date.month,
      item.date.day,
      hour,
      minute,
    );
  }

  int _distanceMinutes(DateTime a, DateTime b) =>
      a.difference(b).inMinutes.abs();

  Future<ItineraryOpenRequest?> _resolveLinkedRequest(
    ItineraryData item,
  ) async {
    final db = DatabaseProvider.of(context);

    if (item.flightId != null) {
      return ItineraryOpenRequest(tabIndex: 3, flightId: item.flightId);
    }
    if (item.trainId != null) {
      return ItineraryOpenRequest(tabIndex: 4, trainId: item.trainId);
    }
    if (item.hotelId != null) {
      return ItineraryOpenRequest(tabIndex: 5, hotelId: item.hotelId);
    }

    final city = _cities
        .where((c) => c.id == item.cityId)
        .cast<City?>()
        .firstOrNull;
    if (city == null) return null;

    final haystack = '${item.type ?? ''} ${item.title} ${item.notes ?? ''}'
        .toLowerCase();
    final targetTime = _itineraryDateTime(item);

    final isFlight = haystack.contains('flight');
    final isTrain = haystack.contains('train');
    final isHotel =
        haystack.contains('hotel') ||
        haystack.contains('check in') ||
        haystack.contains('check-in') ||
        haystack.contains('check out') ||
        haystack.contains('checkout');

    if (isFlight) {
      final allFlights = await (db.select(
        db.flights,
      )..where((f) => f.tripId.equals(city.tripId))).get();
      if (allFlights.isEmpty) {
        return const ItineraryOpenRequest(tabIndex: 3);
      }

      Flight pick = allFlights.first;
      var best = _distanceMinutes(targetTime, pick.departure);
      for (final f in allFlights.skip(1)) {
        final score = [
          _distanceMinutes(targetTime, f.departure),
          _distanceMinutes(targetTime, f.arrival),
        ].reduce((a, b) => a < b ? a : b);
        if (score < best) {
          best = score;
          pick = f;
        }
      }

      return ItineraryOpenRequest(tabIndex: 3, flightId: pick.id);
    }

    if (isTrain) {
      final allTrains = await (db.select(
        db.trains,
      )..where((t) => t.tripId.equals(city.tripId))).get();
      if (allTrains.isEmpty) {
        return const ItineraryOpenRequest(tabIndex: 4);
      }

      Train pick = allTrains.first;
      var best = _distanceMinutes(targetTime, pick.departure);
      for (final t in allTrains.skip(1)) {
        final score = [
          _distanceMinutes(targetTime, t.departure),
          _distanceMinutes(targetTime, t.arrival),
        ].reduce((a, b) => a < b ? a : b);
        if (score < best) {
          best = score;
          pick = t;
        }
      }

      return ItineraryOpenRequest(tabIndex: 4, trainId: pick.id);
    }

    if (isHotel) {
      final cityHotels = await (db.select(
        db.hotels,
      )..where((h) => h.cityId.equals(item.cityId))).get();
      if (cityHotels.isEmpty) {
        return const ItineraryOpenRequest(tabIndex: 5);
      }

      final byDate = cityHotels.where((h) {
        if (h.checkIn == null || h.checkOut == null) return false;
        final start = DateTime(
          h.checkIn!.year,
          h.checkIn!.month,
          h.checkIn!.day,
        );
        final end = DateTime(
          h.checkOut!.year,
          h.checkOut!.month,
          h.checkOut!.day,
        );
        final day = DateTime(item.date.year, item.date.month, item.date.day);
        return !day.isBefore(start) && !day.isAfter(end);
      }).toList();

      final pool = byDate.isNotEmpty ? byDate : cityHotels;
      Hotel pick = pool.first;
      var best = pick.checkIn == null
          ? 1 << 30
          : _distanceMinutes(targetTime, pick.checkIn!);
      for (final h in pool.skip(1)) {
        final score = h.checkIn == null
            ? 1 << 30
            : _distanceMinutes(targetTime, h.checkIn!);
        if (score < best) {
          best = score;
          pick = h;
        }
      }

      return ItineraryOpenRequest(tabIndex: 5, hotelId: pick.id);
    }

    return null;
  }

  Future<bool> _openLinkedDestination(ItineraryData item) async {
    final req = await _resolveLinkedRequest(item);
    if (req == null || widget.onOpenLinkedView == null) return false;
    if (!mounted) return false;

    widget.onOpenLinkedView!(req);
    final label = switch (req.tabIndex) {
      3 => 'Flights',
      4 => 'Trains',
      5 => 'Hotels',
      _ => 'Transport',
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opening $label view...')));
    return true;
  }

  void _openEntryView(ItineraryData item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final haystack = '${item.type ?? ''} ${item.title} ${item.notes ?? ''}'
        .toLowerCase();
    final hasDirectLink =
        item.flightId != null || item.trainId != null || item.hotelId != null;
    final canLink =
        hasDirectLink ||
        haystack.contains('flight') ||
        haystack.contains('train') ||
        haystack.contains('hotel') ||
        haystack.contains('check in') ||
        haystack.contains('check-in') ||
        haystack.contains('check out') ||
        haystack.contains('checkout');
    final linkedLabel = canLink
        ? ((item.hotelId != null ||
                  haystack.contains('hotel') ||
                  haystack.contains('check in') ||
                  haystack.contains('check-in') ||
                  haystack.contains('check out') ||
                  haystack.contains('checkout'))
              ? 'Hotels'
              : ((item.trainId != null || haystack.contains('train'))
                    ? 'Trains'
                    : 'Flights'))
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.access_time, size: 16),
                          label: Text(item.time ?? '--:--'),
                        ),
                        if (item.type != null && item.type!.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.label_outline, size: 16),
                            label: Text(item.type!),
                          ),
                        if (item.status != null && item.status!.isNotEmpty)
                          _StatusChip(status: item.status!),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (item.flightId != null)
                    Chip(
                      avatar: const Icon(Icons.flight_outlined, size: 16),
                      label: Text('Flight #${item.flightId}'),
                    ),
                  if (item.trainId != null)
                    Chip(
                      avatar: const Icon(Icons.train_outlined, size: 16),
                      label: Text('Train #${item.trainId}'),
                    ),
                  if (item.hotelId != null)
                    Chip(
                      avatar: const Icon(Icons.hotel_outlined, size: 16),
                      label: Text('Hotel #${item.hotelId}'),
                    ),
                  if (item.type != null && item.type!.isNotEmpty)
                    ActionChip(
                      avatar: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Open linked'),
                      onPressed: !canLink
                          ? null
                          : () async {
                              final opened = await _openLinkedDestination(item);
                              if (!mounted) return;
                              if (opened) Navigator.pop(context);
                            },
                    ),
                ],
              ),
              if (linkedLabel != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final opened = await _openLinkedDestination(item);
                    if (!mounted) return;
                    if (opened) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text('Open $linkedLabel view'),
                ),
              ],
              if (item.url != null && item.url!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Reference Link',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surfaceContainerLow,
                  ),
                  child: LinkifyText(text: item.url!.trim()),
                ),
              ],
              if (item.mapUrl != null && item.mapUrl!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Map Link',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surfaceContainerLow,
                  ),
                  child: LinkifyText(text: item.mapUrl!.trim()),
                ),
              ],
              const SizedBox(height: 14),
              Text(
                'Notes',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: (item.notes != null && item.notes!.trim().isNotEmpty)
                    ? MarkdownBody(
                        data: item.notes!.trim(),
                        selectable: true,
                        styleSheet: MarkdownStyleSheet.fromTheme(
                          theme,
                        ).copyWith(p: theme.textTheme.bodyMedium),
                        onTapLink: (_, href, _) {
                          if (href == null) return;
                          _openExternalUrl(href);
                        },
                      )
                    : Text(
                        'No notes for this entry.',
                        style: theme.textTheme.bodyMedium,
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final opened = await _openLinkedDestination(item);
                      if (!mounted) return;
                      if (opened) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open linked'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openBottomSheet(itinerary: item);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _entrySubtitle(ItineraryData item, ColorScheme colorScheme) {
    final hasType = item.type != null && item.type!.isNotEmpty;
    final hasStatus = item.status != null && item.status!.isNotEmpty;
    final hasNotes = item.notes != null && item.notes!.trim().isNotEmpty;

    if (!hasType && !hasStatus && !hasNotes) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasType || hasStatus)
          Row(
            children: [
              if (hasType) ...[
                Icon(
                  Icons.label_outline,
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  item.type!,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (hasStatus) ...[
                const SizedBox(width: 8),
                _StatusChip(status: item.status!),
              ],
            ],
          ),
        if (hasNotes) ...[
          const SizedBox(height: 6),
          Text(
            item.notes!.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  void _openBottomSheet({ItineraryData? itinerary}) {
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
      builder: (_) => _ItineraryForm(
        itinerary: itinerary,
        cities: _cities,
        onSaved: _loadData,
      ),
    );
  }

  Future<void> _deleteItinerary(ItineraryData a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete itinerary entry?'),
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
      await (db.delete(db.itinerary)..where((a2) => a2.id.equals(a.id))).go();
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grouped = _grouped;
    final sections = grouped.entries.toList();
    final usePinnedSectionHeaders = MediaQuery.of(context).size.width < 900;

    bool isFirstSectionForCity(int sectionIndex, int cityId) {
      for (var i = 0; i < sectionIndex; i++) {
        final priorEntries = sections[i].value;
        if (priorEntries.isNotEmpty && priorEntries.first.cityId == cityId) {
          return false;
        }
      }
      return true;
    }

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
          if (_filterChipCities.isNotEmpty)
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
                    ..._filterChipCities.map(
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
          else if (_itineraries.isEmpty)
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
          else ...[
            ...sections.asMap().entries.expand((entry) {
              final index = entry.key;
              final section = entry.value;
              final key = section.key;
              final entries = section.value;
              if (entries.isEmpty) {
                return <Widget>[
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
                ];
              }
              final cityId = entries.first.cityId;
              final cityName = _cities
                  .where((c) => c.id == cityId)
                  .map((c) => c.name)
                  .firstOrNull;
              final citySummary = _citySummariesByCityId[cityId];
              final showCitySummary =
                  citySummary != null &&
                  citySummary.trim().isNotEmpty &&
                  isFirstSectionForCity(index, cityId);
              final summaryExpanded = _expandedCitySummaries.contains(cityId);

              final sectionHeader = Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        key,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${entries.length} items',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              );

              return <Widget>[
                SliverMainAxisGroup(
                  slivers: [
                    if (showCitySummary)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                        sliver: SliverToBoxAdapter(
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: colorScheme.surfaceContainerLow,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      setState(() {
                                        if (summaryExpanded) {
                                          _expandedCitySummaries.remove(cityId);
                                        } else {
                                          _expandedCitySummaries.add(cityId);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${cityName ?? 'City'} summary',
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: colorScheme.primary,
                                                  ),
                                            ),
                                          ),
                                          Icon(
                                            summaryExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (summaryExpanded)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: MarkdownBody(
                                        data: citySummary.trim(),
                                        selectable: true,
                                        styleSheet:
                                            MarkdownStyleSheet.fromTheme(
                                              theme,
                                            ).copyWith(
                                              p: theme.textTheme.bodyMedium,
                                            ),
                                        onTapLink: (_, href, _) {
                                          if (href == null) return;
                                          _openExternalUrl(href);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (usePinnedSectionHeaders)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickySectionHeaderDelegate(
                          minHeight: 52,
                          maxHeight: 52,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          child: sectionHeader,
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                        sliver: SliverToBoxAdapter(child: sectionHeader),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Column(
                            children: entries.asMap().entries.map((e) {
                              final i = e.key;
                              final item = e.value;
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    leading: Container(
                                      width: 62,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.time ?? '--:--',
                                        style: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    title: Text(item.title),
                                    subtitle: _entrySubtitle(item, colorScheme),
                                    trailing: PopupMenuButton<String>(
                                      tooltip: 'Entry actions',
                                      onSelected: (value) {
                                        if (value == 'view') {
                                          _openEntryView(item);
                                        } else if (value == 'edit') {
                                          _openBottomSheet(itinerary: item);
                                        } else if (value == 'delete') {
                                          _deleteItinerary(item);
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: 'view',
                                          child: Row(
                                            children: [
                                              Icon(Icons.visibility_outlined),
                                              SizedBox(width: 8),
                                              Text('View'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit_outlined),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline),
                                              SizedBox(width: 8),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _openEntryView(item);
                                    },
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
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],
                ),
              ];
            }),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cities.isEmpty ? null : () => _openBottomSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add itinerary entry'),
      ),
    );
  }
}

class _StickySectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Color backgroundColor;
  final Widget child;

  const _StickySectionHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.backgroundColor,
    required this.child,
  }) : assert(minHeight <= maxHeight);

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickySectionHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.child != child;
  }
}

// ── STATUS CHIP ───────────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (bg, fg) = _statusColors(status, colorScheme);
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

// ── ITINERARY FORM (BOTTOM SHEET) ──────────────────────────────────────────────
class _ItineraryForm extends StatefulWidget {
  final ItineraryData? itinerary;
  final List<City> cities;
  final VoidCallback onSaved;

  const _ItineraryForm({
    this.itinerary,
    required this.cities,
    required this.onSaved,
  });

  @override
  State<_ItineraryForm> createState() => _ItineraryFormState();
}

class _ItineraryFormState extends State<_ItineraryForm> {
  late TextEditingController _title;
  late TextEditingController _time;
  late TextEditingController _location;
  late TextEditingController _notes;
  late TextEditingController _url;
  late TextEditingController _price;
  late TextEditingController _flightId;
  late TextEditingController _trainId;
  late TextEditingController _hotelId;
  int? _selectedCityId;
  DateTime? _selectedDate;
  String? _selectedType;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    final a = widget.itinerary;
    _title = TextEditingController(text: a?.title ?? '');
    _time = TextEditingController(text: a?.time ?? '');
    _location = TextEditingController(text: a?.location ?? '');
    _notes = TextEditingController(text: a?.notes ?? '');
    _url = TextEditingController(text: a?.url ?? '');
    _price = TextEditingController(text: a?.price?.toString() ?? '');
    _flightId = TextEditingController(text: a?.flightId?.toString() ?? '');
    _trainId = TextEditingController(text: a?.trainId?.toString() ?? '');
    _hotelId = TextEditingController(text: a?.hotelId?.toString() ?? '');

    // Normalize imported status/type values to prevent dropdown crashes
    // when editing entries with values not in the known lists
    _selectedCityId = a?.cityId ?? widget.cities.firstOrNull?.id;
    _selectedDate = a?.date ?? DateTime.now();
    _selectedType = _normalizeActivityType(a?.type);
    _selectedStatus = _normalizeStatus(a?.status);
  }

  @override
  void dispose() {
    _title.dispose();
    _time.dispose();
    _location.dispose();
    _notes.dispose();
    _url.dispose();
    _price.dispose();
    _flightId.dispose();
    _trainId.dispose();
    _hotelId.dispose();
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
    // Validation: title is required
    if (_title.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Title is required')));
      }
      return;
    }

    // Validation: city is required
    if (widget.cities.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Add a city first')));
      }
      return;
    }

    final cityId = _selectedCityId ?? widget.cities.first.id;
    final db = DatabaseProvider.of(context);

    // Build the companion with all form fields
    var companion = ItineraryCompanion(
      cityId: Value(cityId),
      date: Value(_selectedDate ?? DateTime.now()),
      time: Value(_time.text.trim().isEmpty ? null : _time.text.trim()),
      title: Value(_title.text.trim()),
      type: Value(_selectedType),
      location: Value(
        _location.text.trim().isEmpty ? null : _location.text.trim(),
      ),
      notes: Value(_notes.text.trim().isEmpty ? null : _notes.text.trim()),
      url: Value(_url.text.trim().isEmpty ? null : _url.text.trim()),
      price: Value(double.tryParse(_price.text.trim())),
      status: Value(_selectedStatus),
      flightId: Value(int.tryParse(_flightId.text.trim())),
      trainId: Value(int.tryParse(_trainId.text.trim())),
      hotelId: Value(int.tryParse(_hotelId.text.trim())),
    );

    if (widget.itinerary == null) {
      // Create new: simple insert with form data
      await db.into(db.itinerary).insert(companion);
    } else {
      // Edit: preserve existing mapped fields (mapUrl, addressEn, addressLocal, lat, lng, etc.)
      // that may have come from imports and aren't in the form UI
      final existing = widget.itinerary!;
      companion = companion.copyWith(
        mapUrl: Value(existing.mapUrl),
        addressEn: Value(existing.addressEn),
        addressLocal: Value(existing.addressLocal),
        lat: Value(existing.lat),
        lng: Value(existing.lng),
        duration: Value(existing.duration),
        availability: Value(existing.availability),
        currency: Value(existing.currency),
        bookedAt: Value(existing.bookedAt),
        image: Value(existing.image),
      );

      await (db.update(
        db.itinerary,
      )..where((a) => a.id.equals(widget.itinerary!.id))).write(companion);
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
    final isEdit = widget.itinerary != null;

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
              isEdit ? 'Edit itinerary entry' : 'New itinerary entry',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _FormSection(
              title: 'Core details',
              icon: Icons.event_note_outlined,
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: _selectedCityId,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    items: widget.cities
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCityId = v),
                  ),
                  const SizedBox(height: 12),
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
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.label_outline),
                          ),
                          items: _knownActivityTypes
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedType = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.check_circle_outline),
                          ),
                          items: _knownStatuses
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: _StatusChip(status: s),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedStatus = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _FormSection(
              title: 'Context and booking',
              icon: Icons.description_outlined,
              child: Column(
                children: [
                  TextField(
                    controller: _location,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                ],
              ),
            ),
            const SizedBox(height: 12),

            _FormSection(
              title: 'Linked records',
              icon: Icons.link_outlined,
              subtitle:
                  'Optional IDs used for quick jumps to Flights/Trains/Hotels.',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _flightId,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Flight ID',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.flight_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _trainId,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Train ID',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.train_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _hotelId,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hotel ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.hotel_outlined),
                    ),
                  ),
                ],
              ),
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

class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget child;

  const _FormSection({
    required this.title,
    required this.icon,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 10),
          child,
        ],
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
