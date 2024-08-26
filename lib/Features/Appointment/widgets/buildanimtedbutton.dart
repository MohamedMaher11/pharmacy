import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/core/functions.dart';

Widget buildAnimatedButton(BuildContext context,
    {required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed}) {
  return ScaleTransition(
    scale: Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeOut,
      ),
    ),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: fontcolor()),
      onPressed: onPressed,
    ),
  );
}
