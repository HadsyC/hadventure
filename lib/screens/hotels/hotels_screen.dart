import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/queries.dart';

class HotelsScreen extends StatefulWidget {
  final int? highlightedHotelId;

  const HotelsScreen({super.key, this.highlightedHotelId});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  bool _loading = true;
  List<Hotel> _hotels = [];
  Map<int, City> _cityById = {};

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  if (_hotels.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No hotels for current trip.'),
                      ),
                    )
                  else
                    ..._hotels.map((h) {
                      final city = _cityById[h.cityId];
                      return Card(
                        color: widget.highlightedHotelId == h.id
                            ? colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          leading: const Icon(Icons.hotel_outlined),
                          title: Text(h.name),
                          subtitle: Text(
                            '${city?.name ?? 'Unknown city'}\n${_fmtDate(h.checkIn)} - ${_fmtDate(h.checkOut)}',
                          ),
                          isThreeLine: true,
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

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '--';
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
