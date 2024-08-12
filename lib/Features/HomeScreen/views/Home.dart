import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/Features/Cart/cartpage.dart';
import 'package:hamo_pharmacy/Features/Favourate/favouratepage.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/category.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/discount.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/doctor_consult.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/offersection.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/searchbar.dart';

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
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            buildSearchBar(),
            SizedBox(height: 20),
            buildDoctorConsultationSection(context),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future: _getUserOrDoctorData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!;
          final userName = userData['name'] ?? 'User';
          final userImage = userData['imageUrl'] ??
              'https://www.example.com/default-profile-picture.png'; // صورة افتراضية

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName),
                accountEmail: Text(_auth.currentUser?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('My Cart'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/sign_in');
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _getUserOrDoctorData() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw Exception('No user is logged in');
    }
    try {
      final doctorDoc = await _firestore.collection('doctors').doc(uid).get();
      if (doctorDoc.exists) {
        return doctorDoc;
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }

    // محاولة جلب بيانات المستخدم أولاً
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    // إذا لم يكن المستخدم موجودًا، جلب البيانات من مجموعة الأطباء

    throw Exception('No user or doctor data found');
  }
}
