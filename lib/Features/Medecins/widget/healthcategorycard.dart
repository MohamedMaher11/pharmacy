import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/core/functions.dart';
import 'package:hamo_pharmacy/Features/Medecins/view/medecin.dart';

Widget buildHealthCategoryCard(Category category, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // الانتقال إلى صفحة الأدوية للفئة المحددة
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MedicinePage(category: category)),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: getCategoryImage(category.name),
          ),
          SizedBox(height: 12),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    ),
  );
}
