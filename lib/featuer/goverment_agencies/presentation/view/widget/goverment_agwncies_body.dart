import 'package:compaintsystem/core/func/calculat_cross_axis_count.dart';
import 'package:compaintsystem/core/func/float_action_button.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/complaint_view.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/add_new_goverment_agencies_view.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/get_cubit/get_governmentagency_cubit.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/get_cubit/get_governmentagency_state.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_cubit.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/update_goverment_agwncires_view.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/widget/agency_card.dart';
import 'package:compaintsystem/featuer/goverment_agencies/repo/repo_governmentagency.dart';
import 'package:compaintsystem/featuer/profile/presentation/view/profile_view.dart';
import 'package:compaintsystem/featuer/users/presentation/view/add_stuff_view.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/post_cubit/add_stauff_cubit.dart';
import 'package:compaintsystem/featuer/users/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GovermentAgenciesViewBody extends StatefulWidget {
  const GovermentAgenciesViewBody({super.key});

  @override
  State<GovermentAgenciesViewBody> createState() =>
      _GovermentAgenciesViewBodyState();
}

class _GovermentAgenciesViewBodyState extends State<GovermentAgenciesViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GovernmentAgenciesCubit>().fetchAgencies();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<GovernmentAgenciesCubit>().fetchAgencies(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ProfileDrawer(),
      appBar: AppareWidget(
        title: 'الهيئات الحكومية',
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<GovernmentAgenciesCubit, GovernmentAgenciesState>(
        builder: (context, state) {
          if (state is GovernmentAgenciesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          }

          if (state is GovernmentAgenciesError) {
            return Center(child: Text("خطأ: ${state.error}"));
          }

          if (state is GovernmentAgenciesSuccess) {
            final hasMore = state.currentPage < state.lastPage;

            return MasonryGridView.count(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              crossAxisCount: calculateCrossAxisCountuser(context), // نفس دالتك
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: state.agencies.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.agencies.length && hasMore) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: Colors.blueGrey),
                    ),
                  );
                }

                final agency = state.agencies[index];

                return AgencyGridCardM3(
                  onComplaint: () {
                    print('mmmmmmmmmmmm');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ComplaintsView(agencyid: agency.id),
                      ),
                    );
                  },
                  agency: agency,
                  onperson: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              AddUserCubit(UsersRepository(ApiService())),
                          child: AddUserScreen(agencyId: agency.id),
                        ),
                      ),
                    );
                  },
                  onDelete: () {},
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CreateGovernmentAgencyCubit(
                            GovernmentAgenciesRepo(ApiService()),
                          ),
                          child: UpdateGovernmentAgencyView(
                            governmentAgency: agency,
                          ),
                        ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        context.read<GovernmentAgenciesCubit>().fetchAgencies();
                      }
                    });
                  },
                );
              },
            );
          }

          return const Center(child: Text("جاري جلب البيانات..."));
        },
      ),

      floatingActionButton: buildFloatactionBoutton(
        context,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGovernmentAgencyView(),
            ),
          ).then((result) {
            if (result == true) {
              context.read<GovernmentAgenciesCubit>().fetchAgencies();
            }
          });
        },
      ),
    );
  }
}
