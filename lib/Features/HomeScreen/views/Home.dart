import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/views/cartpage.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/views/favouratepage.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/category.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/discount.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/doctor_consult.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/offersection.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/searchbar.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              'Pharmacy',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            StreamBuilder<int>(
              stream: _firestore
                  .collection('cart')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots()
                  .map((snapshot) => snapshot.docs.length),
              builder: (context, snapshot) {
                final cartCount = snapshot.data ?? 0;
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.shoppingCart,
                          color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '$cartCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(
              width: 15,
            ),
            StreamBuilder<int>(
              stream: _firestore
                  .collection('favorites')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots()
                  .map((snapshot) => snapshot.docs.length),
              builder: (context, snapshot) {
                final favoritesCount = snapshot.data ?? 0;
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.heart, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritesPage()),
                        );
                      },
                    ),
                    if (favoritesCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '$favoritesCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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
            buildDoctorConsultationSection(),
            SizedBox(height: 20),
            buildHealthCategorySection(context),
            SizedBox(height: 20),
            buildOffersSection(),
            SizedBox(height: 20),
            buildDiscountCarousel(),
          ],
        ),
      ),
    );
  }
}
