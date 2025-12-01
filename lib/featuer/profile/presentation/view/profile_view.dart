import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/assetimage.dart';
import 'package:compaintsystem/core/widget/background_viwe.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/profile_state.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/widget/build_profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().getProfileData();

    return Drawer(
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            showCustomSnackBar(
              context,
              'فشل جلب بيانات البروفايل: ${state.error}',
              color: Palette.error,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            // استخدام SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),

                  // 1. حالة التحميل
                  if (state is ProfileLoading)
                    const Center(child: CircularProgressIndicator()),

                  // 2. حالة الفشل (يمكن عرض رسالة إعادة المحاولة هنا)
                  if (state is ProfileFailure)
                    Column(
                      children: [
                        const Text(
                          'تعذر تحميل البيانات.',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: 'إعادة المحاولة',
                          onTap: () =>
                              context.read<ProfileCubit>().getProfileData(),
                        ),
                      ],
                    ),

                  // 3. حالة النجاح لعرض البيانات
                  if (state is ProfileSuccess)
                    ProfileContentWidget(context, user: state.userModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // بناء محتوى البروفايل
}
