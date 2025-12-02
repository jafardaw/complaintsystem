import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/style/styles.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/core/utils/assetimage.dart';
import 'package:compaintsystem/core/utils/const.dart';
import 'package:compaintsystem/core/widget/background_viwe.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/core/widget/error_widget_view.dart';
import 'package:compaintsystem/core/widget/loading_view.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/register_cubit.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/register_state.dart';
import 'package:compaintsystem/featuer/auth/presentation/view/verify_email_view.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(LoginRepo(ApiService())),
      // استخدام الـ Wrapper الجديد
      child: BackgroundWrapper(
        backgroundImagePath: Assets.assetsImagesPhoto20250924164616,
        applyOverlay: true, // تريد التعتيم هنا
        child: RegisterViewBody(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          fullNameController: _fullNameController,
        ),
      ),
    );
  }
}

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController fullNameController,
  }) : _formKey = formKey,
       _emailController = emailController,
       _passwordController = passwordController,
       _fullNameController = fullNameController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _fullNameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(
          overscroll: false,
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                      height: 240,
                      width: 240,
                      Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Text(
                    'أدخل المعلومات  التالية لانشاء حسابك', // تعديل رسالة الترحيب
                    style: Styles.textStyle20,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _fullNameController,
                    labelText: 'الاسم الكامل ',
                    hintText: 'أدخل الاسم الكامل',
                    prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الكامل';
                      }
                      // يمكنك إضافة المزيد من قواعد التحقق من صحة البريد الإلكتروني هنا
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // حقل الإيميل
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'البريد الإلكتروني',
                    hintText: 'أدخل البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      // يمكنك إضافة المزيد من قواعد التحقق من صحة البريد الإلكتروني هنا
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _passwordController,
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

                  // حقل تأكيد كلمة المرور الجديد
                  const SizedBox(height: 30),

                  BlocConsumer<RegisterCubit, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterSuccess) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerifyEmailView(email: _emailController.text),
                          ),
                        );
                        showCustomSnackBar(
                          context,
                          state.message, // "تم إرسال كود التحقق بنجاح."
                          color: Palette.success,
                        );
                      } else if (state is RegisterFailure) {
                        showCustomSnackBar(
                          context,
                          state.error,
                          color: Palette.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is RegisterLoading) {
                        return LoadingViewWidget();
                      }
                      if (state is RegisterFailure) {
                        return ShowErrorWidgetView.inlineError(
                          errorMessage: state.error,
                          onRetry: () {
                            context.read<RegisterCubit>().register(
                              fullName: _fullNameController.text,
                              email: _emailController.text,

                              password: _passwordController.text,
                            );
                          },
                        );
                      }
                      return CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<RegisterCubit>().register(
                              fullName: _fullNameController.text,
                              email: _emailController.text,

                              password: _passwordController.text,
                            );
                          }
                        },
                        text: 'إنشاء حساب',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
