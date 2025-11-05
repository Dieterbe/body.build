import 'package:bodybuild/data/developer_mode_provider.dart';
import 'package:bodybuild/data/measurements/measurement_providers.dart';
import 'package:bodybuild/data/settings/app_settings_provider.dart';
import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:bodybuild/service/wger_import_service.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/util/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import progress state
class ImportState {
  final List<String> statusMessages;
  final bool isComplete;
  final bool isError;
  final String completionMessage;

  ImportState({
    this.statusMessages = const [],
    this.isComplete = false,
    this.isError = false,
    this.completionMessage = '',
  });

  ImportState copyWith({
    List<String>? statusMessages,
    bool? isComplete,
    bool? isError,
    String? completionMessage,
  }) {
    return ImportState(
      statusMessages: statusMessages ?? this.statusMessages,
      isComplete: isComplete ?? this.isComplete,
      isError: isError ?? this.isError,
      completionMessage: completionMessage ?? this.completionMessage,
    );
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'settings';

  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _apiKeyController;
  bool _isEditing = false;
  bool _obscureText = true;
  bool _showHelp = false;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devMode = ref.watch(developerModeProvider);
    if (!isMobileApp() && !devMode) {
      return const MobileAppOnly(title: 'Settings');
    }

    final serviceAsync = ref.watch(appSettingsPersistenceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const AppNavigationDrawer(),
      body: serviceAsync.when(
        data: (service) {
          final settings = service.loadSettings();

          // Update controller if not editing
          if (!_isEditing && _apiKeyController.text != settings.wgerApiKey) {
            _apiKeyController.text = settings.wgerApiKey;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // API Configuration Section
              Text(
                'API Configuration',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure external API integrations',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),

              // wger API Key Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.key, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'wger API Key (optional)',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'For importing weight measurements',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.help_outline, size: 20),
                            onPressed: () {
                              setState(() {
                                _showHelp = !_showHelp;
                              });
                            },
                            tooltip: 'How to get an API key',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // API Key Input Field
                      TextField(
                        controller: _apiKeyController,
                        obscureText: _obscureText,
                        onChanged: (_) {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'API Key',
                          hintText: 'Enter your wger API key',
                          border: const OutlineInputBorder(),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                tooltip: _obscureText ? 'Show API key' : 'Hide API key',
                              ),
                              if (settings.wgerApiKey.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _clearApiKey(),
                                  tooltip: 'Clear API key',
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Save Button
                      if (_isEditing)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _saveApiKey(),
                            icon: const Icon(Icons.save),
                            label: const Text('Save API Key'),
                          ),
                        ),

                      // Status Indicator
                      if (!_isEditing && settings.wgerApiKey.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'API key configured',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Help Section (collapsible)
                      if (_showHelp) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How to get an API key:',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '1. Go to wger.de\n'
                                '2. Open your profile settings\n'
                                '3. Generate an API key\n'
                                '4. Copy and paste it here',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (settings.wgerApiKey.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.cloud_download,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Import Weight Data',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Import weight measurements from your wger account',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _importWeightMeasurements(settings.wgerApiKey),
                            icon: const Icon(Icons.download),
                            label: const Text('Import Weight Measurements'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading settings: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _importWeightMeasurements(String apiKey) async {
    if (!mounted) return;

    // Single state notifier for all import state
    final state = ValueNotifier<ImportState>(ImportState());
    final scrollController = ScrollController();

    // Auto-scroll to bottom when new messages are added
    state.addListener(() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: ValueListenableBuilder<ImportState>(
          valueListenable: state,
          builder: (context, importState, child) {
            return Row(
              children: [
                if (!importState.isComplete)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                else
                  Icon(
                    importState.isError ? Icons.error : Icons.check_circle,
                    color: importState.isError ? Colors.red : Colors.green,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    importState.isComplete
                        ? (importState.isError ? 'Import Failed' : 'Import Complete')
                        : 'Importing...',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            );
          },
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ValueListenableBuilder<ImportState>(
            valueListenable: state,
            builder: (context, importState, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (importState.statusMessages.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: importState.statusMessages.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  importState.statusMessages[index],
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (importState.isComplete && importState.completionMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        importState.completionMessage,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        actions: [
          ValueListenableBuilder<ImportState>(
            valueListenable: state,
            builder: (context, importState, child) {
              if (!importState.isComplete) return const SizedBox.shrink();
              return FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              );
            },
          ),
        ],
      ),
    );

    void addStatus(String message) {
      state.value = state.value.copyWith(statusMessages: [...state.value.statusMessages, message]);
    }

    try {
      final importService = WgerImportService();
      final result = await importService.importWeightMeasurements(
        apiKey,
        onProgress: (progress) {
          addStatus(progress.status);
        },
      );

      if (!mounted) return;

      if (!result.success) {
        state.value = state.value.copyWith(
          isError: true,
          isComplete: true,
          completionMessage: result.errorMessage ?? 'Unknown error',
        );
        return;
      }

      if (result.totalCount == 0) {
        state.value = state.value.copyWith(
          isComplete: true,
          completionMessage: 'No weight measurements found in your wger account.',
        );
        return;
      }

      // Parse and save weight entries
      addStatus('Parsing ${result.totalCount} weight entries...');
      final entries = importService.parseWeightEntries(result.weightEntries!);

      // Determine unit based on wger user profile setting
      final unit = result.weightUnit == 'lb' ? Unit.lbs : Unit.kg;
      addStatus('Saving measurements (unit: ${unit.displayName})...');

      // Process in batches - database now runs in background isolate so won't block UI
      const batchSize = 50;
      final service = ref.read(measurementPersistenceServiceProvider);

      for (var i = 0; i < entries.length; i += batchSize) {
        final end = (i + batchSize < entries.length) ? i + batchSize : entries.length;
        final batch = entries.sublist(i, end);

        // Prepare batch data
        final batchData = batch
            .map(
              (entry) => (
                timestamp: entry.date,
                measurementType: MeasurementType.weight,
                value: entry.weight,
                unit: unit,
                comment: 'Imported from wger',
              ),
            )
            .toList();

        await service.addMeasurementsBatch(batchData);
        addStatus('Processed ${i + batch.length}/${entries.length} measurements...');
      }

      addStatus('Import complete');
      state.value = state.value.copyWith(
        isComplete: true,
        completionMessage: 'Successfully processed ${entries.length} weight measurements.',
      );
    } catch (e) {
      if (!mounted) return;
      state.value = state.value.copyWith(
        isError: true,
        isComplete: true,
        completionMessage: 'Error importing measurements: $e',
      );
    } finally {
      scrollController.dispose();
      state.dispose();
    }
  }

  Future<void> _saveApiKey() async {
    try {
      final apiKey = _apiKeyController.text.trim();
      final service = await ref.read(appSettingsPersistenceProvider.future);
      await service.setWgerApiKey(apiKey);
      if (mounted) {
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save API key: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clearApiKey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear API Key'),
        content: const Text('Are you sure you want to clear the API key?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = await ref.read(appSettingsPersistenceProvider.future);
        await service.clearWgerApiKey();
        _apiKeyController.clear();
        if (mounted) {
          setState(() {
            _isEditing = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear API key: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
