import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/featuer/complaint/data/complaint_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModernComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onTap;

  const ModernComplaintCard({super.key, required this.complaint, this.onTap});

  // --- الدوال المساعدة للألوان والأيقونات ---
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade600;
      case 'in_progress':
        return Colors.orange.shade600;
      case 'closed':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.orange.shade700;
      case 'low':
        return Colors.green.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Icons.fiber_new_rounded;
      case 'in_progress':
        return Icons.pending_actions_rounded;
      case 'closed':
        return Icons.task_alt_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy/MM/dd • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(complaint.status);
    final priorityColor = _getPriorityColor(complaint.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // زينة خلفية (Background Decoration)
                Positioned(
                  left: -20,
                  top: -20,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: statusColor.withOpacity(0.05),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. الرأس (الحالة والأولوية والكود)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildBadge(
                                label: complaint.status.toUpperCase(),
                                color: statusColor,
                                icon: _getStatusIcon(complaint.status),
                              ),
                              const SizedBox(width: 8),
                              _buildBadge(
                                label: complaint.priority.toUpperCase(),
                                color: priorityColor,
                                icon: Icons.priority_high_rounded,
                              ),
                            ],
                          ),
                          Text(
                            complaint.referenceCode,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 2. العنوان
                      Text(
                        complaint.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 3. الجهة المسؤولة والموقع
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_rounded,
                            size: 16,
                            color: Colors.blueGrey.shade300,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            complaint.agency.name,
                            style: TextStyle(
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            complaint.locationText
                                .split(',')
                                .last
                                .trim(), // عرض المدينة فقط للاختصار
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 16,
                            color: Colors.blueGrey.shade300,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            complaint.description,
                            style: TextStyle(
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),

                          const SizedBox(width: 4),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, thickness: 0.5),
                      ),

                      // 4. قسم المستخدم (User Info Section) - التعديل الجديد
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue.shade50,
                            child: Text(
                              complaint.user.name[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  complaint.user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_iphone_rounded,
                                      size: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      complaint.user.phone,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      complaint.user.email,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // أيقونة المرفقات إن وجدت
                          if (complaint.attachments.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.attach_file_rounded,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "${complaint.attachments.length}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 5. التوقيت (Footer)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatDate(complaint.createdAt),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // شريط ملون جانبي يعبر عن الحالة
                Positioned(
                  right: 0,
                  top: 40,
                  bottom: 40,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت مساعدة لبناء الـ Badges
  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
