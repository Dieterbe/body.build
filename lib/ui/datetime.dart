String formatHumanDateTimeMinutely(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return 'Today ${formatHumanTimeMinutely(dateTime)}';
  } else if (difference.inDays == 1) {
    return 'Yesterday ${formatHumanTimeMinutely(dateTime)}';
  }
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${formatHumanTimeMinutely(dateTime)}';
}

String formatHumanTimeMinutely(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatHumanDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  final h = hours.toString().padLeft(2, '0');
  final m = minutes.toString().padLeft(2, '0');
  final s = seconds.toString().padLeft(2, '0');

  return hours > 0 ? '$h:$m:$s' : '$m:$s';
}

String formatHumanDuration2(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  return '${minutes}m';
}
