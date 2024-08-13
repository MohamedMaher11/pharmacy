import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// دالة لبناء شريط البحث
Widget buildSearchBar() {
  return TextField(
    decoration: InputDecoration(
      hintText: 'ابحث عن دواء',
      prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      fillColor: Colors.white,
      filled: true,
    ),
  );
}
