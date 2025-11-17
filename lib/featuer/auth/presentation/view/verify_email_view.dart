import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // حزمة إدخال رمز التحقق

class VerifyEmailView extends StatelessWidget {
  final String email;
  final int chektap;

  const VerifyEmailView({
    super.key,
    required this.email,
    required this.chektap,
  });

  @override
  Widget build(BuildContext context) {
    const String backgroundImagePath = Assets.assetsImagesPhoto20250924164616;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VerifyEmailCubit(LoginRepo(ApiService())),
        ),
        BlocProvider(
          create: (context) => ResendCodeCubit(LoginRepo(ApiService())),
        ),
      ],
      child: BackgroundWrapper(
        backgroundImagePath: backgroundImagePath,
        applyOverlay: true,
        child: VerifyEmailViewBody(email: email, chektap: chektap),
      ),
    );
  }
}

class VerifyEmailViewBody extends StatefulWidget {
  final String email;
  final int chektap;

  const VerifyEmailViewBody({
    super.key,
    required this.email,
    required this.chektap,
  });

  @override
  State<VerifyEmailViewBody> createState() => _VerifyEmailViewBodyState();
}

class _VerifyEmailViewBodyState extends State<VerifyEmailViewBody> {
  final _formKey = GlobalKey<FormState>();
  String _currentCode = '';
  // String _reverseString(String input) {
  //   return input.split('').reversed.join('');
  // }

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidthRegster),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                    height: 270,
                    // إضافة لون أبيض شفاف لجعله يظهر على الخلفية الداكنة
                  ),
                ),

                const Text(
                  'أدخل رمز التحقق',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // تغيير لون النص إلى الأبيض
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Text(
                  'تم إرسال رمز مكون من 4 أرقام إلى بريدك الإلكتروني:\n${widget.email}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70, // تغيير لون النص إلى الأبيض الشفاف
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                Form(
                  key: _formKey,
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
                const SizedBox(height: 60),

                BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                  listener: (context, state) {
                    if (state is VerifyEmailSuccess) {
                      if (widget.chektap == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ResetPassowrdView(codeController: _currentCode),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  ProfileCubit(ProfileRepo(ApiService())),
                              child: ProfileEditView(),
                            ),
                          ),
                        );
                        showCustomSnackBar(
                          context,
                          'تم تفعيل الحساب وتسجيل الدخول بنجاح',
                          color: Palette.success,
                        );
                      }
                    } else if (state is VerifyEmailFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is VerifyEmailLoading) {
                      return LoadingViewWidget();
                    }
                    if (state is VerifyEmailFailure) {
                      return ShowErrorWidgetView.inlineError(
                        errorMessage: state.error,
                        onRetry: () {
                          context.read<VerifyEmailCubit>().verifyEmail(
                            email: widget.email,
                            verificationCode: _currentCode,
                            chektap: widget.chektap,
                          );
                        },
                      );
                    }

                    return CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // final String correctedCode = _reverseString(
                          //   _currentCode,
                          // );

                          context.read<VerifyEmailCubit>().verifyEmail(
                            email: widget.email,
                            verificationCode: _currentCode,
                            chektap: widget.chektap,
                          );
                        }
                      },
                      text: 'تأكيد الحساب',
                    );
                  },
                ),

                const SizedBox(height: 40),

                // 2. BlocConsumer جديد لزر إعادة إرسال الكود
                BlocConsumer<ResendCodeCubit, ResendCodeState>(
                  listener: (context, state) {
                    if (state is ResendCodeSuccess) {
                      showCustomSnackBar(
                        context,
                        state.message,
                        color: Palette.success,
                      );
                    } else if (state is ResendCodeFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is ResendCodeLoading;

                    return Center(
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<ResendCodeCubit>().resendCode(
                                  email: widget.email,
                                );
                              },
                        child: isLoading
                            ? LoadingViewWidget()
                            : Text(
                                'لم يصلني الرمز إعادة الإرسال؟ 🤔',
                                style: Styles.textStyle16.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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
