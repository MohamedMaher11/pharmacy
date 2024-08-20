import 'package:flutter/material.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/Features/DetailsPage/medecindetails.dart'; // استيراد الـ models

class MedicinePage extends StatefulWidget {
  final Category category;

  MedicinePage({required this.category});

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // تصفية الأدوية بناءً على استعلام البحث
    final filteredMedicines = widget.category.medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          '${widget.category.name} ',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: filteredMedicines.map((medicine) {
            return _buildMedicineCard(context, medicine);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (query) {
        setState(() {
          _searchQuery = query; // تحديث استعلام البحث
        });
      },
      decoration: InputDecoration(
        hintText: 'البحث عن علاج .... ', // نص التلميح
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

  Widget _buildMedicineCard(BuildContext context, Medicine medicine) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineDetailPage(medicine: medicine),
          ),
        );
      },
      child: Hero(
        tag: 'medicine-${medicine.name}',
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(medicine.imageUrl, height: 80),
              SizedBox(height: 8),
              Text(medicine.name, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
