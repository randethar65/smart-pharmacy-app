const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Nov 12, 2023"
String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

/// "Nov 12, 10:45 AM"
String formatDateTime(DateTime d) {
  final hour12 = d.hour == 0
      ? 12
      : d.hour > 12
          ? d.hour - 12
          : d.hour;
  final minute = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? 'AM' : 'PM';
  return '${_months[d.month - 1]} ${d.day}, $hour12:$minute $period';
}
