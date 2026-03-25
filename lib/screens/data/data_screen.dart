import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'import_zip_validator.dart';
import 'zip_import_engine.dart';

class _TableImportSummary {
  final String tableName;
  final int insertedRows;
  final int rejectedRows;

  const _TableImportSummary({
    required this.tableName,
    required this.insertedRows,
    required this.rejectedRows,
  });
}

class DataScreen extends StatefulWidget {
  final Future<File?> Function()? pickZipFile;
  final Future<ZipParseResult> Function(File file)? parseZipFile;

  const DataScreen({super.key, this.pickZipFile, this.parseZipFile});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  bool _isImporting = false;
  String? _lastMessage;
  bool _lastSuccess = false;
  List<_TableImportSummary> _lastImportSummary = const [];
  final ZipImportEngine _importEngine = const ZipImportEngine();

  Future<void> _resetAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
          'This will permanently delete everything — trips, cities, itinerary, hotels, flights, trains, tips, packing and contacts.',
        ),
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
            child: const Text('Reset everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final db = DatabaseProvider.of(context);
    await db.delete(db.itinerary).go();
    await db.delete(db.hotels).go();
    await db.delete(db.flights).go();
    await db.delete(db.trains).go();
    await db.delete(db.tripTips).go();
    await db.delete(db.citySummaries).go();
    await db.delete(db.foods).go();
    await db.delete(db.packingItems).go();
    await db.delete(db.contacts).go();
    await db.delete(db.locations).go();
    await db.delete(db.cities).go();
    await db.delete(db.trips).go();

    _setMessage('All data has been reset.', true);
  }

  Future<void> _pickAndImport() async {
    final db = DatabaseProvider.of(context);

    if (widget.pickZipFile != null) {
      final file = await widget.pickZipFile!();
      if (file == null) return;
      await _importZipArchive(db, file);
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = File(result.files.single.path!);
    await _importZipArchive(db, file);
  }

  Future<void> _importZipArchive(AppDatabase db, File file) async {
    final parsed = widget.parseZipFile != null
        ? await widget.parseZipFile!(file)
        : await _importEngine.parseZipFile(file);
    final byTable = parsed.byTable;
    final ignoredFiles = parsed.ignoredFiles;

    if (byTable.isEmpty) {
      _setMessage(requiredZipFilesHelpMessage(), false);
      return;
    }

    // 3) Fail fast if mandatory core tables are missing.
    final missingRequired = missingRequiredZipTables(byTable.keys);
    if (missingRequired.isNotEmpty) {
      _setMessage(missingRequiredZipFilesMessage(missingRequired), false);
      return;
    }

    // 4) Validate cross-table dependencies before touching DB state.
    final planned = byTable.keys.toSet();
    for (final table in planned) {
      final missingDep = await _importEngine.checkDependenciesWithPlanned(
        db: db,
        tableName: table,
        plannedTables: planned,
      );
      if (missingDep != null) {
        _setMessage(
          'Cannot import $table from ZIP — "$missingDep" must be present in DB or ZIP.',
          false,
        );
        return;
      }
    }

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ZipImportPreviewDialog(
        importsByTable: byTable,
        ignoredFiles: ignoredFiles,
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isImporting = true;
      _lastImportSummary = const [];
    });
    final tableSummaries = <_TableImportSummary>[];
    try {
      final execution = await _importEngine.importParsed(
        db: db,
        byTable: byTable,
      );

      for (final summary in execution.tableSummaries) {
        tableSummaries.add(
          _TableImportSummary(
            tableName: summary.tableName,
            insertedRows: summary.insertedRows,
            rejectedRows: summary.rejectedRows,
          ),
        );
      }

      final diagnosticPreview = execution.diagnostics.take(10).join('\n');
      _setMessage(
        'Imported ${execution.totalInserted} rows across ${execution.totalTables} tables. Rejected ${execution.totalRejected} rows.'
        '${diagnosticPreview.isEmpty ? '' : '\n\nFirst rejections:\n$diagnosticPreview'}',
        true,
      );
    } catch (e) {
      _setMessage('ZIP import failed: $e', false);
    } finally {
      setState(() {
        _isImporting = false;
        _lastImportSummary = tableSummaries;
      });
    }
  }

  String _tableLabel(String tableName) {
    switch (tableName) {
      case 'trip_tips':
        return 'Tips & Phrases';
      case 'packing_items':
        return 'Packing List';
      case 'city_summaries':
        return 'City Summaries';
      default:
        return tableName
            .split('_')
            .map(
              (part) => part.isEmpty
                  ? part
                  : '${part[0].toUpperCase()}${part.substring(1)}',
            )
            .join(' ');
    }
  }

  void _setMessage(String msg, bool success) {
    if (!success) {
      debugPrint('[DataScreen][Error] $msg');
    }
    setState(() {
      _lastMessage = msg;
      _lastSuccess = success;
    });
  }

  Future<void> _exportTable(String table) async {
    // TODO: implement export
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Export for $table coming soon!')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const tables = [
      (name: 'trips', icon: Icons.luggage_outlined, label: 'Trips'),
      (name: 'cities', icon: Icons.location_city_outlined, label: 'Cities'),
      (
        name: 'city_summaries',
        icon: Icons.subject_outlined,
        label: 'City Summaries',
      ),
      (name: 'flights', icon: Icons.flight_outlined, label: 'Flights'),
      (name: 'trains', icon: Icons.train_outlined, label: 'Trains'),
      (name: 'hotels', icon: Icons.hotel_outlined, label: 'Hotels'),
      (name: 'locations', icon: Icons.place_outlined, label: 'Locations'),
      (name: 'foods', icon: Icons.restaurant_outlined, label: 'Foods'),
      (
        name: 'itinerary',
        icon: Icons.local_activity_outlined,
        label: 'Itinerary',
      ),
      (
        name: 'trip_tips',
        icon: Icons.tips_and_updates_outlined,
        label: 'Tips & Phrases',
      ),
      (
        name: 'packing_items',
        icon: Icons.backpack_outlined,
        label: 'Packing List',
      ),
      (name: 'contacts', icon: Icons.contacts_outlined, label: 'Contacts'),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Data')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Import button
                FilledButton.icon(
                  onPressed: _isImporting ? null : _pickAndImport,
                  icon: _isImporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload_file_outlined),
                  label: Text(_isImporting ? 'Importing...' : 'Import ZIP'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _resetAllData,
                  icon: Icon(
                    Icons.delete_sweep_outlined,
                    color: colorScheme.error,
                  ),
                  label: Text(
                    'Reset all data',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(color: colorScheme.error),
                  ),
                ),
                const SizedBox(height: 16),

                // Status message
                if (_lastMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _lastSuccess
                          ? colorScheme.primaryContainer
                          : colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _lastSuccess
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: _lastSuccess
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _lastMessage!,
                            style: TextStyle(
                              color: _lastSuccess
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_lastImportSummary.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last import summary',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._lastImportSummary.map((summary) {
                            final hasRejected = summary.rejectedRows > 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(_tableLabel(summary.tableName)),
                                  ),
                                  Text(
                                    '+${summary.insertedRows}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '-${summary.rejectedRows}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: hasRejected
                                          ? colorScheme.error
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Tables list
                Text(
                  'Tables',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: tables.asMap().entries.map((entry) {
                      final i = entry.key;
                      final t = entry.value;
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(t.icon, color: colorScheme.primary),
                            title: Text(t.name),
                            subtitle: Text(t.label),
                            trailing: IconButton(
                              icon: const Icon(Icons.download_outlined),
                              tooltip: 'Export ${t.label}',
                              onPressed: () => _exportTable(t.name),
                            ),
                          ),
                          if (i < tables.length - 1)
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
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PREVIEW DIALOG ───────────────────────────────────────────────────────────

class _ZipImportPreviewDialog extends StatelessWidget {
  final Map<String, ImportPayload> importsByTable;
  final List<String> ignoredFiles;

  const _ZipImportPreviewDialog({
    required this.importsByTable,
    required this.ignoredFiles,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ordered = <String>[
      'trips',
      'cities',
      'city_summaries',
      'flights',
      'trains',
      'hotels',
      'locations',
      'foods',
      'itinerary',
      'trip_tips',
      'packing_items',
      'contacts',
    ].where(importsByTable.containsKey).toList();

    final totalRows = ordered
        .map((t) => importsByTable[t]!.dataRows.length)
        .fold<int>(0, (a, b) => a + b);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.archive_outlined, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Import ZIP Archive'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ordered.length} tables · $totalRows rows detected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ordered.length,
                itemBuilder: (_, i) {
                  final table = ordered[i];
                  final payload = importsByTable[table]!;
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(table),
                    subtitle: Text(payload.sourceName),
                    trailing: Text('${payload.dataRows.length} rows'),
                  );
                },
              ),
            ),
            if (ignoredFiles.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${ignoredFiles.length} template file(s) ignored.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              'Existing data in each imported table will be replaced.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.upload),
          label: const Text('Import all'),
        ),
      ],
    );
  }
}
