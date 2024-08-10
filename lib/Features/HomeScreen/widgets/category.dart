import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildHealthCategorySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Health Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('View all', style: TextStyle(color: Colors.blue)),
        ],
      ),
      SizedBox(height: 16),
      _buildHealthCategories(),
    ],
  );
}

Widget _buildHealthCategories() {
  return GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    childAspectRatio: 1,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    children: [
      _buildHealthCategoryCard('Cough', FontAwesomeIcons.syringe),
      _buildHealthCategoryCard('Pain Relief', FontAwesomeIcons.pills),
      _buildHealthCategoryCard('Skin Care', FontAwesomeIcons.soap),
      _buildHealthCategoryCard('Headache', FontAwesomeIcons.headSideVirus),
      _buildHealthCategoryCard('Fever', FontAwesomeIcons.temperatureHigh),
      _buildHealthCategoryCard('Weakness', FontAwesomeIcons.tired),
    ],
  );
}

Widget _buildHealthCategoryCard(String title, IconData icon) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.orange, size: 40),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    ),
  );
}
