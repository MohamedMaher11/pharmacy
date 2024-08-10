import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/category.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/discount.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/doctor_consult.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/offersection.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/searchbar.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Pharmacy',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            buildSearchBar(),
            SizedBox(height: 20),

            // Section for Doctor Image and Consultation Message
            buildDoctorConsultationSection(),
            SizedBox(height: 20),

            // Health Category Section
            buildHealthCategorySection(context),
            SizedBox(height: 20),

            // Offers Section
            buildOffersSection(),
            SizedBox(height: 20),

            // Discount Section with Carousel
            buildDiscountCarousel(),
          ],
        ),
      ),
    );
  }
}
