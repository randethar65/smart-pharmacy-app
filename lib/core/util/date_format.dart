const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Nov 12, 2023"
String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

/// "Nov 12" — no year, for a label that already sits under a dated section.
String formatDateShort(DateTime d) => '${_months[d.month - 1]} ${d.day}';

/// "Nov 12, 10:45 AM"
String formatDateTime(DateTime d) => '${formatDate(d)}, ${formatTime(d)}';

/// "10:45 AM"
String formatTime(DateTime d) {
  final hour12 = d.hour == 0
      ? 12
      : d.hour > 12
          ? d.hour - 12
          : d.hour;
  final minute = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

/// "Just now" / "10m ago" / "2h ago" — for a timestamp from today only;
/// use [formatTime]/[formatDateTime] once it's yesterday or older.
String timeAgo(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  return '${diff.inHours}h ago';
}
