import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/core/utils/assetimage.dart';
import 'package:compaintsystem/core/utils/const.dart';
import 'package:compaintsystem/core/widget/background_viwe.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/core/widget/error_widget_view.dart';
import 'package:compaintsystem/core/widget/loading_view.dart';
import 'package:compaintsystem/featuer/auth/presentation/view/login_view.dart';
import 'package:compaintsystem/featuer/change_password/presentation/manger/reset_password_cubit.dart';
import 'package:compaintsystem/featuer/change_password/presentation/manger/reset_password_state.dart';
import 'package:compaintsystem/featuer/change_password/repo/chang_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPassowrdView extends StatefulWidget {
  const ResetPassowrdView({super.key});

  @override
  State<ResetPassowrdView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPassowrdView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(ChangPasswordRepo(ApiService())),
      // استخدام الـ Wrapper الجديد
      child: BackgroundWrapper(
        backgroundImagePath: Assets.assetsImagesPhoto20250924164616,
        applyOverlay: true, // تريد التعتيم هنا
        child: ResetPassowrdViewBody(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          passwordConfirmationController: _passwordConfirmationController,
        ),
      ),
    );
  }
}

class ResetPassowrdViewBody extends StatefulWidget {
  final GlobalKey<FormState> _formKey;

  final TextEditingController _passwordController;
  final TextEditingController _passwordConfirmationController;
  final TextEditingController _emailController;

  const ResetPassowrdViewBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController passwordConfirmationController,
  }) : _formKey = formKey,

       _passwordController = passwordController,
       _emailController = emailController,
       _passwordConfirmationController = passwordConfirmationController;

  @override
  State<ResetPassowrdViewBody> createState() => _ResetPassowrdViewBodyState();
}

class _ResetPassowrdViewBodyState extends State<ResetPassowrdViewBody> {
  String _currentCode = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: widget._formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidthRegster),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // إضافة صورة الشعار
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    height: 300,
                    width: 300,
                    Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                    fit: BoxFit.contain,
                  ),
                ),

                const Text(
                  'إعادة تعيين كلمة المرور الخاصة بك   تذكرها', // تعديل رسالة الترحيب
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: widget._emailController,
                  labelText: 'ادخل الايميل الذي ارسل له الكود',
                  hintText: 'ادخل الايميل الذي ارسل له الكود',
                  prefixIcon: const Icon(Icons.email, color: Palette.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ادخل الايميل الذي ارسل له الكود';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                Form(
                  key: widget._formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          inactiveColor: Colors.white54, // لون فاتح
                          activeColor: Palette.primary,
                          selectedColor: Palette.primary.withValues(alpha: 0.5),
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _currentCode = value;
                        },
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return "الرجاء إدخال الرمز كاملاً";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: widget._passwordController,
                  obscureText: true,
                  labelText: 'كلمة المرور',
                  hintText: 'أدخل كلمة المرور الخاصة بك',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Palette.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // حقل تأكيد كلمة المرور الجديد
                CustomTextField(
                  controller: widget._passwordConfirmationController,
                  obscureText: true,
                  labelText: 'تأكيد كلمة المرور',
                  hintText: 'أعد إدخال كلمة المرور',
                  prefixIcon: const Icon(
                    Icons.lock_reset,
                    color: Palette.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور';
                    }
                    if (value != widget._passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين'; // التحقق من التطابق
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                      showCustomSnackBar(
                        context,
                        state.message, // "تم إرسال كود التحقق بنجاح."
                        color: Palette.success,
                      );
                    } else if (state is ResetPasswordFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ResetPasswordLoading) {
                      return LoadingViewWidget();
                    }
                    if (state is ResetPasswordFailure) {
                      return ShowErrorWidgetView.inlineError(
                        errorMessage: state.error,
                        onRetry: () {
                          context.read<ResetPasswordCubit>().resetPassword(
                            email: widget._emailController.text,
                            password: widget._passwordController.text,
                            passwordConfirmation:
                                widget._passwordConfirmationController.text,
                            code: _currentCode,
                          );
                        },
                      );
                    }
                    return CustomButton(
                      onTap: () {
                        if (widget._formKey.currentState!.validate()) {
                          context.read<ResetPasswordCubit>().resetPassword(
                            email: widget._emailController.text,
                            password: widget._passwordController.text,
                            passwordConfirmation:
                                widget._passwordConfirmationController.text,
                            code: _currentCode,
                          );
                        }
                      },
                      text: 'تغيير  كلمة  السر',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
