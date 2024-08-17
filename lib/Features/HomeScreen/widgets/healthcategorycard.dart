import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/medecin.dart';

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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(category.name),
            color: Colors.deepPurple,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(category.name, style: TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}

// وظيفة للحصول على الأيقونة المناسبة بناءً على اسم الفئة
IconData _getCategoryIcon(String categoryName) {
  switch (categoryName) {
    case 'Cough':
      return FontAwesomeIcons.syringe;
    case 'Pain Relief':
      return FontAwesomeIcons.pills;
    case 'Skin Care':
      return FontAwesomeIcons.soap;
    case 'Headache':
      return FontAwesomeIcons.headSideVirus;
    case 'Fever':
      return FontAwesomeIcons.temperatureHigh;
    case 'Weakness':
      return FontAwesomeIcons.tired;
    case 'Allergy':
      return FontAwesomeIcons.allergies;
    case 'Vitamins':
      return FontAwesomeIcons.capsules;
    case 'Digestive':
      return FontAwesomeIcons.procedures;
    default:
      return FontAwesomeIcons.pills; // افتراضي
  }
}
