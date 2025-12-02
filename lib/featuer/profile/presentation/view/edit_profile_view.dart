import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/style/styles.dart';
import 'package:compaintsystem/core/utils/assetimage.dart';
import 'package:compaintsystem/core/utils/const.dart';
import 'package:compaintsystem/core/widget/background_viwe.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/cubit/edit_profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/cubit/edit_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentPhone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileUpdateCubit>().updateProfile(
        name: _nameController.text,
        phone: _phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        backgroundImagePath: Assets.assetsImagesPhoto20250924164616,
        child: BlocConsumer<ProfileUpdateCubit, ProfileUpdatState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              showCustomSnackBar(
                context,
                '✅ تم تحديث البيانات بنجاح!',
                color: Palette.success,
              );
              Navigator.of(context).pop();
            } else if (state is UpdateProfileFailure) {
              showCustomSnackBar(
                context,
                '❌ فشل التحديث: ${state.error}',
                color: Palette.error,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is UpdateProfileLoading;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxWidthRegster,
                      minHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile Icon
                                Container(
                                  width: 87,
                                  height: 87,
                                  decoration: BoxDecoration(
                                    color: Palette.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 50,
                                    color: Palette.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'تعديل معلومات حسابك',
                                  style: Styles.textStyle18.copyWith(
                                    // color: Palette.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'يمكنك تعديل بياناتك الشخصية أدناه',
                                  style: Styles.textStyle14.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Form Card
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Form Title
                                    Text(
                                      'بيانات المستخدم',
                                      style: Styles.textStyle16.copyWith(
                                        color: Palette.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'قم بتعبئة الحقول المطلوبة',
                                      style: Styles.textStyle14.copyWith(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Name Field
                                    Text(
                                      'الاسم الكامل',
                                      style: Styles.textStyle14.copyWith(
                                        color: Palette.text,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: _nameController,
                                      hintText: 'أدخل اسمك الكامل',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Palette.primary.withOpacity(0.7),
                                      ),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال الاسم';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Phone Field
                                    Text(
                                      'رقم الهاتف',
                                      style: Styles.textStyle14.copyWith(
                                        color: Palette.text,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: _phoneController,
                                      hintText: 'أدخل رقم هاتفك',
                                      prefixIcon: Icon(
                                        Icons.phone_android,
                                        color: Palette.primary.withOpacity(0.7),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال رقم الهاتف';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 32),

                                    // Save Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: CustomButton(
                                        text: isLoading
                                            ? 'جاري الحفظ...'
                                            : 'حفظ التغييرات',
                                        onTap: isLoading
                                            ? null
                                            : _updateProfile,
                                      ),
                                    ),

                                    // Cancel Button
                                    if (!isLoading)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'إلغاء',
                                              style: Styles.textStyle16
                                                  .copyWith(
                                                    color: Palette.error,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
