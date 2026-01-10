import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_coplaint_cubit.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_coplaint_state.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/widget/build_pagenation_button.dart';
import 'package:flutter/material.dart';

Widget buildPaginationControls(
  BuildContext context,
  ComplaintsSuccess state,
  ComplaintsCubit cubit,
  int agencyid,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Colors.grey.shade200)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // زر السابق
        buildPaginationButton(
          context,
          label: 'السابق',
          icon: Icons.arrow_back_ios_new,
          isEnabled: state.currentPage > 1,
          onPressed: () => cubit.previousPage(agencyid),

          isNext: false,
        ),

        // معلومات الصفحة
        Text(
          'صفحة ${state.currentPage} من ${state.lastPage}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Palette.primary,
          ),
        ),

        // زر التالي
        buildPaginationButton(
          context,
          label: 'التالي',
          icon: Icons.arrow_forward_ios,
          isEnabled: state.currentPage < state.lastPage,
          onPressed: () => cubit.nextPage(agencyid), // ✅ تمرير كـ Callback
          isNext: true,
        ),
      ],
    ),
  );
}
