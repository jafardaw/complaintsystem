import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/featuer/goverment_agencies/data/governmentagency_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AgencyGridCardM3 extends StatefulWidget {
  final GovernmentAgency agency;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplaint;
  final VoidCallback? onperson;

  const AgencyGridCardM3({
    super.key,
    required this.agency,
    this.onEdit,
    this.onDelete,
    this.onComplaint,
    this.onperson,
  });

  @override
  State<AgencyGridCardM3> createState() => _AgencyGridCardM3State();
}

class _AgencyGridCardM3State extends State<AgencyGridCardM3> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // تأمين اللون الأساسي
    final primaryColor = Palette.primary ?? Colors.blue;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.all(8),
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        child: Card(
          elevation: _isHovered ? 12 : 2, // رفع الظل عند التحويم
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: primaryColor.withOpacity(_isHovered ? 0.4 : 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            // حل مشكلة Unbounded Height: جعل العمود يأخذ أقل مساحة ممكنة
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(primaryColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfoSection(theme, primaryColor),
                    const SizedBox(
                      height: 20,
                    ), // مسافة ثابتة بدلاً من Spacer أو Expanded
                    _buildBottomActions(primaryColor, widget.agency),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, Color primaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.agency.name, // الموديل يجب أن يضمن عدم كونها null
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.agency.category,
          style: TextStyle(
            color: primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              widget.agency.city,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions(Color primaryColor, GovernmentAgency agency) {
    return
    // الزر الكبير (شكوى)
    Column(
      children: [
        if (agency.category != 0) ...[
          _buildActionBtn(
            onPressed: widget.onComplaint,
            color: Colors.orange.shade800,
            icon: Icons.report_gmailerrorred_rounded,
            label:
                "شكوى (${widget.agency.complaintscount})", // تأكد من السبيلينج هنا
          ),
        ],
        const SizedBox(height: 4),

        Row(
          children: [
            Flexible(
              child: _buildSmallIconBtn(
                Icons.edit_outlined,
                Colors.blue.shade700,
                widget.onEdit,
              ),
            ),
            const SizedBox(width: 4),

            Flexible(
              child: _buildSmallIconBtn(
                Icons.delete_outline,
                Colors.red.shade700,
                widget.onDelete,
              ),
            ),
            const SizedBox(width: 4),

            Flexible(
              child: _buildSmallIconBtn(
                Icons.person_add_alt,
                const Color.fromARGB(255, 47, 69, 211),
                widget.onperson,
              ),
            ),
          ],
        ),
      ],
    );
    // زر التعديل
  }

  Widget _buildSmallIconBtn(IconData icon, Color color, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(6), // تقليل الـ padding من 8 إلى 6
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ), // تقليل حجم الأيقونة من 20 إلى 18
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required VoidCallback? onPressed,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: color,
                highlightColor: Colors.white,
                child: Icon(icon, size: 16),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
