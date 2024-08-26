import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Doctor/view/All_doctors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/core/functions.dart';

class SpecialtiesPage extends StatefulWidget {
  @override
  _SpecialtiesPageState createState() => _SpecialtiesPageState();
}

class _SpecialtiesPageState extends State<SpecialtiesPage> {
  final List<Map<String, dynamic>> _specialties = [
    {
      'name': 'طب الأطفال',
      'icon': FontAwesomeIcons.child,
      'color': const Color.fromARGB(255, 130, 81, 214),
    },
    {
      'name': 'الطب الباطني',
      'icon': FontAwesomeIcons.hospital,
      'color': const Color.fromARGB(255, 130, 81, 214),
    },
    {
      'name': 'أمراض النساء',
      'icon': FontAwesomeIcons.female,
      'color': const Color.fromARGB(255, 130, 81, 214),
    },
    {
      'name': 'أمراض القلب',
      'icon': FontAwesomeIcons.heart,
      'color': const Color.fromARGB(255, 130, 81, 214),
    },
    {
      'name': 'أمراض الجلدية',
      'icon': FontAwesomeIcons.spa,
      'color': const Color.fromARGB(255, 130, 81, 214),
    },
    {
      'name': 'أمراض الأعصاب',
      'icon': FontAwesomeIcons.brain,
      'color': const Color.fromARGB(255, 130, 81, 214),
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التخصصات',
          style: fontcolor(),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: _filteredSpecialties.length,
                itemBuilder: (context, index) {
                  return _buildSpecialtyCard(
                      context, _filteredSpecialties[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredSpecialties {
    if (_searchQuery.isEmpty) {
      return _specialties;
    }
    return _specialties
        .where((specialty) => specialty['name']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
        });
      },
      decoration: InputDecoration(
        hintText: 'ابحث عن تخصص...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildSpecialtyCard(
      BuildContext context, Map<String, dynamic> specialty) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllDoctorsPage(specialty: specialty['name']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [specialty['color'].withOpacity(0.8), specialty['color']],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              specialty['icon'],
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              specialty['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
