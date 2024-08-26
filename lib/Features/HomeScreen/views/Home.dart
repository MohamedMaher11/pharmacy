import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/Features/Appointment/view/Appointmentdetailspage.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/drawer.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/notifcation.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';
import 'package:intl/intl.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/carticon.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/favourateicon.dart';
import 'package:hamo_pharmacy/Features/Medecins/widget/category.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/discount.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/doctor_consult.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/populardoctor.dart';
import 'package:hamo_pharmacy/Features/Medecins/widget/medecincard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showNotifications = false;
  int _notificationCount = 0;
  String _searchQuery = '';
  List<Medicine> _medicines = [];
  List<Medicine> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines(); // التأكد من تحميل الأدوية
    _fetchNotifications();
  }

  void _fetchMedicines() {
    _medicines = categories.expand((category) => category.medicines).toList();
    _filteredMedicines = _medicines;
  }

  Future<void> _fetchNotifications() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final querySnapshot = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: user.uid)
        .where('isRead', isEqualTo: false)
        .get();

    setState(() {
      _notificationCount = querySnapshot.docs.length;
    });
  }

  void _toggleNotifications() {
    setState(() {
      _showNotifications = !_showNotifications;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredMedicines = [];
      } else {
        _filteredMedicines = _medicines.where((medicine) {
          return medicine.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

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
              'صيدلية',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            buildCartIcon(),
            SizedBox(width: 15),
            buildFavoritesIcon(),
            SizedBox(width: 15),
            GestureDetector(
              onTap: _toggleNotifications,
              child: Stack(
                children: [
                  FaIcon(FontAwesomeIcons.bell, color: Colors.grey, size: 28),
                  if (_notificationCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints:
                            BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Center(
                          child: Text(
                            '$_notificationCount',
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
              ),
            ),
          ],
        ),
      ),
      drawer: buildDrawer(context),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildSearchBar(),
                SizedBox(height: 20),
                if (_searchQuery.isNotEmpty)
                  _buildMedicineGrid()
                else
                  _buildMainContent(),
              ],
            ),
          ),
          if (_showNotifications)
            NotificationsOverlay(
                auth: _auth,
                firestore: _firestore,
                onNotificationTap: () {
                  setState(() {
                    _showNotifications = false;
                  });
                }),
        ],
      ),
    );
  }

  Widget _buildMedicineGrid() {
    return _filteredMedicines.isEmpty
        ? Center(child: Text('لا توجد نتائج'))
        : GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: _filteredMedicines.map((medicine) {
              return buildMedicineCard(context, medicine);
            }).toList(),
          );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 20),
          buildDoctorConsultationSection(context),
          SizedBox(height: 20),
          buildHealthCategorySection(context),
          SizedBox(height: 20),
          PopularDoctorsSection(),
          SizedBox(height: 20),
          buildDiscountCarousel(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (query) => _updateSearchQuery(query),
      decoration: InputDecoration(
        hintText: 'البحث عن علاج ....',
        prefixIcon: Icon(FontAwesomeIcons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
