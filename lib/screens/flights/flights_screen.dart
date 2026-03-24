import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/queries.dart';

class FlightsScreen extends StatefulWidget {
  final int? highlightedFlightId;
  final int? highlightedTrainId;

  const FlightsScreen({
    super.key,
    this.highlightedFlightId,
    this.highlightedTrainId,
  });

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  bool _loading = true;
  List<Flight> _flights = [];
  List<Train> _trains = [];

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
        _flights = [];
        _trains = [];
        _loading = false;
      });
      return;
    }

    final flights = await (db.select(
      db.flights,
    )..where((f) => f.tripId.equals(trip.id))).get();
    final trains = await (db.select(
      db.trains,
    )..where((t) => t.tripId.equals(trip.id))).get();

    flights.sort((a, b) => a.departure.compareTo(b.departure));
    trains.sort((a, b) => a.departure.compareTo(b.departure));

    if (!mounted) return;
    setState(() {
      _flights = flights;
      _trains = trains;
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
          const SliverAppBar.large(title: Text('Flights & Trains')),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Flights',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_flights.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No flights for current trip.'),
                      ),
                    )
                  else
                    ..._flights.map(
                      (f) => Card(
                        color: widget.highlightedFlightId == f.id
                            ? colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          leading: const Icon(Icons.flight_outlined),
                          title: Text(
                            '${f.flightNumber} · ${f.airline ?? 'Airline'}',
                          ),
                          subtitle: Text(
                            '${f.origin} -> ${f.destination}\n${_fmt(f.departure)} - ${_fmt(f.arrival)}',
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Trains',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_trains.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('No trains for current trip.'),
                      ),
                    )
                  else
                    ..._trains.map(
                      (t) => Card(
                        color: widget.highlightedTrainId == t.id
                            ? colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          leading: const Icon(Icons.train_outlined),
                          title: Text(t.trainNumber),
                          subtitle: Text(
                            '${t.origin} -> ${t.destination}\n${_fmt(t.departure)} - ${_fmt(t.arrival)}',
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    ),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
