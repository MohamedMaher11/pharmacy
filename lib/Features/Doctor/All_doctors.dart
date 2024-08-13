import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/Features/Doctor/doctor_profile.dart';

// صفحة عرض جميع الأطباء بناءً على التخصص
class AllDoctorsPage extends StatefulWidget {
  final String specialty;
  AllDoctorsPage({required this.specialty});

  @override
  _AllDoctorsPageState createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.specialty} Doctors'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(), // شريط البحث
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('doctors') // جمع الأطباء من Firestore
                    .where('specialty', isEqualTo: widget.specialty)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator()); // مؤشر التحميل
                  }

                  final doctors = snapshot.data!.docs.where((doc) {
                    final doctorName = doc['name'].toString().toLowerCase();
                    return doctorName.contains(_searchQuery
                        .toLowerCase()); // تصفية الأطباء بناءً على البحث
                  }).toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return _buildDoctorCard(context, doctor); // بطاقة الطبيب
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة بناء شريط البحث
  Widget _buildSearchBar() {
    return TextField(
      onChanged: (query) {
        setState(() {
          _searchQuery = query; // تحديث استعلام البحث
        });
      },
      decoration: InputDecoration(
        hintText: 'البحث عن دكتور .... ', // نص التلميح
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

  // دالة بناء بطاقة الطبيب
  Widget _buildDoctorCard(BuildContext context, DocumentSnapshot doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfilePage(doctor: doctor),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(doctor['imageUrl']),
            ),
            SizedBox(height: 10),
            Text(
              doctor['name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              doctor['specialty'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
