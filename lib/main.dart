import 'package:compaintsystem/featuer/complaint/presentation/view/add_complaint_view.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/complaint_view.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/goverment_agencies_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complaint System',
      home: const NewComplaintView(agencyId: 3),
    );
  }
}
