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
