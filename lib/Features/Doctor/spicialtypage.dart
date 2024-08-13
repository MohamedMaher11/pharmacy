import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Doctor/All_doctors.dart';

class SpecialtiesPage extends StatefulWidget {
  @override
  _SpecialtiesPageState createState() => _SpecialtiesPageState();
}

class _SpecialtiesPageState extends State<SpecialtiesPage> {
  final List<String> _specialties = [
    'طب الأطفال',
    'الطب الباطني',
    'أمراض النساء',
    'أمراض القلب',
    'أمراض الجلدية',
    'أمراض الأعصاب',
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التخصصات'),
        backgroundColor: Colors.orange,
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

  List<String> get _filteredSpecialties {
    if (_searchQuery.isEmpty) {
      return _specialties;
    }
    return _specialties
        .where((specialty) =>
            specialty.toLowerCase().contains(_searchQuery.toLowerCase()))
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

  Widget _buildSpecialtyCard(BuildContext context, String specialty) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllDoctorsPage(specialty: specialty),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            specialty,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
