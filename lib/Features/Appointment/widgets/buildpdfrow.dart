import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildPdfRow(String label, String value, pw.Font font) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 5),
    child: pw.Row(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            font: font,
            color: PdfColors.deepPurple,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              font: font,
              color: PdfColors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
