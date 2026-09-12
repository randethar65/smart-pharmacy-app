import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/manger/cubit/notification_cubit.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/widgets/list_view_notification.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});
  static const routName = "NotificationView";

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    context.read<NotificationCubit>().fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 48,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: "Plus Jakarta Sans",
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: AppColors.deepTeal, size: 24),
        ),
       
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            if (state is NotificationFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is NotificationInitial || state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationFailure) {
              return Center(
                child: TextButton(
                  onPressed: () =>
                      context.read<NotificationCubit>().fetchNotifications(),
                  child: Text('${state.message} — Tap to retry'),
                ),
              );
            }

            final notifications = (state as NotificationSuccess).notifications;
            return ListViewNotification(list: notifications);
          },
        ),
      ),
    );
  }
}
