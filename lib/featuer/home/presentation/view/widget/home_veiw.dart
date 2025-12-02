import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/featuer/profile/presentation/manger/profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/profile_view.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// يجب استيراد حزمة شريط التنقل المنحني
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // مؤشر الصفحة الحالية (يبدأ من 0)
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // 1. الرئيسية
      const Center(
        child: Text(
          'محتوى الصفحة الرئيسية',
          style: TextStyle(fontSize: 20, color: Colors.indigo),
        ),
      ),

      const Center(
        child: Text(
          'محتوى الشكاوى والتقارير',
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
      ),

      const Center(
        child: Text(
          'محتوى الشكاوى والتقارير',
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
      ),

      // 4. الإعدادات
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
    // تم الحفاظ على BlocProvider الخارجي كما كان في الكود الأصلي
    return BlocProvider(
      // يمكن استخدام ProfileCubit هنا لجميع الصفحات التي تحتاجه، أو كما تم في initState
      create: (context) => ProfileCubit(ProfileRepo(ApiService())),
      child: Scaffold(
        // شريط التطبيق (AppBar)
        appBar: AppareWidget(
          title: 'نظام ادارة الشكاوي',
          automaticallyImplyLeading: true,
          actions: [
            // Builder(
            //   // نحتاج Builder للوصول إلى Scaffold.of(context)
            //   builder: (context) => IconButton(
            //     icon: const Icon(Icons.menu),
            //     onPressed: () =>
            //         Scaffold.of(context).openDrawer(), // لفتح القائمة الجانبية
            //   ),
            // ),
          ],
        ),

        // القائمة الجانبية (Drawer)
        drawer: const ProfileDrawer(),

        // محتوى الصفحة، يتغير بناءً على المؤشر المحدد
        body: _pages[_selectedIndex],

        // شريط التنقل السفلي المنحني (CurvedNavigationBar)
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex, // المؤشر الحالي
          height: 60.0,
          // تصميم جذاب: لون داكن للشريط ولون فاتح للخلفية
          color: Palette.primary, // لون الشريط الأساسي (داكن)
          buttonBackgroundColor: Colors.white,
          backgroundColor:
              Colors.white, // يجب أن يكون نفس لون خلفية الـ Scaffold
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),

          // العناصر داخل شريط التنقل (الأيقونات)
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
              Icons.person,
              size: 30,
              color: _selectedIndex == 2 ? Palette.primary : Colors.white,
            ),
            Icon(
              Icons.settings,
              size: 30,
              color: _selectedIndex == 3 ? Palette.primary : Colors.white,
            ),
          ],

          // دالة الاستدعاء عند النقر على أيقونة
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },

          // لجعل الشريط يظهر فوق الـ body بشكل منحنٍ
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}

// نموذج بسيط لـ ProfileDrawer (للحفاظ على الكود الأصلي)
