import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

class TrainsScreen extends StatefulWidget {
  final int? highlightedTrainId;

  const TrainsScreen({super.key, this.highlightedTrainId});

  @override
  State<TrainsScreen> createState() => _TrainsScreenState();
}

class _TrainsScreenState extends State<TrainsScreen> {
  bool _loading = true;
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
        _trains = [];
        _loading = false;
      });
      return;
    }

    final trains = await (db.select(
      db.trains,
    )..where((t) => t.tripId.equals(trip.id))).get();
    trains.sort((a, b) => a.departure.compareTo(b.departure));

    if (!mounted) return;
    setState(() {
      _trains = trains;
      _loading = false;
    });
  }

  void _openBottomSheet({Train? train}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TrainForm(train: train, onSaved: _load),
    );
  }

  void _openViewSheet(Train train) {
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
                      train.trainNumber,
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
                      _openBottomSheet(train: train);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('${train.origin} -> ${train.destination}'),
              const SizedBox(height: 6),
              Text('Departure: ${_fmt(train.departure)}'),
              Text('Arrival: ${_fmt(train.arrival)}'),
              if (train.platform?.isNotEmpty == true)
                Text('Platform: ${train.platform}'),
              if (train.duration?.isNotEmpty == true)
                Text('Duration: ${train.duration}'),
              if (train.ticketPricePerPerson != null)
                Text('Ticket p.p.: ${train.ticketPricePerPerson}'),
              if (train.bookingFeePerPerson != null)
                Text('Booking fee p.p.: ${train.bookingFeePerPerson}'),
              if (train.totalPricePerPerson != null)
                Text('Total p.p.: ${train.totalPricePerPerson}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTrain(Train train) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete train?'),
        content: Text('This will permanently delete "${train.trainNumber}".'),
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
      await (db.delete(db.trains)..where((t) => t.id.equals(train.id))).go();
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
          const SliverAppBar.large(title: Text('Trains')),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                tooltip: 'View',
                                onPressed: () => _openViewSheet(t),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                tooltip: 'Edit',
                                onPressed: () => _openBottomSheet(train: t),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: colorScheme.error,
                                ),
                                tooltip: 'Delete',
                                onPressed: () => _deleteTrain(t),
                              ),
                            ],
                          ),
                          onTap: () => _openViewSheet(t),
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
        label: const Text('Add train'),
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

class _TrainForm extends StatefulWidget {
  final Train? train;
  final VoidCallback onSaved;

  const _TrainForm({this.train, required this.onSaved});

  @override
  State<_TrainForm> createState() => _TrainFormState();
}

class _TrainFormState extends State<_TrainForm> {
  late TextEditingController _trainNumber;
  late TextEditingController _origin;
  late TextEditingController _destination;
  late TextEditingController _platform;
  late TextEditingController _duration;
  late TextEditingController _ticketPrice;
  late TextEditingController _bookingFee;
  late TextEditingController _totalPrice;
  DateTime? _departure;
  DateTime? _arrival;

  @override
  void initState() {
    super.initState();
    final t = widget.train;
    _trainNumber = TextEditingController(text: t?.trainNumber ?? '');
    _origin = TextEditingController(text: t?.origin ?? '');
    _destination = TextEditingController(text: t?.destination ?? '');
    _platform = TextEditingController(text: t?.platform ?? '');
    _duration = TextEditingController(text: t?.duration ?? '');
    _ticketPrice = TextEditingController(
      text: t?.ticketPricePerPerson?.toString() ?? '',
    );
    _bookingFee = TextEditingController(
      text: t?.bookingFeePerPerson?.toString() ?? '',
    );
    _totalPrice = TextEditingController(
      text: t?.totalPricePerPerson?.toString() ?? '',
    );
    _departure = t?.departure;
    _arrival = t?.arrival;
  }

  @override
  void dispose() {
    _trainNumber.dispose();
    _origin.dispose();
    _destination.dispose();
    _platform.dispose();
    _duration.dispose();
    _ticketPrice.dispose();
    _bookingFee.dispose();
    _totalPrice.dispose();
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
    if (_trainNumber.text.trim().isEmpty ||
        _origin.text.trim().isEmpty ||
        _destination.text.trim().isEmpty ||
        _departure == null ||
        _arrival == null) {
      return;
    }

    final db = DatabaseProvider.of(context);
    final trip = await db.currentTrip;
    if (trip == null) return;

    final companion = TrainsCompanion(
      tripId: Value(trip.id),
      trainNumber: Value(_trainNumber.text.trim()),
      origin: Value(_origin.text.trim()),
      destination: Value(_destination.text.trim()),
      departure: Value(_departure!),
      arrival: Value(_arrival!),
      platform: Value(_platform.text.trim().isEmpty ? null : _platform.text.trim()),
      duration: Value(_duration.text.trim().isEmpty ? null : _duration.text.trim()),
      ticketPricePerPerson: Value(double.tryParse(_ticketPrice.text.trim())),
      bookingFeePerPerson: Value(double.tryParse(_bookingFee.text.trim())),
      totalPricePerPerson: Value(double.tryParse(_totalPrice.text.trim())),
    );

    if (widget.train == null) {
      await db.into(db.trains).insert(companion);
    } else {
      await (db.update(
        db.trains,
      )..where((t) => t.id.equals(widget.train!.id))).write(companion);
    }

    if (!mounted) return;
    Navigator.pop(context);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.train != null;
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
              isEdit ? 'Edit train' : 'New train',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _trainNumber,
              decoration: const InputDecoration(
                labelText: 'Train number *',
                border: OutlineInputBorder(),
              ),
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
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDateTime(isDeparture: true),
                    icon: const Icon(Icons.departure_board_outlined),
                    label: Text(
                      _departure == null
                          ? 'Departure *'
                          : _fmt(_departure!),
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
                    icon: const Icon(Icons.schedule_outlined),
                    label: Text(_arrival == null ? 'Arrival *' : _fmt(_arrival!)),
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
                    controller: _platform,
                    decoration: const InputDecoration(
                      labelText: 'Platform',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _duration,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
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
                    controller: _ticketPrice,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ticket p.p.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _bookingFee,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Booking fee p.p.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _totalPrice,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total p.p.',
                border: OutlineInputBorder(),
              ),
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
