import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

// Enhanced Offers Section
Widget buildOffersSection() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildOfferCard('50% Off', 'ORDER TODAY', Assets.doctor.path),
      _buildOfferCard('Free on\nFirst Order', 'HOME DELIVERY', ''),
    ],
  );
}

Widget _buildOfferCard(String title, String subtitle, String imagePath) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.black)),
        ],
      ),
    ),
  );
}
