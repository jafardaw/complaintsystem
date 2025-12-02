import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openPdfFile(String fileUrl, BuildContext context) async {
  // يجب عليك التأكد من أن fileUrl هو رابط كامل (مثل: http://127.0.0.1:8000/storage/...)
  // لا يمكنني معرفة BaseUrl هنا، لذا أفترض أن fileUrl هو الرابط الكامل.
  final Uri uri = Uri.parse(fileUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تعذر فتح الملف: $fileUrl')));
  }
}
