// import 'package:compaintsystem/core/func/open_pdf.dart';
// import 'package:compaintsystem/core/widget/app_bar_widget.dart';
// import 'package:compaintsystem/featuer/complaint/data/complaint_model';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PdfComplaint extends StatefulWidget {
//   const PdfComplaint({super.key, required this.complaint});

//   final Complaint complaint;

//   @override
//   State<PdfComplaint> createState() => _PdfComplaintState();
// }

// class _PdfComplaintState extends State<PdfComplaint> {
//   Future<void> _openPdfFile(String fileUrl) async {
//     // 🔥 التصحيح: استخدام canLaunchUrl و launchUrl بدلاً من canLaunch و launch
//     final Uri uri = Uri.parse("http://127.0.0.1:8000/storage/$fileUrl");

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(
//         uri,
//         mode: LaunchMode.externalApplication, // يفتح في متصفح خارجي
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('تعذر فتح الملف: $fileUrl')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final attachments = widget.complaint.attachments;

//     return Scaffold(
//       appBar: const AppareWidget(
//         title: 'ملفات الشكوى (PDF)',
//         automaticallyImplyLeading: true,
//       ),
//       body: attachments.isEmpty
//           ? const Center(
//               child: Text(
//                 'لا يوجد ملفات PDF مرفقة',
//                 style: TextStyle(fontSize: 16),
//               ),
//             )
//           : ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: attachments.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 10),
//               itemBuilder: (context, index) {
//                 final file = attachments[index];
//                 final fullUrl =
//                     "http://127.0.0.1:8000/storage/${file.filePath}";

//                 return Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(
//                       color: Colors.redAccent.withOpacity(0.3),
//                     ),
//                     color: Colors.redAccent.withOpacity(0.05),
//                   ),
//                   child: ListTile(
//                     leading: const Icon(
//                       Icons.picture_as_pdf,
//                       color: Colors.red,
//                       size: 32,
//                     ),
//                     title: Text(
//                       "ملف PDF رقم ${index + 1}",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       file.filePath.split('/').last,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.open_in_new, color: Colors.red),
//                       onPressed: () => openPdfFile(file.filePath, context),
//                     ),
//                     onTap: () => _openPdfFile(file.filePath),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
