import 'package:compaintsystem/featuer/users/presentation/view/manager/update_cubit/update_user_cubit.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/update_cubit/update_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/user_admin_model.dart';

class EditUserScreen extends StatefulWidget {
  final UserAdminModel user;
  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late String selectedType;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    selectedType = widget.user.type;
    isActive = widget.user.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل بيانات المستخدم")),
      body: BlocListener<UpdateUserCubit, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserLoading) {
            showDialog(
              context: context,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is UpdateUserSuccess) {
            Navigator.pop(context); // إغلاق الـ Loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // الرجوع للصفحة السابقة مع إشارة نجاح
          } else if (state is UpdateUserError) {
            Navigator.pop(context); // إغلاق الـ Loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "الاسم كامل"),
                  validator: (v) => v!.isEmpty ? "الحقل مطلوب" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "رقم الهاتف"),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text("Admin")),
                    DropdownMenuItem(value: 'staff', child: Text("Staff")),
                    DropdownMenuItem(value: 'citizen', child: Text("Citizen")),
                  ],
                  onChanged: (v) => setState(() => selectedType = v!),
                  decoration: const InputDecoration(labelText: "نوع المستخدم"),
                ),
                SwitchListTile(
                  title: const Text("حالة الحساب (نشط)"),
                  value: isActive,
                  onChanged: (v) => setState(() => isActive = v),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<UpdateUserCubit>()
                          .updateUser(widget.user.id, {
                            "name": nameController.text,
                            "email": emailController.text,
                            "phone": phoneController.text,
                            "type": selectedType,
                            "is_active": isActive,
                          });
                    }
                  },
                  child: const Text("حفظ التعديلات"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
