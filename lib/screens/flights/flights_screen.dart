import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:hadventure/core/database/queries.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

class FlightsScreen extends StatefulWidget {
  final int? highlightedFlightId;

  const FlightsScreen({super.key, this.highlightedFlightId});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  bool _loading = true;
  List<Flight> _flights = [];

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
        _loading = false;
      });
      return;
    }

    final flights = await (db.select(
      db.flights,
    )..where((f) => f.tripId.equals(trip.id))).get();

    flights.sort((a, b) => a.departure.compareTo(b.departure));

    if (!mounted) return;
    setState(() {
      _flights = flights;
      _loading = false;
    });
  }

  void _openBottomSheet({Flight? flight}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FlightForm(flight: flight, onSaved: _load),
    );
  }

  void _openViewSheet(Flight flight) {
    final theme = Theme.of(context);
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${flight.flightNumber} ${flight.airline == null ? '' : '· ${flight.airline}'}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                      _openBottomSheet(flight: flight);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('${flight.origin} -> ${flight.destination}'),
              const SizedBox(height: 6),
              Text('Departure: ${_fmt(flight.departure)}'),
              Text('Arrival: ${_fmt(flight.arrival)}'),
              if (flight.originTerminal?.isNotEmpty == true)
                Text('Origin terminal: ${flight.originTerminal}'),
              if (flight.destinationTerminal?.isNotEmpty == true)
                Text('Destination terminal: ${flight.destinationTerminal}'),
              if (flight.duration?.isNotEmpty == true)
                Text('Duration: ${flight.duration}'),
              if (flight.trackerUrl?.isNotEmpty == true)
                Text('Tracker: ${flight.trackerUrl}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteFlight(Flight flight) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete flight?'),
        content: Text('This will permanently delete "${flight.flightNumber}".'),
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
      await (db.delete(db.flights)..where((f) => f.id.equals(flight.id))).go();
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Flights')),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                tooltip: 'View',
                                onPressed: () => _openViewSheet(f),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                tooltip: 'Edit',
                                onPressed: () => _openBottomSheet(flight: f),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: colorScheme.error,
                                ),
                                tooltip: 'Delete',
                                onPressed: () => _deleteFlight(f),
                              ),
                            ],
                          ),
                          onTap: () => _openViewSheet(f),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openBottomSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add flight'),
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

class _FlightForm extends StatefulWidget {
  final Flight? flight;
  final VoidCallback onSaved;

  const _FlightForm({this.flight, required this.onSaved});

  @override
  State<_FlightForm> createState() => _FlightFormState();
}

class _FlightFormState extends State<_FlightForm> {
  late TextEditingController _flightNumber;
  late TextEditingController _airline;
  late TextEditingController _origin;
  late TextEditingController _destination;
  late TextEditingController _originTerminal;
  late TextEditingController _destinationTerminal;
  late TextEditingController _duration;
  late TextEditingController _trackerUrl;
  DateTime? _departure;
  DateTime? _arrival;

  @override
  void initState() {
    super.initState();
    final f = widget.flight;
    _flightNumber = TextEditingController(text: f?.flightNumber ?? '');
    _airline = TextEditingController(text: f?.airline ?? '');
    _origin = TextEditingController(text: f?.origin ?? '');
    _destination = TextEditingController(text: f?.destination ?? '');
    _originTerminal = TextEditingController(text: f?.originTerminal ?? '');
    _destinationTerminal = TextEditingController(
      text: f?.destinationTerminal ?? '',
    );
    _duration = TextEditingController(text: f?.duration ?? '');
    _trackerUrl = TextEditingController(text: f?.trackerUrl ?? '');
    _departure = f?.departure;
    _arrival = f?.arrival;
  }

  @override
  void dispose() {
    _flightNumber.dispose();
    _airline.dispose();
    _origin.dispose();
    _destination.dispose();
    _originTerminal.dispose();
    _destinationTerminal.dispose();
    _duration.dispose();
    _trackerUrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isDeparture}) async {
    final current = (isDeparture ? _departure : _arrival) ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (pickedTime == null) return;

    final value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      if (isDeparture) {
        _departure = value;
      } else {
        _arrival = value;
      }
    });
  }

  Future<void> _save() async {
    if (_flightNumber.text.trim().isEmpty ||
        _origin.text.trim().isEmpty ||
        _destination.text.trim().isEmpty ||
        _departure == null ||
        _arrival == null) {
      return;
    }

    final db = DatabaseProvider.of(context);
    final trip = await db.currentTrip;
    if (trip == null) return;

    final companion = FlightsCompanion(
      tripId: Value(trip.id),
      flightNumber: Value(_flightNumber.text.trim()),
      airline: Value(
        _airline.text.trim().isEmpty ? null : _airline.text.trim(),
      ),
      origin: Value(_origin.text.trim()),
      destination: Value(_destination.text.trim()),
      originTerminal: Value(
        _originTerminal.text.trim().isEmpty
            ? null
            : _originTerminal.text.trim(),
      ),
      destinationTerminal: Value(
        _destinationTerminal.text.trim().isEmpty
            ? null
            : _destinationTerminal.text.trim(),
      ),
      departure: Value(_departure!),
      arrival: Value(_arrival!),
      duration: Value(
        _duration.text.trim().isEmpty ? null : _duration.text.trim(),
      ),
      trackerUrl: Value(
        _trackerUrl.text.trim().isEmpty ? null : _trackerUrl.text.trim(),
      ),
    );

    if (widget.flight == null) {
      await db.into(db.flights).insert(companion);
    } else {
      await (db.update(
        db.flights,
      )..where((f) => f.id.equals(widget.flight!.id))).write(companion);
    }

    if (!mounted) return;
    Navigator.pop(context);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.flight != null;
    final theme = Theme.of(context);

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
            Text(
              isEdit ? 'Edit flight' : 'New flight',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _flightNumber,
                    decoration: const InputDecoration(
                      labelText: 'Flight number *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _airline,
                    decoration: const InputDecoration(
                      labelText: 'Airline',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _origin,
                    decoration: const InputDecoration(
                      labelText: 'Origin *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _destination,
                    decoration: const InputDecoration(
                      labelText: 'Destination *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _originTerminal,
                    decoration: const InputDecoration(
                      labelText: 'Origin terminal',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _destinationTerminal,
                    decoration: const InputDecoration(
                      labelText: 'Destination terminal',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDateTime(isDeparture: true),
                    icon: const Icon(Icons.flight_takeoff_outlined),
                    label: Text(
                      _departure == null ? 'Departure *' : _fmt(_departure!),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDateTime(isDeparture: false),
                    icon: const Icon(Icons.flight_land_outlined),
                    label: Text(
                      _arrival == null ? 'Arrival *' : _fmt(_arrival!),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _duration,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _trackerUrl,
                    decoration: const InputDecoration(
                      labelText: 'Tracker URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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

  String _fmt(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
