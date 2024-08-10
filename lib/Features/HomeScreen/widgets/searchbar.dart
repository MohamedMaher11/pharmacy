import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildSearchBar() {
  return TextField(
    decoration: InputDecoration(
      hintText: 'Search Medicine',
      prefixIcon: Icon(Icons.search, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      fillColor: Colors.white,
      filled: true,
    ),
  );
}
