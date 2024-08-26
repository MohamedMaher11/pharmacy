import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Medecins/view/medecin.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/Features/Medecins/view/allcategory.dart';
import 'package:hamo_pharmacy/core/functions.dart';

Widget buildHealthCategorySection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'فئة الصحة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              // الانتقال إلى صفحة جميع الفئات
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCategoriesPage()),
              );
            },
            child: Text(
              'عرض الكل',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      _buildHealthCategories(context),
    ],
  );
}

Widget _buildHealthCategories(BuildContext context) {
  final limitedCategories = categories.take(3).toList();

  return GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    childAspectRatio: 1,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    children: limitedCategories.map((category) {
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
          builder: (context) => MedicinePage(category: category),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(2, 4), // ظل خفيف لتأثير ثلاثي الأبعاد
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // استخدام الأيقونة المناسبة لكل فئة
          getCategoryImage(category.name),
          SizedBox(height: 12),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center, // تحسين محاذاة النص
          ),
        ],
      ),
    ),
  );
}
