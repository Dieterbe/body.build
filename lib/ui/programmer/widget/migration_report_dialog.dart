import 'package:bodybuild/model/migration_report.dart';
import 'package:flutter/material.dart';

class MigrationReportDialog extends StatelessWidget {
  const MigrationReportDialog({super.key, required this.report});

  final MigrationReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = report.hasError;
    final statusColor = hasError ? theme.colorScheme.error : theme.colorScheme.primary;
    final statusText = hasError ? 'Migration Failed' : 'Migration Completed';
    final logsText = report.logs.join('\n');
    final logsScrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(title: const Text('Migration Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        hasError ? Icons.error_outline : Icons.check_circle_outline,
                        color: statusColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusText,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Version ${report.from} → ${report.to}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (hasError && report.error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${report.error!}\n\nPlease report this issue to us',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                  // if it was a success, put a similar widget here with a take-home message:
                  if (!hasError && !report.boring) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Some exercises/tweak definitions have changed. If this affects any of your data, it has been automatically adjusted. You can continue using the app as usual.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Logs Section
          Text(
            'Migration Logs',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              child: Scrollbar(
                controller: logsScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: logsScrollController,
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    logsText.isEmpty ? 'No logs available' : logsText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: logsText.isEmpty
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Close Button
          Center(
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
