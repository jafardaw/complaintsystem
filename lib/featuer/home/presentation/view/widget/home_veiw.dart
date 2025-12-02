// lib/features/home/presentation/view/home_view.dart

import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/api_service.dart';

import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/goverment_agencies_view.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/notifications_list_state_cubit.dart';
import 'package:compaintsystem/featuer/notification/presentation/view/notifications_screen.dart';

import 'package:compaintsystem/featuer/notification/repo/notifacation_repo.dart';

import 'package:compaintsystem/featuer/profile/presentation/manger/profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // قائمة الصفحات بدون BlocProvider — فقط Widgets مباشرة
    _pages = [
      GovermentAgenciesView(),
      const Center(
        child: Text(
          'محتوى الشكاوى والتقارير',
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
      ),
      const NotificationsScreen(),
      const Center(
        child: Text(
          'محتوى الإعدادات',
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Cubit الخاص بالملف الشخصي
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepo(ApiService())),
        ),

        // Cubit الخاص بجلب قائمة الإشعارات
        BlocProvider<NotificationsListCubit>(
          create: (_) => NotificationsListCubit(NotificationRepo(ApiService())),
        ),
      ],

      child: Scaffold(
        body: _pages[_selectedIndex],

        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60.0,
          color: Palette.primary,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),

          items: <Widget>[
            Icon(
              Icons.home,
              size: 30,
              color: _selectedIndex == 0 ? Palette.primary : Colors.white,
            ),
            Icon(
              Icons.receipt_long,
              size: 30,
              color: _selectedIndex == 1 ? Palette.primary : Colors.white,
            ),
            Icon(
              Icons.notifications,
              size: 30,
              color: _selectedIndex == 2 ? Palette.primary : Colors.white,
            ),
            Icon(
              Icons.settings,
              size: 30,
              color: _selectedIndex == 3 ? Palette.primary : Colors.white,
            ),
          ],

          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },

          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
