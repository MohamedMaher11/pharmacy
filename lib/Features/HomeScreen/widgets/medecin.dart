import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/Model/medecinmodel.dart'; // استيراد الـ models

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
            return _buildMedicineCard(medicine);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine medicine) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(medicine.imageUrl, height: 80),
          SizedBox(height: 8),
          Text(medicine.name, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
