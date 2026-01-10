import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/post_cubit/add_stauff_cubit.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/post_cubit/add_stauff_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compaintsystem/core/style/color.dart'; // تأكد من المسار

class AddUserScreen extends StatefulWidget {
  final int agencyId;
  const AddUserScreen({super.key, required this.agencyId});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "إضافة موظف جديد",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<AddUserCubit, AddUserState>(
        listener: (context, state) {
          if (state is AddUserLoading) {
            showDialog(
              context: context,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AddUserSuccess) {
            Navigator.pop(context); // إغلاق الـ Loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // العودة مع نجاح
          } else if (state is AddUserError) {
            Navigator.pop(context); // إغلاق الـ Loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Palette.primary,
                ),
                const SizedBox(height: 10),
                const Text(
                  "أدخل بيانات الموظف بدقة",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                CustomTextField(
                  controller: nameController,
                  hintText: "الاسم كامل",
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) => v!.isEmpty ? "الاسم مطلوب" : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: emailController,
                  hintText: "البريد الإلكتروني",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) => !v!.contains("@") ? "بريد غير صالح" : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: phoneController,
                  hintText: "رقم الهاتف",
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_android),
                  validator: (v) => v!.isEmpty ? "رقم الهاتف مطلوب" : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: passwordController,
                  hintText: "كلمة المرور",
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (v) => v!.length < 6 ? "كلمة المرور ضعيفة" : null,
                ),

                const SizedBox(height: 40),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
      ), // متوافق مع padding الـ CustomTextField
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          // minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<AddUserCubit>().addUser(
              agencyId: widget.agencyId,
              userData: {
                "name": nameController.text,
                "email": emailController.text,
                "phone": phoneController.text,
                "password": passwordController.text,
              },
            );
          }
        },
        child: const Text(
          "إضافة الموظف الآن",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
