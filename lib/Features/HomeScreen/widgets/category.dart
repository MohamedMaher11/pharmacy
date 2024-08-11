import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/Model/medecinmodel.dart'; // استيراد الـ models
import 'package:hamo_pharmacy/Features/HomeScreen/views/allcategory.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/medecin.dart';

Widget buildHealthCategorySection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Health Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              // Navigate to the all categories page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCategoriesPage()),
              );
            },
            child: Text('View all', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      SizedBox(height: 16),
      _buildHealthCategories(context),
    ],
  );
}

Widget _buildHealthCategories(BuildContext context) {
  return GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    childAspectRatio: 1,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    children: categories.map((category) {
      return _buildHealthCategoryCard(category, context);
    }).toList(),
  );
}

Widget _buildHealthCategoryCard(Category category, BuildContext context) {
  return GestureDetector(
    onTap: () {
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
          // استخدام الأيقونة المناسبة لكل فئة
          Icon(
            _getCategoryIcon(category.name),
            color: Colors.orange,
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
    default:
      return FontAwesomeIcons.pills; // افتراضي
  }
}
