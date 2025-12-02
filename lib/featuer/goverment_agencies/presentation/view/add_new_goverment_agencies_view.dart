import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_cubit.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/widget/add_goverment_body.dart';
import 'package:compaintsystem/featuer/goverment_agencies/repo/repo_governmentagency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 💡 الودجت الرئيسية التي توفر الـ Cubit
class CreateGovernmentAgencyView extends StatelessWidget {
  const CreateGovernmentAgencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CreateGovernmentAgencyCubit(GovernmentAgenciesRepo(ApiService())),
      child: CreateGovernmentAgencyViewBody(),
    );
  }
}
