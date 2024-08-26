import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Medecins/view/medecin.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart' as medecinModel;
import 'package:hamo_pharmacy/core/functions.dart';

class AllCategoriesPage extends StatefulWidget {
  @override
  _AllCategoriesPageState createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  String _searchQuery = ''; // لحفظ نص البحث

  @override
  Widget build(BuildContext context) {
    List<medecinModel.Category> filteredCategories = medecinModel.categories
        .where((category) => category.name.contains(_searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('اختر الفئة', style: fontcolor()),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSearchBar(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'الفئات',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(filteredCategories[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن قسم...',
          border: InputBorder.none,
          icon: Icon(FontAwesomeIcons.search, color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(medecinModel.Category category) {
    return GestureDetector(
      onTap: () {
        // تنفيذ الانتقال إلى صفحة التفاصيل عند الضغط على الفئة
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicinePage(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 130, 81, 214),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getCategoryImage(category.name), // استخدم الصورة بدلاً من الأيقونة

            SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
