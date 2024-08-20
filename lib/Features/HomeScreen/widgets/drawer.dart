import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Chat/lastseen.dart';
import 'package:hamo_pharmacy/Features/Doctor/doctorreservation.dart';
import 'package:hamo_pharmacy/Features/Favourate/favouratepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildDrawer(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Drawer(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final userData = snapshot.data?.data() as Map<String, dynamic>?;
      final userType = userData?[
          'type']; // Assuming 'type' field is used to determine if the user is a doctor

      return FutureBuilder<bool>(
        future: isDoctor(user?.uid),
        builder: (context, doctorSnapshot) {
          if (!doctorSnapshot.hasData) {
            return Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final isDoctor = doctorSnapshot.data ?? false;

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('اسم المستخدم'),
                  accountEmail: Text(user?.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://example.com/user_image.png'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.home),
                  title: Text('الرئيسية'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                if (isDoctor) // Show this item if the user is a doctor
                  ListTile(
                    leading: Icon(FontAwesomeIcons.book),
                    title: Text('حجوزاتي'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorReservationsPage()),
                      );
                    },
                  ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendar),
                  title: Text('موعدي'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/user_appointment');
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendar),
                  title: Text('المعاملات البنكيه'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/transaction_history');
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.heart),
                  title: Text('المفضلة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.envelope),
                  title: Text('الرسائل'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LastSeenPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.signOutAlt),
                  title: Text('تسجيل الخروج'),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('isLoggedIn');
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/sign_in');
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<bool> isDoctor(String? userId) async {
  if (userId == null) return false;

  final doctorDoc =
      await FirebaseFirestore.instance.collection('doctors').doc(userId).get();
  return doctorDoc.exists;
}
