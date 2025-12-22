import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/featuer/complaint/data/complaint_model.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/widget/build_status_complaint.dart';
import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  const ComplaintCard({super.key, required this.complaint});

  // تحديد اللون بناءً على حالة الشكوى (Status)
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.green.shade600;
      case 'in_progress':
        return Colors.blue.shade600;
      case 'closed':
        return Colors.grey.shade600;
      case 'high':
        return Palette.error; // لون الخطأ (أحمر)
      default:
        return Colors.amber.shade700;
    }
  }

  // تحديد أيقونة بناءً على الأولوية (Priority)
  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.keyboard_double_arrow_up_rounded;
      case 'medium':
        return Icons.arrow_upward_rounded;
      case 'low':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.list_alt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(complaint.status);
    final priorityColor = _getStatusColor(
      complaint.priority,
    ); // نستخدم نفس دالة اللون للأولوية لتبسيط

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 8, // ظل واضح
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم عرض تفاصيل الشكوى: ${complaint.referenceCode}'),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. العنوان والرمز المرجعي (Reference Code)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Palette.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    complaint.referenceCode,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 0.5),

              // 2. الهيئة المدينة
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.black54),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      complaint.agency.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    complaint.locationText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 3. الحالة والأولوية والمرفقات (Chips & Icons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // حالة الشكوى (Chip)
                  buildStatusChip(
                    label: complaint.status,
                    color: statusColor,
                    icon: Icons.info_outline,
                  ),

                  // الأولوية (Chip)
                  buildStatusChip(
                    label: complaint.priority,
                    color: priorityColor,
                    icon: _getPriorityIcon(complaint.priority),
                  ),

                  // عدد المرفقات
                  // if (complaint.attachments.isNotEmpty)
                  // Row(
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) =>
                  //                 PdfComplaint(complaint: complaint),
                  //           ),
                  //         );
                  //       },
                  //       icon: Icon(
                  //         Icons.attachment,
                  //         size: 16,
                  //         color: Colors.grey.shade600,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       '${complaint.attachments.length}',
                  //       style: TextStyle(color: Colors.grey.shade600),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(height: 10),

              // 4. تاريخ الإنشاء
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'تاريخ الإنشاء: ${complaint.createdAt}', // عرض التاريخ فقط
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
