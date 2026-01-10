import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/theme/manger/theme_cubit.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/logout_cubit.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/logout_state.dart';
import 'package:compaintsystem/featuer/auth/presentation/view/login_view.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/cubit/edit_profile_state.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/edit_profile_view.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/widget/build_action.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/widget/profile_info_card.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// تم تحويل الدالة إلى StatelessWidget لسهولة إعادة الاستخدام والـ Refactor
class ProfileContentWidget extends StatelessWidget {
  final UserModel user;

  const ProfileContentWidget(
    BuildContext context, {
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. رأس القائمة (الصورة والاسم) مع تصميم محسن
        Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFF0F0F0),
              child: Icon(Icons.person, size: 50, color: Colors.blueGrey),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ),
        // فاصل أنيق
        const Divider(height: 35, thickness: 1, indent: 20, endIndent: 20),

        // 2. تفاصيل البروفايل
        ProfileInfoCard(
          title: 'البريد الإلكتروني',
          value: user.email,
          icon: Icons.email_outlined,
        ),

        if (user.phone != null && user.phone!.isNotEmpty)
          ProfileInfoCard(
            title: 'رقم الهاتف',
            value: user.phone!,
            icon: Icons.phone_android_outlined,
          ),

        ProfileInfoCard(
          title: 'نوع الحساب',
          value: user.type == 'admin' ? 'مدير النظام' : 'مستخدم عادي',
          icon: Icons.shield_outlined,
        ),

        // 3. قسم الإجراءات (الأزرار الصغيرة والجميلة)
        const SizedBox(height: 25),
        const Text(
          'إجراءات الحساب',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),

        buildActionTile(
          context,
          title: 'تعديل البيانات الشخصية',
          icon: Icons.edit_note,
          onTap: () {
            // إضافة التنقل إلى شاشة تعديل البروفايل
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      ProfileUpdateCubit(ProfileRepo(ApiService())),
                  child: EditProfileScreen(
                    currentName: user.name,
                    currentPhone: user.phone ?? '', // تمرير القيم الحالية
                  ),
                ),
              ),
            );
          },
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          icon: Icon(
            context.watch<ThemeCubit>().state == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),

        BlocConsumer<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              // إظهار رسالة نجاح وتوجيه المستخدم لشاشة تسجيل الدخول
              showCustomSnackBar(
                context,
                "تم تسجيل الخروج بنجاح",
                color: Palette.success,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            } else if (state is LogoutFailure) {
              // إظهار خطأ في حال فشل العملية
              showCustomSnackBar(context, state.error, color: Palette.error);
            }
          },
          builder: (context, state) {
            return buildActionTile(
              context,
              title: 'تسجيل الخروج',
              icon: Icons.exit_to_app,
              color: Colors.red.shade700,
              // استدعاء نافذة التحذير عند الضغط
              onTap: () => _showLogoutConfirmationDialog(context),
            );
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(30),
            width: 450, // عرض مناسب جداً للويب
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة تحذيرية بتصميم عصري
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "تأكيد تسجيل الخروج",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "هل أنت متأكد أنك تريد مغادرة النظام؟ ستحتاج إلى إدخال بياناتك مرة أخرى للوصول إلى حسابك.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    // زر الإلغاء
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "إلغاء",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // زر التأكيد
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // إغلاق الحوار
                          context
                              .read<LogoutCubit>()
                              .performLogout(); // تنفيذ الخروج
                        },
                        child: const Text(
                          "خروج",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
