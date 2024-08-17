import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Model/medecinmodel.dart'; // استيراد النماذج
import 'package:hamo_pharmacy/Features/AllCategory/allcategory.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/medecin.dart';

Widget buildHealthCategorySection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('فئة الصحة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              // الانتقال إلى صفحة جميع الفئات
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCategoriesPage()),
              );
            },
            child: Text('عرض الكل', style: TextStyle(color: Colors.blue)),
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
    case 'السعال':
      return FontAwesomeIcons.syringe;
    case 'تخفيف الألم':
      return FontAwesomeIcons.pills;
    case 'العناية بالبشرة':
      return FontAwesomeIcons.soap;
    case 'الصداع':
      return FontAwesomeIcons.headSideVirus;
    case 'الحمى':
      return FontAwesomeIcons.temperatureHigh;
    case 'الضعف':
      return FontAwesomeIcons.tired;
    default:
      return FontAwesomeIcons.pills; // افتراضي
  }
}
