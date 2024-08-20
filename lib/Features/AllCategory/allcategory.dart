import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/healthcategorycard.dart';

class AllCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('كل الاقسام'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: categories.map((category) {
            return buildHealthCategoryCard(category, context);
          }).toList(),
        ),
      ),
    );
  }
}
