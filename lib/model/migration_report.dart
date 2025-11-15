class MigrationReport {
  final int from;
  final int to;
  final List<String> logs;
  final String? error;
  final bool boring; // not interesting enough to inform user about

  const MigrationReport({
    required this.from,
    required this.to,
    required this.logs,
    this.error,
    required this.boring,
  });

  bool get hasError => error != null;
}
