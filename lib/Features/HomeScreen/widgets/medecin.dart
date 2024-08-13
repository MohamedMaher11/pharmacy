import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/Features/DetailsPage/medecindetails.dart'; // استيراد الـ models

class MedicinePage extends StatelessWidget {
  final Category category;

  MedicinePage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Medicines'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: category.medicines.map((medicine) {
            return _buildMedicineCard(context, medicine);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(BuildContext context, Medicine medicine) {
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
        tag:
            'medicine-${medicine.name}', // تعديل هنا لاستخدام اسم الدواء بشكل صحيح
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
            ],
          ),
        ),
      ),
    );
  }
}
