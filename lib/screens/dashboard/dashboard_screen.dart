import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/queries.dart';
import '../../core/services/weather_service.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int index, {String? city, DateTime? date}) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;
  bool _initialized = false;
  bool _refreshingWeather = false;
  _DashboardSnapshot? _snapshot;
  final WeatherService _weatherService = WeatherService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadDashboard();
    }
  }

  Future<void> _loadDashboard() async {
    setState(() => _loading = true);
    final db = DatabaseProvider.of(context);
    final trip = await db.currentTrip;

    if (trip == null) {
      if (!mounted) return;
      setState(() {
        _snapshot = null;
        _loading = false;
      });
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final cities = await db.citiesForTrip(trip.id);
    final cityById = {for (final city in cities) city.id: city};

    final allItineraries = await db.allItinerariesForTrip(trip.id);
    final itineraryMoments = allItineraries.map(_itineraryDateTime).toList()
      ..sort();
    final itineraryDates =
        allItineraries
            .map(
              (item) =>
                  DateTime(item.date.year, item.date.month, item.date.day),
            )
            .toList()
          ..sort();

    final firstItineraryMoment = itineraryMoments.isEmpty
        ? null
        : itineraryMoments.first;
    final firstItineraryDate = itineraryDates.isEmpty
        ? null
        : itineraryDates.first;
    final lastItineraryDate = itineraryDates.isEmpty
        ? null
        : itineraryDates.last;

    final isBeforeTripWindow =
        firstItineraryDate != null && today.isBefore(firstItineraryDate);
    final isAfterTripWindow =
        lastItineraryDate != null && today.isAfter(lastItineraryDate);
    final isInTripWindow =
        firstItineraryDate != null &&
        lastItineraryDate != null &&
        !today.isBefore(firstItineraryDate) &&
        !today.isAfter(lastItineraryDate);

    final todayItinerary =
        allItineraries.where((item) => _isSameDay(item.date, today)).toList()
          ..sort(_compareItineraryByTimeThenTitle);

    final tomorrowItinerary =
        allItineraries.where((item) => _isSameDay(item.date, tomorrow)).toList()
          ..sort(_compareItineraryByTimeThenTitle);

    final tomorrowFirst = _pickFirstTimedItinerary(tomorrowItinerary);

    Hotel? hotel = await db.activeHotelForTripOnDate(trip.id, today);
    if (hotel == null && isBeforeTripWindow) {
      hotel = await db.nextHotelForTripAfterDate(trip.id, today);
    }

    final weatherCity = chooseWeatherCityForDashboard(
      cityById: cityById,
      todayItinerary: todayItinerary,
      tomorrowFirst: tomorrowFirst,
      hotel: hotel,
      allCities: cities,
    );

    final weather = weatherCity == null
        ? null
        : await _weatherService.fetchCurrentWeather(
            city: weatherCity.name,
            lat: weatherCity.lat,
            lng: weatherCity.lng,
          );

    final flightsToday = isInTripWindow
        ? await db.flightsForTripOnDate(trip.id, today)
        : <Flight>[];
    final trainsToday = isInTripWindow
        ? await db.trainsForTripOnDate(trip.id, today)
        : <Train>[];

    final todayTip = await _pickTodayTip(
      db,
      trip.id,
      todayItinerary.map((item) => item.cityId).toSet(),
    );

    final daysUntilStart = isBeforeTripWindow && firstItineraryMoment != null
        ? firstItineraryMoment.difference(now).inDays
        : null;

    if (!mounted) return;
    setState(() {
      _snapshot = _DashboardSnapshot(
        trip: trip,
        cityById: cityById,
        firstItineraryMoment: firstItineraryMoment,
        firstItineraryDate: firstItineraryDate,
        lastItineraryDate: lastItineraryDate,
        isBeforeTripWindow: isBeforeTripWindow,
        isInTripWindow: isInTripWindow,
        isAfterTripWindow: isAfterTripWindow,
        daysUntilStart: daysUntilStart,
        todayItinerary: todayItinerary,
        tomorrowFirst: tomorrowFirst,
        hotel: hotel,
        flightsToday: flightsToday,
        trainsToday: trainsToday,
        todayTip: todayTip,
        weather: weather,
      );
      _loading = false;
    });
  }

  Future<void> _refreshWeather() async {
    final snapshot = _snapshot;
    if (snapshot == null || _refreshingWeather) return;

    final weatherCity = chooseWeatherCityForDashboard(
      cityById: snapshot.cityById,
      todayItinerary: snapshot.todayItinerary,
      tomorrowFirst: snapshot.tomorrowFirst,
      hotel: snapshot.hotel,
      allCities: snapshot.cityById.values.toList(),
    );
    if (weatherCity == null) return;

    setState(() => _refreshingWeather = true);
    final refreshed = await _weatherService.fetchCurrentWeather(
      city: weatherCity.name,
      lat: weatherCity.lat,
      lng: weatherCity.lng,
      forceRefresh: true,
    );
    if (!mounted) return;

    setState(() {
      _snapshot = snapshot.copyWith(weather: refreshed ?? snapshot.weather);
      _refreshingWeather = false;
    });
  }

  Future<String?> _pickTodayTip(
    AppDatabase db,
    int tripId,
    Set<int> cityIds,
  ) async {
    final tips = await db.tripTipsForTrip(tripId);
    if (tips.isEmpty) return null;

    final cityTip = tips
        .where((t) => t.cityId != null && cityIds.contains(t.cityId))
        .firstOrNull;
    if (cityTip != null) {
      return '${cityTip.title}: ${cityTip.content}';
    }

    final generalTip = tips.where((t) => t.cityId == null).firstOrNull;
    if (generalTip != null) {
      return '${generalTip.title}: ${generalTip.content}';
    }

    final fallback = tips.first;
    return '${fallback.title}: ${fallback.content}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_snapshot == null)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No trip found. Import data to populate the dashboard.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _TripCard(data: _snapshot!),
                  const SizedBox(height: 16),
                  _BriefingCard(
                    notes: _snapshot!.trip.notes,
                    todayTip: _snapshot!.todayTip,
                  ),
                  const SizedBox(height: 16),
                  _WeatherCard(
                    weather: _snapshot!.weather,
                    onRefresh: _refreshWeather,
                    isRefreshing: _refreshingWeather,
                  ),
                  const SizedBox(height: 16),
                  _ItineraryCard(
                    data: _snapshot!,
                    onNavigate: widget.onNavigate,
                  ),
                  const SizedBox(height: 16),
                  _TransportSection(data: _snapshot!),
                  const SizedBox(height: 16),
                  _HotelCard(data: _snapshot!),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

class _DashboardSnapshot {
  final Trip trip;
  final Map<int, City> cityById;
  final DateTime? firstItineraryMoment;
  final DateTime? firstItineraryDate;
  final DateTime? lastItineraryDate;
  final bool isBeforeTripWindow;
  final bool isInTripWindow;
  final bool isAfterTripWindow;
  final int? daysUntilStart;
  final List<ItineraryData> todayItinerary;
  final ItineraryData? tomorrowFirst;
  final Hotel? hotel;
  final List<Flight> flightsToday;
  final List<Train> trainsToday;
  final String? todayTip;
  final WeatherSnapshot? weather;

  const _DashboardSnapshot({
    required this.trip,
    required this.cityById,
    required this.firstItineraryMoment,
    required this.firstItineraryDate,
    required this.lastItineraryDate,
    required this.isBeforeTripWindow,
    required this.isInTripWindow,
    required this.isAfterTripWindow,
    required this.daysUntilStart,
    required this.todayItinerary,
    required this.tomorrowFirst,
    required this.hotel,
    required this.flightsToday,
    required this.trainsToday,
    required this.todayTip,
    required this.weather,
  });

  _DashboardSnapshot copyWith({WeatherSnapshot? weather}) {
    return _DashboardSnapshot(
      trip: trip,
      cityById: cityById,
      firstItineraryMoment: firstItineraryMoment,
      firstItineraryDate: firstItineraryDate,
      lastItineraryDate: lastItineraryDate,
      isBeforeTripWindow: isBeforeTripWindow,
      isInTripWindow: isInTripWindow,
      isAfterTripWindow: isAfterTripWindow,
      daysUntilStart: daysUntilStart,
      todayItinerary: todayItinerary,
      tomorrowFirst: tomorrowFirst,
      hotel: hotel,
      flightsToday: flightsToday,
      trainsToday: trainsToday,
      todayTip: todayTip,
      weather: weather ?? this.weather,
    );
  }
}

class _TripCard extends StatelessWidget {
  final _DashboardSnapshot data;

  const _TripCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String chipLabel;
    if (data.isBeforeTripWindow && data.daysUntilStart != null) {
      chipLabel = 'In ${data.daysUntilStart} days';
    } else if (data.isInTripWindow) {
      chipLabel = 'Ongoing';
    } else if (data.isAfterTripWindow) {
      chipLabel = 'Completed';
    } else {
      chipLabel = 'Planned';
    }

    final rangeStart = data.firstItineraryDate ?? data.trip.startDate;
    final rangeEnd = data.lastItineraryDate ?? data.trip.endDate;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.trip.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    chipLabel,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Itinerary-driven daily briefing',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_formatDate(rangeStart)} -> ${_formatDate(rangeEnd)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BriefingCard extends StatelessWidget {
  final String? notes;
  final String? todayTip;

  const _BriefingCard({required this.notes, required this.todayTip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      icon: Icons.sticky_note_2_outlined,
      title: 'Trip Briefing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (notes == null || notes!.trim().isEmpty)
                ? 'No trip notes available yet.'
                : notes!,
            style: theme.textTheme.bodyMedium,
          ),
          if (todayTip != null && todayTip!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.tips_and_updates_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(todayTip!, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final WeatherSnapshot? weather;
  final VoidCallback onRefresh;
  final bool isRefreshing;

  const _WeatherCard({
    required this.weather,
    required this.onRefresh,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (weather == null) {
      return _SectionCard(
        icon: Icons.wb_sunny_outlined,
        title: 'Weather',
        trailing: IconButton(
          tooltip: 'Refresh weather',
          onPressed: isRefreshing ? null : onRefresh,
          icon: isRefreshing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
        ),
        child: const Text('Live weather unavailable for the current city.'),
      );
    }

    return _SectionCard(
      icon: Icons.wb_sunny_outlined,
      title: 'Weather · ${weather!.city}',
      trailing: IconButton(
        tooltip: 'Refresh weather',
        onPressed: isRefreshing ? null : onRefresh,
        icon: isRefreshing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(weather!.icon, size: 48, color: colorScheme.primary),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather!.temperatureC}°C',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weather!.condition,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeatherStat(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: '${weather!.humidity}%',
              ),
              _WeatherStat(
                icon: Icons.wb_sunny_outlined,
                label: 'UV Index',
                value: '${weather!.uvIndex}',
              ),
              _WeatherStat(
                icon: Icons.wb_twilight,
                label: 'Sunrise',
                value: weather!.sunrise,
              ),
              _WeatherStat(
                icon: Icons.nights_stay_outlined,
                label: 'Sunset',
                value: weather!.sunset,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Updated ${_formatTimeFromDateTime(weather!.fetchedAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  final _DashboardSnapshot data;
  final void Function(int index, {String? city, DateTime? date}) onNavigate;

  const _ItineraryCard({required this.data, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final targetDate = data.isBeforeTripWindow
        ? data.firstItineraryDate
        : DateTime.now();

    if (data.isBeforeTripWindow) {
      return GestureDetector(
        onTap: targetDate == null
            ? null
            : () => onNavigate(1, date: targetDate),
        child: _SectionCard(
          icon: Icons.hourglass_bottom_outlined,
          title: 'Countdown',
          child: _LiveCountdown(
            target: data.firstItineraryMoment,
            fallbackText: data.daysUntilStart == null
                ? 'Trip start date unavailable.'
                : 'Trip starts in ${data.daysUntilStart} day(s).',
          ),
        ),
      );
    }

    if (data.isAfterTripWindow) {
      return _SectionCard(
        icon: Icons.check_circle_outline,
        title: 'Itinerary',
        child: Text(
          'This trip itinerary has ended.',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return GestureDetector(
      onTap: () => onNavigate(1, date: targetDate),
      child: _SectionCard(
        icon: Icons.calendar_today_outlined,
        title: 'Today\'s Itinerary',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.todayItinerary.isEmpty)
              Text(
                'No itinerary items for today.',
                style: theme.textTheme.bodyMedium,
              )
            else
              ...data.todayItinerary.take(6).map((item) {
                final cityName = data.cityById[item.cityId]?.name;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 58,
                        child: Text(
                          _displayTime(item.time),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cityName == null
                              ? item.title
                              : '${item.title} · $cityName',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text(
              data.tomorrowFirst == null
                  ? 'Tomorrow has no scheduled activities yet.'
                  : 'First activity tomorrow: ${_displayTime(data.tomorrowFirst!.time)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveCountdown extends StatefulWidget {
  final DateTime? target;
  final String fallbackText;

  const _LiveCountdown({required this.target, required this.fallbackText});

  @override
  State<_LiveCountdown> createState() => _LiveCountdownState();
}

class _LiveCountdownState extends State<_LiveCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _recomputeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_recomputeRemaining);
    });
  }

  @override
  void didUpdateWidget(covariant _LiveCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _recomputeRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _recomputeRemaining() {
    final target = widget.target;
    if (target == null) {
      _remaining = Duration.zero;
      return;
    }
    final diff = target.difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.target == null) {
      return Text(widget.fallbackText, style: theme.textTheme.bodyLarge);
    }

    if (_remaining == Duration.zero) {
      return Text(
        'Trip is starting now.',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final totalSeconds = _remaining.inSeconds;
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final hh = hours.toString().padLeft(2, '0');
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    final valueStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w900,
      color: colorScheme.onSurface,
      height: 1,
      letterSpacing: 1,
    );

    final colonStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w900,
      color: colorScheme.primary,
      height: 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CountdownBox(
              value: days.toString(),
              label: 'DAYS',
              style: valueStyle,
              minWidth: 120,
            ),
            const SizedBox(width: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CountdownBox(
                  value: hh,
                  label: 'HRS',
                  style: valueStyle,
                  minWidth: 104,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(':', style: colonStyle),
                ),
                _CountdownBox(
                  value: mm,
                  label: 'MIN',
                  style: valueStyle,
                  minWidth: 104,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(':', style: colonStyle),
                ),
                _CountdownBox(
                  value: ss,
                  label: 'SEC',
                  style: valueStyle,
                  minWidth: 104,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedCountdownValue extends StatelessWidget {
  final String value;
  final TextStyle? style;

  const _AnimatedCountdownValue({required this.value, required this.style});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      layoutBuilder: (currentChild, previousChildren) {
        return currentChild ?? const SizedBox.shrink();
      },
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.18),
          end: Offset.zero,
        ).animate(curved);
        final scale = Tween<double>(begin: 0.96, end: 1).animate(curved);

        return SlideTransition(
          position: slide,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
      child: Text(key: ValueKey<String>(value), value, style: style),
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle? style;
  final double minWidth;

  const _CountdownBox({
    required this.value,
    required this.label,
    required this.style,
    this.minWidth = 92,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedCountdownValue(value: value, style: style),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransportSection extends StatelessWidget {
  final _DashboardSnapshot data;

  const _TransportSection({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.flightsToday.isEmpty && data.trainsToday.isEmpty) {
      return const _SectionCard(
        icon: Icons.route_outlined,
        title: 'Transport Today',
        child: Text('No flight or train scheduled for today.'),
      );
    }

    return Column(
      children: [
        if (data.flightsToday.isNotEmpty)
          _FlightCard(flights: data.flightsToday),
        if (data.flightsToday.isNotEmpty && data.trainsToday.isNotEmpty)
          const SizedBox(height: 16),
        if (data.trainsToday.isNotEmpty) _TrainCard(trains: data.trainsToday),
      ],
    );
  }
}

class _FlightCard extends StatelessWidget {
  final List<Flight> flights;

  const _FlightCard({required this.flights});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      icon: Icons.flight_outlined,
      title: 'Flights Today',
      child: Column(
        children: flights.map((flight) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${flight.flightNumber} · ${flight.airline ?? 'Airline'}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${flight.origin} ${_formatTimeFromDateTime(flight.departure)} -> ${flight.destination} ${_formatTimeFromDateTime(flight.arrival)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (flight.status?.trim().isNotEmpty == true)
                        Text(flight.status!, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TrainCard extends StatelessWidget {
  final List<Train> trains;

  const _TrainCard({required this.trains});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      icon: Icons.train_outlined,
      title: 'Trains Today',
      child: Column(
        children: trains.map((train) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        train.trainNumber,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${train.origin} ${_formatTimeFromDateTime(train.departure)} -> ${train.destination} ${_formatTimeFromDateTime(train.arrival)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (train.platform?.trim().isNotEmpty == true)
                        Text(
                          'Platform ${train.platform}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final _DashboardSnapshot data;

  const _HotelCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hotel = data.hotel;

    if (hotel == null) {
      return const _SectionCard(
        icon: Icons.hotel_outlined,
        title: 'Hotel',
        child: Text('No hotel booking available for this period.'),
      );
    }

    return _SectionCard(
      icon: Icons.hotel_outlined,
      title: data.isBeforeTripWindow ? 'Upcoming Hotel' : 'Hotel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotel.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hotel.localName?.trim().isNotEmpty == true)
            Text(
              hotel.localName!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 12),
          if (hotel.addressEn?.trim().isNotEmpty == true)
            _HotelInfo(
              icon: Icons.location_on_outlined,
              text: hotel.addressEn!,
            ),
          if (hotel.addressLocal?.trim().isNotEmpty == true)
            _HotelInfo(icon: Icons.translate, text: hotel.addressLocal!),
          if (hotel.phone?.trim().isNotEmpty == true)
            _HotelInfo(icon: Icons.phone_outlined, text: hotel.phone!),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hotel.checkIn != null)
                _HotelChip(label: 'Check-in: ${_formatDate(hotel.checkIn!)}'),
              if (hotel.checkIn != null && hotel.checkOut != null)
                const SizedBox(width: 8),
              if (hotel.checkOut != null)
                _HotelChip(label: 'Check-out: ${_formatDate(hotel.checkOut!)}'),
            ],
          ),
          if (hotel.confirmation?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 8),
            _HotelInfo(
              icon: Icons.confirmation_number_outlined,
              text: 'Ref: ${hotel.confirmation}',
            ),
          ],
        ],
      ),
    );
  }
}

class _HotelInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HotelInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _HotelChip extends StatelessWidget {
  final String label;

  const _HotelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: colorScheme.onSecondaryContainer),
      ),
      backgroundColor: colorScheme.secondaryContainer,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing case final Widget action) action,
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

City? chooseWeatherCityForDashboard({
  required Map<int, City> cityById,
  required List<ItineraryData> todayItinerary,
  required ItineraryData? tomorrowFirst,
  required Hotel? hotel,
  required List<City> allCities,
}) {
  if (todayItinerary.isNotEmpty) {
    return cityById[todayItinerary.first.cityId];
  }
  if (tomorrowFirst != null) {
    return cityById[tomorrowFirst.cityId];
  }
  if (hotel != null) {
    return cityById[hotel.cityId];
  }
  return allCities.firstOrNull;
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

int _compareItineraryByTimeThenTitle(ItineraryData a, ItineraryData b) {
  final aKey = _timeSortKey(a.time);
  final bKey = _timeSortKey(b.time);
  if (aKey != bKey) return aKey.compareTo(bKey);
  return a.title.toLowerCase().compareTo(b.title.toLowerCase());
}

ItineraryData? _pickFirstTimedItinerary(List<ItineraryData> items) {
  if (items.isEmpty) return null;
  final timed = items
      .where((item) => _timeSortKey(item.time) < 24 * 60 + 1)
      .toList();
  if (timed.isNotEmpty) {
    timed.sort(_compareItineraryByTimeThenTitle);
    return timed.first;
  }
  return items.first;
}

int _timeSortKey(String? raw) {
  final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(raw?.trim() ?? '');
  if (match == null) return 24 * 60 + 1;
  final hh = int.tryParse(match.group(1) ?? '');
  final mm = int.tryParse(match.group(2) ?? '');
  if (hh == null || mm == null) return 24 * 60 + 1;
  return (hh * 60) + mm;
}

String _displayTime(String? raw) {
  final match = RegExp(r'^(\d{1,2}:\d{2})').firstMatch(raw?.trim() ?? '');
  return match?.group(1) ?? '--:--';
}

DateTime _itineraryDateTime(ItineraryData item) {
  final raw = item.time?.trim() ?? '';
  final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(raw);
  final hh = int.tryParse(match?.group(1) ?? '') ?? 0;
  final mm = int.tryParse(match?.group(2) ?? '') ?? 0;
  return DateTime(item.date.year, item.date.month, item.date.day, hh, mm);
}

String _formatTimeFromDateTime(DateTime dt) {
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
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
  return '${months[date.month - 1]} ${date.day}';
}
