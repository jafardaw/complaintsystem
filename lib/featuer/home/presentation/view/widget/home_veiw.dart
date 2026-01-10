// lib/features/home/presentation/view/home_view.dart

import 'package:compaintsystem/code_compalint.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/Report/presentation/view/statistics_view.dart';
import 'package:compaintsystem/featuer/auth/presentation/manger/logout_cubit.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/goverment_agencies_view.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/notifications_list_state_cubit.dart';
import 'package:compaintsystem/featuer/notification/presentation/view/notifications_screen.dart';
import 'package:compaintsystem/featuer/notification/repo/notifacation_repo.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';
import 'package:compaintsystem/featuer/users/presentation/view/user_view.dart';
import 'package:compaintsystem/test.dart';
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

  // القائمة يجب أن تحتوي على 5 صفحات لتطابق عدد أيقونات التتبع
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const GovermentAgenciesView(),
      const NotificationsScreen(),
      const StatsPage(),
      AdminUsersScreen(),
      AdminReportScreen(),
      TrackComplaintScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit(ProfileRepo(ApiService()))),
        BlocProvider(
          create: (_) => NotificationsListCubit(NotificationRepo(ApiService())),
        ),
        BlocProvider(create: (_) => LogoutCubit(LoginRepo(ApiService()))),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth >= 900;

          return Scaffold(
            // استخدام IndexedStack يحافظ على حالة الصفحات عند التنقل
            body: isWeb
                ? _buildWebLayout()
                : IndexedStack(index: _selectedIndex, children: _pages),
            bottomNavigationBar: isWeb ? null : _buildBottomNavigation(),
          );
        },
      ),
    );
  }

  // ================= MOBILE =================
  Widget _buildBottomNavigation() {
    return CurvedNavigationBar(
      index: _selectedIndex,
      height: 60,
      color: Palette.primary,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.transparent, // جعلها شفافة لتبدو أفضل مع الخلفية
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        _buildNavIcon(Icons.home, 0),
        _buildNavIcon(Icons.notifications, 1),
        _buildNavIcon(Icons.query_stats, 2),
        _buildNavIcon(Icons.person, 3),

        // تغيير الأيقونة لتناسب الملف الشخصي/الدخول
      ],
      onTap: (index) {
        setState(() => _selectedIndex = index);
      },
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Icon(
      icon,
      size: 30,
      color: _selectedIndex == index ? Palette.primary : Colors.white,
    );
  }

  // ================= WEB =================
  Widget _buildWebLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          labelType: NavigationRailLabelType.all,
          backgroundColor: Palette.primary,
          selectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(
            color: Colors.white.withValues(alpha: 0.6),
          ),
          selectedLabelTextStyle: const TextStyle(color: Colors.white),
          unselectedLabelTextStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('الرئيسية'),
            ),

            NavigationRailDestination(
              icon: Icon(Icons.notifications),
              label: Text('الإشعارات'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.query_stats), // أيقونة الإحصائيات
              label: Text('الإحصائيات'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person), // أيقونة الإحصائيات
              label: Text('المستخدمين'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.query_stats_sharp), // أيقونة الإحصائيات
              label: Text('التقارير'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.code), // أيقونة الإحصائيات
              label: Text('التحقق من شكوى'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _pages[_selectedIndex]),
      ],
    );
  }
}
