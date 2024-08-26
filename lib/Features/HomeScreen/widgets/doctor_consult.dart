import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamo_pharmacy/Features/Doctor/view/spicialtypage.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

Widget buildDoctorConsultationSection(BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: 330,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20), // حواف دائرية للخلفية
        ),
      ),
      Positioned(
        bottom: 0,
        left: 5,
        child: Container(
          height: 200,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // حواف دائرية للصورة
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15), // قص الصورة بحواف دائرية
            child: Image.asset(
              Assets.nurse.path,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 25,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpecialtiesPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // حواف دائرية للزر
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            "احجز الان",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Positioned(
        right: 10,
        top: 20,
        child: Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "صحتك جيده باذن الله\n",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "معنا",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center, // لتوسيط النص
          ),
        ),
      ),
    ],
  );
}
