import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';
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

        buildActionTile(
          context,
          title: 'تسجيل الخروج',
          icon: Icons.exit_to_app,
          onTap: () {},
          color: Colors.red.shade700,
        ),
      ],
    );
  }
}
