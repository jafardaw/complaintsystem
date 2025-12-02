import 'package:compaintsystem/core/style/styles.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // استخدام Card للتصميم الأنيق
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // حواف مدورة
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: Styles.textStyle14),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
