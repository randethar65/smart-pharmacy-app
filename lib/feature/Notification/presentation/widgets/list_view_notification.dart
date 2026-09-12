import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/util/date_format.dart';
import 'package:smart_pharmacy/feature/Notification/data/models/notification_response.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/manger/cubit/notification_cubit.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/widgets/notification_item.dart';

/// Groups [list] into Today / Yesterday / one section per older date, and
/// renders each group as a header followed by its [NotificationItem]s.
class ListViewNotification extends StatelessWidget {
  const ListViewNotification({super.key, required this.list});

  final List<NotificationResponse> list;

  static const _headerStyle = TextStyle(
    color: AppColors.ink,
    fontFamily: "Inter",
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'No notifications yet',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <NotificationResponse>[];
    final yesterdayItems = <NotificationResponse>[];
    // Insertion-ordered so older dates render in the same order they appear
    // in `list` (already newest-first from the backend).
    final olderGroups = <String, List<NotificationResponse>>{};

    for (final n in list) {
      final day = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      if (day == today) {
        todayItems.add(n);
      } else if (day == yesterday) {
        yesterdayItems.add(n);
      } else {
        olderGroups.putIfAbsent(formatDate(n.createdAt), () => []).add(n);
      }
    }

    return ListView(
      // ListView clips to its own viewport by default, and the cards below
      // are exactly that wide — without this, their side shadows get cut
      // off flush at the left/right edge instead of fading out naturally.
      clipBehavior: Clip.none,
      // ListView also auto-derives its padding from MediaQuery when none is
      // given — zeroing it out so only the spacing we write below applies.
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () => context.read<NotificationCubit>().markAllRead(),
              // A default TextButton reserves a ~48px tap target even
              // though the text itself is short — this was most of the
              // "extra height" at the top of the list.
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Mark all as read',
                style: TextStyle(
                  color: AppColors.deepTeal,
                  fontFamily: "Inter",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (todayItems.isNotEmpty) ...[
          const Text('Today', style: _headerStyle),
          const SizedBox(height: 16),
          for (final n in todayItems) ...[
            NotificationItem(
              notification: n,
              timeLabel: timeAgo(n.createdAt),
              onTap: () => _markRead(context, n),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
        if (yesterdayItems.isNotEmpty) ...[
          const Text('Yesterday', style: _headerStyle),
          const SizedBox(height: 16),
          for (final n in yesterdayItems) ...[
            NotificationItem(
              notification: n,
              timeLabel: 'Yesterday, ${formatTime(n.createdAt)}',
              onTap: () => _markRead(context, n),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
        for (final entry in olderGroups.entries) ...[
          Text(entry.key, style: _headerStyle),
          const SizedBox(height: 16),
          for (final n in entry.value) ...[
            NotificationItem(
              notification: n,
              timeLabel: '${formatDateShort(n.createdAt)}, ${formatTime(n.createdAt)}',
              onTap: () => _markRead(context, n),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _markRead(BuildContext context, NotificationResponse n) {
    if (n.isRead) return;
    context.read<NotificationCubit>().markAsRead(n.id);
  }
}
