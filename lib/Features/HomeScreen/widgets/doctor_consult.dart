import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/category.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

Widget buildDoctorConsultationSection(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // الانتقال إلى صفحة الأقسام الطبية عند الضغط على الواجهة
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => buildHealthCategorySection(context)),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            Assets.doctor.path, // Add your doctor image in the assets directory
            height: 40,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Need a consultation? Connect with our experienced doctors now.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
