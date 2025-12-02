// ودجت زر الترقيم
import 'package:compaintsystem/core/style/color.dart';
import 'package:flutter/material.dart';

Widget buildPaginationButton(
  BuildContext context, {
  required String label,
  required IconData icon,
  required bool isEnabled,
  required VoidCallback onPressed,
  required bool isNext,
}) {
  return TextButton(
    onPressed: isEnabled ? onPressed : null,
    style: TextButton.styleFrom(
      foregroundColor: isEnabled ? Palette.primary : Colors.grey.shade400,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(
      children: [
        if (!isNext) Icon(icon, size: 16),
        if (!isNext) const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (isNext) const SizedBox(width: 4),
        if (isNext) Icon(icon, size: 16),
      ],
    ),
  );
}
