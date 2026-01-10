import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_coplaint_cubit.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_coplaint_state.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_reversion_cubit.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/reversion_complaint_view.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/widget/build_pagenation_controls.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/widget/card_complainr.dart';
import 'package:compaintsystem/featuer/complaint/repo/coplaint_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsView extends StatelessWidget {
  const ComplaintsView({super.key, required this.agencyid});
  final int agencyid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplaintsCubit(ComplaintsRepo(ApiService()))
        ..fetchComplaints(
          agencyid: agencyid,
        ), // جلب البيانات عند بدء تشغيل الشاشة
      child: ComplaintsViewBody(agencyid: agencyid),
    );
  }
}

class ComplaintsViewBody extends StatelessWidget {
  const ComplaintsViewBody({super.key, required this.agencyid});
  final int agencyid;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ComplaintsCubit>();

    return Scaffold(
      appBar: AppareWidget(
        title: 'قائمة الشكاوى',
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
        builder: (context, state) {
          if (state is ComplaintsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Palette.primary),
            );
          } else if (state is ComplaintsError) {
            // رسالة الخطأ
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'خطأ في جلب الشكاوى: ${state.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Palette.error, fontSize: 16),
                ),
              ),
            );
          } else if (state is ComplaintsSuccess) {
            if (state.complaints.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد شكاوى لعرضها حاليًا.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.complaints.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => RevisionsCubit(
                                  ComplaintsRepo(ApiService()),
                                )..fetchRevisions(state.complaints[index].id),
                                child: ComplaintRevisionsScreen(
                                  complaintId: state.complaints[index].id,
                                ),
                              ),
                            ),
                          );
                        },
                        child: ModernComplaintCard(
                          complaint: state.complaints[index],
                        ),
                      );
                    },
                  ),
                ),

                buildPaginationControls(context, state, cubit, agencyid),
              ],
            );
          }
          return const SizedBox.shrink(); // حالة Initial
        },
      ),
    );
  }

  // ودجت بناء أزرار الترقيم
}
