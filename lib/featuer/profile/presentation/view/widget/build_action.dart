import 'package:compaintsystem/core/style/styles.dart';
import 'package:flutter/material.dart';

Widget buildActionTile(
  BuildContext context, {
  required String title,
  required IconData icon,
  required VoidCallback onTap,
  required Color color,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: Styles.textStyle17)),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    ),
  );
}
