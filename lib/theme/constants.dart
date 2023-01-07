import 'package:timeago/timeago.dart' as timeago;

const Duration kAnimationDuration = Duration(milliseconds: 300);
const double kBorderRadius = 30;
const double kAppBarExpandedHeight = 180;
const double kPadding = 12;

final List<String> months = [
  'Unknown Month', // DateTime months start from 1. So 0 cannot be accessed
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

String getTimeAgo(DateTime date, {bool includeHour = false}) {
  String timeAgo = timeago.format(date);

  int timestamp = date.millisecondsSinceEpoch;

  if (DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch >
      timestamp) {
    // More than a month ago
    timeAgo = getFormattedDate(date, includeHour: includeHour);
  }

  return timeAgo;
}

String getFormattedDate(DateTime date, {bool includeHour = false}) {
  return "${date.day} ${months[date.month]}${date.year != DateTime.now().year ? ' ' + date.year.toString() : ''}" +
      (includeHour ? (" at ${date.hour}.${date.minute}") : "");
}