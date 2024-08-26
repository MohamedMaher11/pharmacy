import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Medecins/view/medecindetails.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';

Widget buildMedicineCard(BuildContext context, Medicine medicine) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineDetailPage(medicine: medicine),
        ),
      );
    },
    child: Hero(
      tag: 'medicine-${medicine.name}',
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(5, 10), // ظل ثلاثي الأبعاد
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(medicine.imageUrl, height: 80),
            SizedBox(height: 8),
            Text(
              medicine.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold, // تحسين مظهر النص
              ),
            ),
            SizedBox(height: 4),
            Text(
              '\$${medicine.price}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.bold, // تحسين مظهر النص
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
