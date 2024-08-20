import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/Features/Chat/lastseen.dart';
import 'package:hamo_pharmacy/Features/DetailsPage/medecindetails.dart';
import 'package:hamo_pharmacy/Features/Doctor/doctorreservation.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/carticon.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/category.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/discount.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/doctor_consult.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/drawer.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/favourateicon.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/medecincard.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/offersection.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/core/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _searchQuery = '';
  List<Medicine> _medicines = [];
  List<Medicine> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  void _fetchMedicines() {
    _medicines = categories.expand((category) => category.medicines).toList();
    _filteredMedicines = _medicines;
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
          ],
        ),
      ),
      drawer: buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            if (_searchQuery.isNotEmpty)
              _buildMedicineGrid()
            else
              _buildDefaultContent(),
          ],
        ),
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

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDoctorConsultationSection(context),
        SizedBox(height: 20),
        buildHealthCategorySection(context),
        SizedBox(height: 20),
        buildOffersSection(),
        SizedBox(height: 20),
        buildDiscountCarousel(),
      ],
    );
  }
}
