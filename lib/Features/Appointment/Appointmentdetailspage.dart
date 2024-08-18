import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Appointment/widgets/buildanimtedbutton.dart';
import 'package:hamo_pharmacy/Features/Appointment/widgets/buildpdfrow.dart';
import 'package:hamo_pharmacy/Features/Appointment/widgets/buildrow.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppointmentDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot appointment;

  AppointmentDetailPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final name = appointment['name'];
    final address = appointment['address'];
    final phone = appointment['phone'];
    final condition = appointment['condition'];
    final appointmentStart =
        (appointment['appointmentStart'] as Timestamp).toDate();
    final appointmentEnd =
        (appointment['appointmentEnd'] as Timestamp).toDate();
    final status = appointment['status'];

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الموعد'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'روشتة طبية',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'تفاصيل الموعد',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    buildInfoRow('اسم المريض  ', name, Icons.person),
                    buildInfoRow('العنوان  ', address, Icons.location_on),
                    buildInfoRow('رقم الهاتف  ', phone, Icons.phone),
                    buildInfoRow(
                        'الحالة  ', condition, Icons.health_and_safety),
                    buildInfoRow(
                      'التوقيت  ',
                      '${DateFormat('d/M/yyyy').format(appointmentStart)} من الساعة ${DateFormat('h:mm a', 'ar').format(appointmentStart)} إلى الساعة ${DateFormat('h:mm a', 'ar').format(appointmentEnd)}',
                      Icons.access_time,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'الحالة:   $status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: status == 'Booked' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'تاريخ العرض:   ${DateFormat('d/M/yyyy').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildAnimatedButton(
                    context,
                    icon: FontAwesomeIcons.print,
                    color: Colors.blue,
                    label: 'طباعة',
                    onPressed: () {
                      _printAppointment(context);
                    },
                  ),
                  buildAnimatedButton(
                    context,
                    icon: FontAwesomeIcons.remove,
                    color: Colors.red,
                    label: 'حذف',
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printAppointment(BuildContext context) async {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.amiriRegular();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Container(
              padding: pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey, width: 2),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'روشتة طبية',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont,
                        color: PdfColors.deepPurple,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'تفاصيل الموعد:',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      font: arabicFont,
                      color: PdfColors.deepPurple,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  buildPdfRow('اسم المريض  ', appointment['name'], arabicFont),
                  buildPdfRow('الهاتف  ', appointment['phone'], arabicFont),
                  buildPdfRow('العنوان  ', appointment['address'], arabicFont),
                  buildPdfRow(
                    'التوقيت  ',
                    '${DateFormat('d/M/yyyy').format(appointment['appointmentStart'].toDate())} من الساعة ${DateFormat('h:mm a', 'ar').format(appointment['appointmentStart'].toDate())} إلى الساعة ${DateFormat('h:mm a', 'ar').format(appointment['appointmentEnd'].toDate())}',
                    arabicFont,
                  ),
                  pw.SizedBox(height: 40),
                  pw.Center(
                    child: pw.Text(
                      'أسأل الله العظيم رب العرش العظيم أن يشفيك.',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont,
                        color: PdfColors.deepPurple,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  buildPdfRow('نصائح للشفاء:', '', arabicFont),
                  buildPdfRow('• التزم بالوقت المحدد للموعد.', '', arabicFont),
                  buildPdfRow(
                      '• احرص على الهدوء أثناء انتظارك.', '', arabicFont),
                  buildPdfRow(
                      '• تذكر أن الشفاء بيد الله، واتبع نصائح الطبيب بدقة.',
                      '',
                      arabicFont),
                ],
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد أنك تريد حذف هذا الموعد؟'),
        actions: [
          TextButton(
            child: Text('إلغاء'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('حذف'),
            onPressed: () {
              appointment.reference.delete().then((_) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
