import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/get_cubit/get_governmentagency_cubit.dart';
import 'package:compaintsystem/featuer/goverment_agencies/repo/repo_governmentagency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widget/goverment_agwncies_body.dart' show GovermentAgenciesViewBody;

class GovermentAgenciesView extends StatelessWidget {
  const GovermentAgenciesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GovernmentAgenciesCubit(GovernmentAgenciesRepo(ApiService())),
      child: GovermentAgenciesViewBody(),
    );
  }
}
