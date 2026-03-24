import 'package:flutter/material.dart';

// --- MOCK DATA ---
final _mockTrip = {
  'name': 'China 2025',
  'destination': 'Shanghai, China',
  'startDate': DateTime(2025, 6, 10),
  'endDate': DateTime(2025, 6, 24),
  'notes':
      'Remember to activate VPN before landing. Exchange some cash at the airport. Meeting point with the group is at the hotel lobby at 18:00 on arrival day.',
};

final _mockWeather = {
  'city': 'Shanghai',
  'temp': 28,
  'humidity': 72,
  'condition': 'Partly Cloudy',
  'uvIndex': 6,
  'sunrise': '05:42',
  'sunset': '19:08',
  'icon': Icons.cloud,
};

final _mockItinerary = [
  {'time': '09:00', 'title': 'Breakfast at the hotel'},
  {'time': '10:30', 'title': 'Visit Yu Garden'},
  {'time': '13:00', 'title': 'Lunch at Din Tai Fung'},
  {'time': '15:00', 'title': 'Walk along the Bund'},
  {'time': '19:00', 'title': 'Group dinner — confirm restaurant'},
];

final _mockFlight = {
  'flightNumber': 'CA837',
  'airline': 'Air China',
  'origin': 'FRA',
  'destination': 'PVG',
  'departure': '13:45',
  'arrival': '06:20+1',
  'seat': '24A',
  'status': 'Confirmed',
};

final _mockHotel = {
  'name': 'The Peninsula Shanghai',
  'localName': '上海半岛酒店',
  'address': '32 The Bund, Huangpu, Shanghai',
  'localAddress': '上海市黄浦区中山东一路32号',
  'phone': '+86 21 2327 2888',
  'checkIn': 'Jun 10',
  'checkOut': 'Jun 14',
  'confirmation': 'PEN-2025-88321',
};

// --- DASHBOARD SCREEN ---
class DashboardScreen extends StatelessWidget {
  final void Function(int index, {String? city, DateTime? date}) onNavigate;
  const DashboardScreen({super.key, required this.onNavigate});

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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TripCard(),
                const SizedBox(height: 16),
                _BriefingCard(),
                const SizedBox(height: 16),
                _WeatherCard(),
                const SizedBox(height: 16),
                _ItineraryCard(onNavigate: onNavigate),
                const SizedBox(height: 16),
                _FlightCard(),
                const SizedBox(height: 16),
                _HotelCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TRIP CARD ---
class _TripCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final daysLeft = (_mockTrip['startDate'] as DateTime)
        .difference(DateTime.now())
        .inDays;

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
                Text(
                  _mockTrip['name'] as String,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                Chip(
                  label: Text(
                    daysLeft > 0 ? 'In $daysLeft days' : 'Ongoing',
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
                Text(
                  _mockTrip['destination'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
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
                  '${_formatDate(_mockTrip['startDate'] as DateTime)} → ${_formatDate(_mockTrip['endDate'] as DateTime)}',
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

// --- BRIEFING CARD ---
class _BriefingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      icon: Icons.sticky_note_2_outlined,
      title: 'Trip Briefing',
      child: Text(
        _mockTrip['notes'] as String,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

// --- WEATHER CARD ---
class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _SectionCard(
      icon: Icons.wb_sunny_outlined,
      title: 'Weather · ${_mockWeather['city']}',
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _mockWeather['icon'] as IconData,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_mockWeather['temp']}°C',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _mockWeather['condition'] as String,
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
                value: '${_mockWeather['humidity']}%',
              ),
              _WeatherStat(
                icon: Icons.wb_sunny_outlined,
                label: 'UV Index',
                value: '${_mockWeather['uvIndex']}',
              ),
              _WeatherStat(
                icon: Icons.wb_twilight,
                label: 'Sunrise',
                value: _mockWeather['sunrise'] as String,
              ),
              _WeatherStat(
                icon: Icons.nights_stay_outlined,
                label: 'Sunset',
                value: _mockWeather['sunset'] as String,
              ),
            ],
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

// --- ITINERARY CARD ---
class _ItineraryCard extends StatelessWidget {
  final void Function(int index, {String? city, DateTime? date}) onNavigate;
  const _ItineraryCard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => onNavigate(1, city: 'Shanghai', date: DateTime.now()),
      child: _SectionCard(
        icon: Icons.calendar_today_outlined,
        title: 'Today\'s Itinerary',
        child: Column(
          children: _mockItinerary.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      item['time'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// --- FLIGHT CARD ---
class _FlightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _SectionCard(
      icon: Icons.flight_outlined,
      title: 'Flight Today',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_mockFlight['flightNumber']} · ${_mockFlight['airline']}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Seat ${_mockFlight['seat']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _FlightEndpoint(
                code: _mockFlight['origin'] as String,
                time: _mockFlight['departure'] as String,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              _FlightEndpoint(
                code: _mockFlight['destination'] as String,
                time: _mockFlight['arrival'] as String,
              ),
            ],
          ),
          Chip(
            label: Text(
              _mockFlight['status'] as String,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _FlightEndpoint extends StatelessWidget {
  final String code;
  final String time;

  const _FlightEndpoint({required this.code, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          code,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(time, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

// --- HOTEL CARD ---
class _HotelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _SectionCard(
      icon: Icons.hotel_outlined,
      title: 'Hotel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _mockHotel['name'] as String,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _mockHotel['localName'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _HotelInfo(
            icon: Icons.location_on_outlined,
            text: _mockHotel['address'] as String,
          ),
          _HotelInfo(
            icon: Icons.translate,
            text: _mockHotel['localAddress'] as String,
          ),
          _HotelInfo(
            icon: Icons.phone_outlined,
            text: _mockHotel['phone'] as String,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HotelChip(label: 'Check-in: ${_mockHotel['checkIn']}'),
              const SizedBox(width: 8),
              _HotelChip(label: 'Check-out: ${_mockHotel['checkOut']}'),
            ],
          ),
          const SizedBox(height: 8),
          _HotelInfo(
            icon: Icons.confirmation_number_outlined,
            text: 'Ref: ${_mockHotel['confirmation']}',
          ),
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

// --- REUSABLE SECTION CARD ---
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
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
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

// --- HELPERS ---
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
