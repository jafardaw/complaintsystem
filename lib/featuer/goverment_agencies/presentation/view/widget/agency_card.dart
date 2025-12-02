import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/featuer/goverment_agencies/data/governmentagency_model.dart';
import 'package:flutter/material.dart';

class AgencyGridCardM3 extends StatefulWidget {
  final GovernmentAgency agency;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplaint;

  const AgencyGridCardM3({
    super.key,
    required this.agency,
    this.onEdit,
    this.onDelete,
    this.onComplaint,
  });

  @override
  State<AgencyGridCardM3> createState() => _AgencyGridCardM3State();
}

class _AgencyGridCardM3State extends State<AgencyGridCardM3>
    with SingleTickerProviderStateMixin {
  double scale = 1.0;
  bool _isHovering = false;

  // ⚠️ لا تستخدم late - بدلاً من ذلك، أعلنهم كـ nullable
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // ⚠️ تهيئة المتحولات هنا في initState
    _initializeAnimations();
  }

  // دالة منفصلة لتهيئة الـ Animations
  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    // ⚠️ تفحص قبل التخلص
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => scale = 0.96),
        onTapUp: (_) => setState(() => scale = 1.0),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          scale: scale,
          child: Stack(
            children: [
              // الكارد الأساسي
              Card(
                elevation: _isHovering ? 12 : 6,
                shadowColor: Palette.primary.withValues(
                  alpha: _isHovering ? 0.3 : 0.2,
                ),
                color: Palette.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Palette.primary.withValues(
                        alpha: _isHovering ? 0.25 : 0.15,
                      ),
                      width: _isHovering ? 1.5 : 1.1,
                    ),
                    gradient: _isHovering
                        ? LinearGradient(
                            colors: [
                              Palette.backgroundColor,
                              Palette.backgroundColor.withValues(alpha: 0.95),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ---------- الشارة الرمزية ----------
                      _buildAgencyBadge(),

                      const SizedBox(height: 20),

                      // ------------ الاسم ------------
                      Text(
                        widget.agency.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Palette.primary,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ------------ الفئة ------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Palette.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.agency.category,
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: Palette.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ------------ المدينة ------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey.shade600,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.agency.city,
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ------------ أزرار التحكم ------------
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),

              // ⚠️ تحقق من أن الـ Animations مهيأة قبل استخدامها
              if (_pulseAnimation != null && _pulseController != null)
                _buildPulsingComplaintButton(),
            ],
          ),
        ),
      ),
    );
  }

  // الشارة الرمزية للهيئة
  Widget _buildAgencyBadge() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Palette.primary.withValues(alpha: 0.9),
            Palette.primary.withValues(alpha: 0.7),
            Palette.primary.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 3,
        ),
      ),
      child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 32),
    );
  }

  // أزرار التحكم
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // زر التعديل
        _buildIconButton(
          icon: Icons.edit_note_rounded,
          color: Colors.blue,
          onPressed: widget.onEdit,
          tooltip: 'تعديل',
        ),

        const SizedBox(width: 16),

        // زر الحذف
        _buildIconButton(
          icon: Icons.delete_forever_rounded,
          color: Colors.red,
          onPressed: widget.onDelete,
          tooltip: 'حذف',
        ),
      ],
    );
  }

  // زر الشكوى النابض باستمرار
  Widget _buildPulsingComplaintButton() {
    return Positioned(
      top: 3,
      right: 3,
      child: GestureDetector(
        onTap: widget.onComplaint,
        child: AnimatedBuilder(
          animation: _pulseAnimation!,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation!.value,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.6),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Stack(
                  children: [
                    // تأثير التوهج النابض
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.red.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),

                    // الأيقونة
                    Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // زر أيقونة مخصص
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: 20),
          padding: EdgeInsets.zero,
          splashRadius: 20,
        ),
      ),
    );
  }
}
