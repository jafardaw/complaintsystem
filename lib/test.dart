import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import 'package:pdf/pdf.dart';

// --- Cubit لإدارة حالة التقرير ---
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  final Uint8List data;
  ReportSuccess(this.data);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}

class ReportCubit extends Cubit<ReportState> {
  final Dio _dio = Dio();

  ReportCubit() : super(ReportInitial());

  @override
  void emit(ReportState state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> getPdfReport() async {
    emit(ReportLoading());
    try {
      final response = await _dio.get(
        'http://127.0.0.1:8000/api/reports/complaints/pdf', // تأكد من الـ IP
        options: Options(
          responseType: ResponseType.bytes, // ضروري جداً
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/pdf',
            'Authorization':
                'Bearer 53|ay3MpcUv7Sb8sCxrxZHvzbjaPVsJXh5EpFr3W5bf8f62203e',
          },
        ),
      );

      if (response.statusCode == 200) {
        // تأكد أن البيانات ليست نصاً برمجياً للخطأ (Error JSON)
        final Uint8List bytes = Uint8List.fromList(response.data);

        if (bytes.isNotEmpty) {
          emit(ReportSuccess(bytes));
        } else {
          emit(ReportError("الملف فارغ"));
        }
      } else {
        emit(ReportError("السيرفر استجاب بكود: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      // تفصيل الخطأ لمعرفة السبب الحقيقي
      String errorMsg = "خطأ في الشبكة";
      if (e.type == DioExceptionType.connectionTimeout)
        errorMsg = "انتهى وقت الاتصال";
      if (e.response?.statusCode == 401)
        errorMsg = "التوكن غير صالح (Unauthorized)";
      if (e.response?.statusCode == 404) errorMsg = "الرابط غير صحيح";

      emit(ReportError(errorMsg));
    }
  }
}

// --- واجهة المستخدم ---
class AdminReportScreen extends StatelessWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit()..getPdfReport(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تقرير الشكاوى"),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<ReportCubit>().getPdfReport(),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReportError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 50,
                    ),
                    Text(state.message),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ReportCubit>().getPdfReport(),
                      child: const Text("إعادة محاولة"),
                    ),
                  ],
                ),
              );
            } else if (state is ReportSuccess) {
              return PdfPreview(
                build: (format) => state.data,
                pdfFileName: "report.pdf",
                // إعدادات إضافية لضمان العرض داخل المتصفح
                useActions: true,
                allowPrinting: true,
                allowSharing: true,
                canChangePageFormat: false,
              );
            }
            return const Center(child: Text("انتظار..."));
          },
        ),
      ),
    );
  }
}
