// Discount Carousel Section with larger view and improved style
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

Widget buildDiscountCarousel() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20.0),
    child: CarouselSlider(
      options: CarouselOptions(
        height: 100.0, // Increase the height of the carousel
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9, // Maintain a widescreen aspect ratio
        initialPage: 0,
      ),
      items: [
        _buildDiscountCard('Summer Sale', 'Up to 70% Off', Assets.offer.path),
        _buildDiscountCard('Flash Deal', 'Buy 1 Get 1 Free', Assets.offer.path),
        _buildDiscountCard('Limited Offer', 'Free Delivery', Assets.offer.path),
      ],
    ),
  );
}

Widget _buildDiscountCard(String title, String subtitle, String imagePath) {
  return Container(
    width: 270,
    height: 10,
    margin: EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}
