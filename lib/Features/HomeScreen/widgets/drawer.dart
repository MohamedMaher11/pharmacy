import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Chat/view/lastseen.dart';
import 'package:hamo_pharmacy/Features/Doctor/view/doctorreservation.dart';
import 'package:hamo_pharmacy/Features/Favourate/view/favouratemedicn.dart';
import 'package:hamo_pharmacy/Features/Favourate/view/Favouratedoctor.dart';
import 'package:hamo_pharmacy/Features/Profile/view/profile/profile.dart';
import 'package:hamo_pharmacy/Features/Profile/view/Setting/passwordchange.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildDrawer(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return FutureBuilder<Map<String, dynamic>?>(
    future: getUserData(user?.uid),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Drawer(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final userData = snapshot.data;
      final userImageUrl = userData?['imageUrl'];
      final isDoctor = userData !=
          null; // If userData is not null, the user is either a doctor or a regular user

      return Container(
        width: MediaQuery.of(context).size.width,
        child: Drawer(
          child: Stack(
            children: [
              Container(
                color: Colors.deepPurpleAccent.withOpacity(0.9),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        'اسم المستخدم',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      accountEmail: Text(
                        user?.email ?? '',
                        style: TextStyle(color: Colors.white70),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: userImageUrl != null
                            ? NetworkImage(userImageUrl)
                            : AssetImage(Assets.user.path) as ImageProvider,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                    ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.user,
                      text: 'الملف الشخصي',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.lock,
                      text: 'تغيير كلمة المرور',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                      },
                    ),
                    if (isDoctor &&
                        userData?['collection'] ==
                            'doctors') // Check if the user is a doctor based on the collection
                      buildAnimatedDrawerItem(
                        icon: FontAwesomeIcons.bookMedical,
                        text: 'حجوزاتي',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorReservationsPage()),
                          );
                        },
                      ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.calendarDay,
                      text: 'موعدي',
                      onTap: () {
                        Navigator.of(context).pushNamed('/user_appointment');
                      },
                    ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.moneyCheckAlt,
                      text: 'المعاملات البنكية',
                      onTap: () {
                        Navigator.of(context).pushNamed('/transaction_history');
                      },
                    ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.heart,
                      text: 'المفضلة',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritesPage()),
                        );
                      },
                    ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.envelope,
                      text: 'الرسائل',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LastSeenPage()),
                        );
                      },
                    ),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.userMd,
                      text: "الدكاتره المفضلون",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyFavoritesPage()),
                        );
                      },
                    ),
                    Spacer(),
                    buildAnimatedDrawerItem(
                      icon: FontAwesomeIcons.signOutAlt,
                      text: 'تسجيل الخروج',
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('isLoggedIn');
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacementNamed('/sign_in');
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.times,
                      color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the Drawer when pressing "X"
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildAnimatedDrawerItem({
  required IconData icon,
  required String text,
  required Function() onTap,
}) {
  return ListTile(
    leading: FaIcon(icon, color: Colors.white),
    title: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    onTap: onTap,
    trailing: TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: FaIcon(
            FontAwesomeIcons.chevronRight,
            color: Colors.white70,
          ),
        );
      },
    ),
  );
}

Future<Map<String, dynamic>?> getUserData(String? userId) async {
  if (userId == null) throw Exception("User ID is null");

  // Check if user is in 'doctors' collection
  final doctorDoc =
      await FirebaseFirestore.instance.collection('doctors').doc(userId).get();
  if (doctorDoc.exists) {
    return {'collection': 'doctors', ...doctorDoc.data()!};
  }

  // Check if user is in 'users' collection
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (userDoc.exists) {
    return {'collection': 'users', ...userDoc.data()!};
  }

  throw Exception("User not found in 'doctors' or 'users' collection");
}
