import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/DetailsPage/medecindetails.dart';
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
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(medicine.imageUrl, height: 80),
            SizedBox(height: 8),
            Text(medicine.name, style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text('\$${medicine.price}',
                style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
      ),
    ),
  );
}
