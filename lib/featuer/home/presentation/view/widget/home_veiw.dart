import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/profile_view.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepo(ApiService())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الصفحة الرئيسية'),
          actions: [
            Builder(
              // نحتاج Builder للوصول إلى Scaffold.of(context)
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () =>
                    Scaffold.of(context).openDrawer(), // لفتح القائمة الجانبية
              ),
            ),
          ],
        ),
        drawer: const ProfileDrawer(),
        body: const Center(child: Text('محتوى التطبيق')),
      ),
    );
  }
}
