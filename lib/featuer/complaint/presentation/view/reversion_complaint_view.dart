import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/core/widget/empty_view_list.dart';
import 'package:compaintsystem/featuer/complaint/data/reversion_model.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_reversion_cubit.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_reversion_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintRevisionsScreen extends StatelessWidget {
  final int complaintId;
  const ComplaintRevisionsScreen({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppareWidget(
        title: "سجل التعديلات",
        automaticallyImplyLeading: true,
      ),

      body: BlocBuilder<RevisionsCubit, RevisionsState>(
        builder: (context, state) {
          if (state is RevisionsLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is RevisionsError)
            return Center(child: Text(state.message));
          if (state is RevisionsSuccess) {
            if (state.data.revisions.isEmpty) {
              return EmptyListViews(text: 'لا يوجد تعديلات');
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.data.revisions.length,
              itemBuilder: (context, index) {
                final revision = state.data.revisions[index];
                return _buildTimelineItem(revision, index == 0);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTimelineItem(RevisionModel revision, bool isLatest) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // العمود الأيسر (خط التايم لاين)
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isLatest ? Colors.blue : Colors.grey.shade400,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(width: 20),
          // محتوى المراجعة
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "نسخة رقم #${revision.versionNumber}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      _buildStatusChip(revision.data.status),
                      _buildPriorityChip(revision.data.priority),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    revision.data.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    revision.data.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),

                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "عدلها: ${revision.changedBy.name}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        revision.changedAt.substring(0, 10),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    String text;

    // منطق تحديد اللون والنص بناءً على الأولوية
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        text = "high";
        break;
      case 'medium':
        color = Colors.orange;
        text = "medium";
        break;
      case 'low':
        color = Colors.green;
        text = "low";
        break;
      default:
        color = Colors.blueGrey;
        text = priority;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // خلفية شفافة من نفس اللون
        borderRadius: BorderRadius.circular(
          20,
        ), // زوايا دائرية بالكامل لمظهر عصري
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ), // إطار خفيف
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // نقطة صغيرة بجانب النص تعطي مظهراً احترافياً
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == "in_progress" ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
