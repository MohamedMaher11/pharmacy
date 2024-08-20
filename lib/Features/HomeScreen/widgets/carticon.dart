import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Cart/cartpage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Widget buildCartIcon() {
  return StreamBuilder<int>(
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
            icon: Icon(FontAwesomeIcons.shoppingCart, color: Colors.grey),
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
                constraints: BoxConstraints(minWidth: 20, minHeight: 20),
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
  );
}
