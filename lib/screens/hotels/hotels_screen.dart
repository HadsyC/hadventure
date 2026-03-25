import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/queries.dart';
import '../../core/widgets/linkify_text.dart';

enum _HotelSortMode { checkIn, price, city }

class HotelsScreen extends StatefulWidget {
  final int? highlightedHotelId;

  const HotelsScreen({super.key, this.highlightedHotelId});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  bool _initialized = false;
  List<Hotel> _hotels = [];
  Map<int, City> _cityById = {};
  int? _selectedCityId;
  DateTime? _selectedDate;
  _HotelSortMode _sortMode = _HotelSortMode.checkIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _load();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = DatabaseProvider.of(context);
    final trip = await db.currentTrip;

    if (trip == null) {
      setState(() {
        _hotels = [];
        _cityById = {};
        _loading = false;
      });
      return;
    }

    final cities = await db.citiesForTrip(trip.id);
    final cityById = {for (final c in cities) c.id: c};
    if (cities.isEmpty) {
      setState(() {
        _hotels = [];
        _cityById = cityById;
        _loading = false;
      });
      return;
    }

    final cityIds = cities.map((c) => c.id).toList();
    final hotels = await (db.select(
      db.hotels,
    )..where((h) => h.cityId.isIn(cityIds))).get();
    hotels.sort((a, b) {
      final ad = a.checkIn ?? DateTime(2100);
      final bd = b.checkIn ?? DateTime(2100);
      return ad.compareTo(bd);
    });

    if (!mounted) return;
    setState(() {
      _hotels = hotels;
      _cityById = cityById;
      _loading = false;
    });
  }

  List<Hotel> get _filteredHotels {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = _hotels.where((hotel) {
      final city = _cityById[hotel.cityId];

      if (_selectedCityId != null && hotel.cityId != _selectedCityId) {
        return false;
      }

      if (_selectedDate != null && !_isDateInStay(hotel, _selectedDate!)) {
        return false;
      }

      if (query.isEmpty) return true;

      final haystack = <String?>[
        hotel.name,
        hotel.localName,
        city?.name,
        hotel.addressEn,
        hotel.addressLocal,
      ].whereType<String>().join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();

    filtered.sort((a, b) {
      switch (_sortMode) {
        case _HotelSortMode.checkIn:
          final ad = a.checkIn ?? DateTime(2100);
          final bd = b.checkIn ?? DateTime(2100);
          return ad.compareTo(bd);
        case _HotelSortMode.price:
          final ap = a.totalPrice ?? double.infinity;
          final bp = b.totalPrice ?? double.infinity;
          final priceOrder = ap.compareTo(bp);
          if (priceOrder != 0) return priceOrder;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case _HotelSortMode.city:
          final ac = (_cityById[a.cityId]?.name ?? '').toLowerCase();
          final bc = (_cityById[b.cityId]?.name ?? '').toLowerCase();
          final cityOrder = ac.compareTo(bc);
          if (cityOrder != 0) return cityOrder;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
    });

    return filtered;
  }

  String get _sortLabel {
    switch (_sortMode) {
      case _HotelSortMode.checkIn:
        return 'Sort: Check-in';
      case _HotelSortMode.price:
        return 'Sort: Price';
      case _HotelSortMode.city:
        return 'Sort: City';
    }
  }

  bool _isDateInStay(Hotel hotel, DateTime filterDate) {
    if (hotel.checkIn == null && hotel.checkOut == null) return true;
    final date = DateTime(filterDate.year, filterDate.month, filterDate.day);
    final checkIn = hotel.checkIn == null
        ? null
        : DateTime(
            hotel.checkIn!.year,
            hotel.checkIn!.month,
            hotel.checkIn!.day,
          );
    final checkOut = hotel.checkOut == null
        ? null
        : DateTime(
            hotel.checkOut!.year,
            hotel.checkOut!.month,
            hotel.checkOut!.day,
          );

    if (checkIn != null && date.isBefore(checkIn)) return false;
    if (checkOut != null && date.isAfter(checkOut)) return false;
    return true;
  }

  double _stayProgress(Hotel hotel) {
    final start = hotel.checkIn;
    final end = hotel.checkOut;
    if (start == null || end == null) return 0;
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    if (!endDate.isAfter(startDate)) return 1;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (today.isBefore(startDate)) return 0;
    if (today.isAfter(endDate)) return 1;

    final elapsed = today.difference(startDate).inDays.toDouble();
    final total = endDate.difference(startDate).inDays.toDouble();
    if (total <= 0) return 1;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String _nightsLabel(Hotel hotel) {
    if (hotel.checkIn == null || hotel.checkOut == null) return '-- nights';
    final nights = hotel.checkOut!.difference(hotel.checkIn!).inDays;
    if (nights <= 0) return '0 nights';
    return '$nights ${nights == 1 ? 'night' : 'nights'}';
  }

  Future<void> _pickDateFilter() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 4),
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedDate = picked);
  }

  Future<void> _openExternalHttpUrl(String href) async {
    final uri = Uri.tryParse(href);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _callHotel(String phone) async {
    final cleaned = phone.trim();
    if (cleaned.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: cleaned);
    await launchUrl(uri);
  }

  void _openViewSheet(Hotel hotel) {
    final theme = Theme.of(context);
    final city = _cityById[hotel.cityId];
    final priceLabel = _priceLabel(hotel.totalPrice);
    final ppLabel = _priceLabel(hotel.pricePerPerson);
    final ppNightLabel = _priceLabel(hotel.pricePerPersonNight);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hotel.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hotel.localName?.isNotEmpty == true)
                Text(
                  hotel.localName!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 6),
              Text(city?.name ?? 'Unknown city'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (hotel.totalPrice != null)
                    Chip(
                      avatar: const Icon(Icons.payments_outlined, size: 18),
                      label: Text('Total $priceLabel'),
                    ),
                  if (hotel.pricePerPerson != null)
                    Chip(
                      avatar: const Icon(Icons.person_outline, size: 18),
                      label: Text('Per person $ppLabel'),
                    ),
                  if (hotel.pricePerPersonNight != null)
                    Chip(
                      avatar: const Icon(Icons.nights_stay_outlined, size: 18),
                      label: Text('Per night $ppNightLabel'),
                    ),
                ],
              ),
              if (hotel.addressEn?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text('Address (EN)', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(hotel.addressEn!),
              ],
              if (hotel.addressLocal?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text('Address (Local)', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(hotel.addressLocal!),
              ],
              const SizedBox(height: 12),
              Text('Stay details', style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(
                'Check-in: ${_fmtDate(hotel.checkIn)} ${hotel.checkInTime ?? ''}',
              ),
              Text(
                'Check-out: ${_fmtDate(hotel.checkOut)} ${hotel.checkOutTime ?? ''}',
              ),
              Text(_nightsLabel(hotel)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (hotel.mapUrl?.isNotEmpty == true)
                    FilledButton.tonalIcon(
                      onPressed: () => _openExternalHttpUrl(hotel.mapUrl!),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Open map'),
                    ),
                  if (hotel.website?.isNotEmpty == true)
                    FilledButton.tonalIcon(
                      onPressed: () => _openExternalHttpUrl(hotel.website!),
                      icon: const Icon(Icons.language_outlined),
                      label: const Text('Website'),
                    ),
                  if (hotel.phone?.isNotEmpty == true)
                    FilledButton.tonalIcon(
                      onPressed: () => _callHotel(hotel.phone!),
                      icon: const Icon(Icons.call_outlined),
                      label: const Text('Call'),
                    ),
                ],
              ),
              if (hotel.website?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text('Website', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                LinkifyText(text: hotel.website!),
              ],
              if (hotel.mapUrl?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text('Map', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                LinkifyText(text: hotel.mapUrl!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredHotels = _filteredHotels;
    final cityChoices = _cityById.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Hotels')),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel stays',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Track your check-ins, compare rates, and jump quickly to maps and booking links.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search hotel, city, or address',
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      tooltip: 'Clear search',
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('All cities'),
                                  selected: _selectedCityId == null,
                                  onSelected: (_) {
                                    setState(() => _selectedCityId = null);
                                  },
                                ),
                                const SizedBox(width: 8),
                                ...cityChoices.map(
                                  (city) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(city.name),
                                      selected: _selectedCityId == city.id,
                                      onSelected: (_) {
                                        setState(() {
                                          _selectedCityId = city.id;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _pickDateFilter,
                                icon: const Icon(Icons.event_outlined),
                                label: Text(
                                  _selectedDate == null
                                      ? 'Filter by date'
                                      : 'Date: ${_fmtDate(_selectedDate)}',
                                ),
                              ),
                              if (_selectedDate != null)
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() => _selectedDate = null);
                                  },
                                  icon: const Icon(Icons.clear),
                                  label: const Text('Clear date'),
                                ),
                              PopupMenuButton<_HotelSortMode>(
                                tooltip: 'Sort hotels',
                                onSelected: (mode) {
                                  setState(() => _sortMode = mode);
                                },
                                initialValue: _sortMode,
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: _HotelSortMode.checkIn,
                                    child: Text('Sort by check-in'),
                                  ),
                                  PopupMenuItem(
                                    value: _HotelSortMode.price,
                                    child: Text('Sort by total price'),
                                  ),
                                  PopupMenuItem(
                                    value: _HotelSortMode.city,
                                    child: Text('Sort by city'),
                                  ),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color: colorScheme.surface,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.sort_outlined, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        _sortLabel,
                                        style: theme.textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                '${filteredHotels.length} shown',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_hotels.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No hotels for current trip.'),
                      ),
                    )
                  else if (filteredHotels.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No hotels match your filters.'),
                        subtitle: Text(
                          'Try a different city, date, or search.',
                        ),
                      ),
                    )
                  else
                    ...filteredHotels.map((h) {
                      final city = _cityById[h.cityId];
                      final progress = _stayProgress(h);
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        color: widget.highlightedHotelId == h.id
                            ? colorScheme.primaryContainer
                            : null,
                        child: InkWell(
                          onTap: () => _openViewSheet(h),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.hotel_outlined,
                                        size: 18,
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            h.name,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            city?.name ?? 'Unknown city',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.open_in_new_outlined,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${_fmtDate(h.checkIn)} - ${_fmtDate(h.checkOut)}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _nightsLabel(h),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    backgroundColor:
                                        colorScheme.surfaceContainerHighest,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stay progress ${(progress * 100).round()}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    if (h.totalPrice != null)
                                      _InfoChip(
                                        icon: Icons.payments_outlined,
                                        text:
                                            'Total ${_priceLabel(h.totalPrice)}',
                                      ),
                                    if (h.pricePerPerson != null)
                                      _InfoChip(
                                        icon: Icons.person_outline,
                                        text:
                                            'p.p. ${_priceLabel(h.pricePerPerson)}',
                                      ),
                                    if (h.pricePerPersonNight != null)
                                      _InfoChip(
                                        icon: Icons.nights_stay_outlined,
                                        text:
                                            'p.p./night ${_priceLabel(h.pricePerPersonNight)}',
                                      ),
                                  ],
                                ),
                              ],
                            ),
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

  String _priceLabel(double? value) {
    if (value == null) return '--';
    final rounded = value.toStringAsFixed(2);
    return rounded.endsWith('.00')
        ? rounded.substring(0, rounded.length - 3)
        : rounded;
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '--';
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
