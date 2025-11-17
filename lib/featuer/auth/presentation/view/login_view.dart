import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/google_login_cubit.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/login_cubit.dart';
import 'package:compaintsystem/featuer/auth/repo/google_login_repo.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // ⬅️ استخدام MultiBlocProvider لتوفير كل الكيوبت
      providers: [
        BlocProvider(create: (context) => LoginCubit(LoginRepo(ApiService()))),
        BlocProvider(
          create: (context) => GoogleLoginCubit(GoogleLoginService()),
        ),
      ],
      child: BackgroundWrapper(
        // ⬅️ استخدام ويدجت الخلفية
        backgroundImagePath: Assets.assetsImagesPhoto20250924164616,
        applyOverlay: true,
        child: LoginViewBody(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
        ),
      ),
    );
  }
}

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey,
       _emailController = emailController,
       _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidthRegster),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset(
                    Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                    height: 195,
                    fit: BoxFit.contain,
                    // color: Colors.white, // يمكن إزالة التعليق إذا كان الشعار يحتاج للتبييض
                  ),
                ),

                // 2. رسالة الترحيب (بألوان فاتحة)
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // 3. حقل الإيميل
                CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  hintText: 'أدخل الايميل',
                  prefixIcon: const Icon(Icons.email, color: Palette.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء عدم ترك حقل الايميل فارغ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 4. حقل كلمة المرور
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
                      return 'الرجاء عدم ترك حقل كلمة المرور فارغ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChekEmailView()),
                    );
                  },

                  child: Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.07,
                    ),
                    child: Text('نسيت كلمة المرور؟', style: Styles.textStyle16),
                  ),
                ),
                const SizedBox(height: 30),

                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) async {
                    if (state is LoginSuccess) {
                      if (!context.mounted) return;

                      // Widget destinationPage;
                      if (state.responseModel.hasProfile == true) {
                        // حالة: isProfile = 1 (تم التحقق)، ننتقل للصفحة الرئيسية/الدورات
                        // هذا هو المنطق الأصح بعد نجاح تسجيل الدخول
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursesListView(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditView(),
                          ),
                        ); // استبدلها باسم صفحة التسجيل لديك
                      }

                      // الخطوة 3: التوجيه إلى الوجهة المحددة

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CoursesListView(),
                      //   ),
                      // );

                      showCustomSnackBar(
                        context,
                        'تم تسجيل الدخول بنجاح',
                        color: Palette.success,
                      );
                    } else if (state is LoginFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is LoginLoading;
                    return CustomButton(
                      onTap: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                  usernameOrPhone: _emailController.text,
                                  password: _passwordController.text,
                                );
                              }
                            },
                      text: isLoading ? 'جاري الدخول...' : 'تسجيل الدخول',
                    );
                  },
                ),

                const SizedBox(height: 30),

                // 6. زر Google Login الجميل
                BlocConsumer<GoogleLoginCubit, GoogleLoginState>(
                  listener: (context, state) {
                    if (state is GoogleLoginSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoursesListView(),
                        ),
                      );
                      showCustomSnackBar(
                        context,
                        'تم تسجيل الدخول بنجاح عبر Google',
                        color: Palette.success,
                      );
                    } else if (state is GoogleLoginFailure) {
                      showCustomSnackBar(
                        context,
                        'فشل تسجيل الدخول عبر Google: ${state.error}',
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    final bool isGoogleLoading = state is GoogleLoginLoading;
                    return Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: isGoogleLoading
                            ? null
                            : () {
                                context
                                    .read<GoogleLoginCubit>()
                                    .loginWithGoogle();
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isGoogleLoading) ...[
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ] else ...[
                              // أيقونة Google
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.g_mobiledata,
                                  color: Color(0xFF4285F4),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              isGoogleLoading
                                  ? 'جاري تسجيل الدخول...'
                                  : 'تسجيل الدخول عبر Google',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Divider(color: Colors.white30, height: 40),

                const SizedBox(height: 20),

                // 8. زر التسجيل (Register Link)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                    );
                  },
                  child: Center(
                    child: const Text(
                      'ليس لديك حساب؟ إنشاء حساب جديد',
                      style: TextStyle(
                        color: Palette.backgroundColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
