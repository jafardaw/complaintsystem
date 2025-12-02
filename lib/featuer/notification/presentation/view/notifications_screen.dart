// lib/features/notifications/presentation/view/notifications_screen.dart

import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/core/widget/background_viwe.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/featuer/notification/data/model/notification_model.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/notifications_list_state_cubit.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/notifications_list_state_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب البيانات عند دخول الشاشة
    context.read<NotificationsListCubit>().getNotifications();

    return Scaffold(
      appBar: AppareWidget(
        title: 'الاشعارات',
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<NotificationsListCubit, NotificationsListState>(
        listener: (context, state) {
          // معالجة أخطاء التحميل الإضافي
          if (state is NotificationsListSuccess && state.currentPage > 1) {
            // قد نستخدم هنا BlocListener في الـ UI
          }
        },
        builder: (context, state) {
          // 1. حالة التحميل الأولي
          if (state is NotificationsListLoading ||
              state is NotificationsListInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة الفشل الأولي
          if (state is NotificationsListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'فشل تحميل الإشعارات. يرجى المحاولة مرة أخرى.',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'إعادة المحاولة',
                    onTap: () => context
                        .read<NotificationsListCubit>()
                        .getNotifications(),
                  ),
                ],
              ),
            );
          }

          // 3. حالة النجاح (Success/LoadingMore)
          if (state is NotificationsListSuccess) {
            final cubit = context.read<NotificationsListCubit>();
            final notifications = state.notifications;
            final isLoadingMore = state is NotificationsListLoadingMore;

            if (notifications.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد إشعارات حالياً.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // التحقق من وصول المستخدم لأسفل القائمة
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    state.hasMore &&
                    !isLoadingMore) {
                  cubit.loadMoreNotifications();
                  return true; // تم التعامل مع الإشعار
                }
                return false;
              },
              child: ListView.builder(
                itemCount: notifications.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == notifications.length) {
                    // عنصر التحميل الإضافي في نهاية القائمة
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final notification = notifications[index];
                  return NotificationCard(notification: notification);
                },
              ),
            );
          }
          return const SizedBox.shrink(); // حالة افتراضية
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // تطبيق تصميم Card المطلوب لديك
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      // تمييز الإشعار غير المقروء
      color: notification.isRead ? Colors.white : Colors.blue.shade50,
      child: ListTile(
        leading: Icon(
          notification.type.contains('status')
              ? Icons.update
              : Icons.notifications_active,
          color: notification.isRead
              ? Colors.grey
              : Theme.of(context).primaryColor,
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          notification.body,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          notification.createdAt ??
              '', // تنسيق الوقت يفضل أن يتم في دالة مساعدة
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () {
          showCustomSnackBar(
            context,
            'فتح الإشعار: ${notification.id}',
            color: Palette.primary,
          );
        },
      ),
    );
  }
}
