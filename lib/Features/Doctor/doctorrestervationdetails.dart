import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReservationDetailsPage extends StatelessWidget {
  final DocumentSnapshot appointment;

  ReservationDetailsPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الحجز'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _generateAndPrintPdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 30),
                  _buildInfoRow('اسم المريض', appointment['name']),
                  SizedBox(height: 20),
                  _buildInfoRow('الهاتف', appointment['phone']),
                  SizedBox(height: 20),
                  _buildInfoRow('العنوان', appointment['address']),
                  SizedBox(height: 20),
                  _buildInfoRow(
                    'التوقيت',
                    '${DateFormat.jm().format(appointment['appointmentStart'].toDate())} - '
                        '${DateFormat.jm().format(appointment['appointmentEnd'].toDate())}',
                  ),
                  SizedBox(height: 20),
                  _buildInfoRow(
                    'التاريخ',
                    '${DateFormat.yMMMd().format(appointment['appointmentStart'].toDate())}',
                  ),
                  SizedBox(height: 30),
                  _buildInfoRow('وصف الحالة', appointment['condition']),
                  SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            'شكرًا لاختيارك خدماتنا!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'تفاصيل الحجز الخاصة بك',
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String info) {
    return Row(
      children: [
        Text('$title: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            )),
        Expanded(
          child: Text(info,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              )),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _generateAndPrintPdf,
        icon: Icon(Icons.picture_as_pdf, color: Colors.white),
        label: Text('طباعة كـ PDF',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _generateAndPrintPdf() async {
    final pdf = pw.Document();

    // استخدام خط يتوافق مع الطباعة باللغة العربية
    final arabicFont = await PdfGoogleFonts.amiriRegular();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(15), // ضبط الهوامش
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection:
                pw.TextDirection.rtl, // اتجاه النصوص من اليمين لليسار
            child: pw.Center(
              child: pw.Container(
                width: double.infinity,
                height: 600, // ضبط الارتفاع ليشغل 3/4 من الصفحة
                decoration: pw.BoxDecoration(
                  color: PdfColors.white, // لون خلفية الصفحة
                  border: pw.Border.all(
                      color: PdfColors.grey, width: 1), // حدود خفيفة
                  borderRadius: pw.BorderRadius.circular(8), // تدوير الزوايا
                ),
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'تفاصيل الحجز',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                        font: arabicFont,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'اسم المريض: ${appointment['name']}',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'الهاتف: ${appointment['phone']}',
                      style: pw.TextStyle(fontSize: 16, font: arabicFont),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'العنوان: ${appointment['address']}',
                      style: pw.TextStyle(fontSize: 16, font: arabicFont),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'التوقيت: ${DateFormat.jm().format(appointment['appointmentStart'].toDate())} - '
                      '${DateFormat.jm().format(appointment['appointmentEnd'].toDate())}',
                      style: pw.TextStyle(fontSize: 16, font: arabicFont),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'التاريخ: ${DateFormat.yMMMd().format(appointment['appointmentStart'].toDate())}',
                      style: pw.TextStyle(fontSize: 16, font: arabicFont),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'وصف الحالة:',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                        font: arabicFont,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      appointment['condition'],
                      style: pw.TextStyle(fontSize: 16, font: arabicFont),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    // إضافة الدعاء والابتسامة في الأسفل
                    pw.Center(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'نسأل الله لكم الشفاء العاجل، ودعواتنا بالصحة والعافية.',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueGrey800,
                              font: arabicFont,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
