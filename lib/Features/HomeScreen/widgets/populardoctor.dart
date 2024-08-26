import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Doctor/view/doctor_profile.dart';
import 'package:hamo_pharmacy/core/valuenotifire.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PopularDoctorsSection extends StatelessWidget {
  Stream<List<DocumentSnapshot>> _fetchPopularDoctors(
      FirebaseFirestore firestore) {
    return firestore
        .collection('reviews')
        .where('rating', isGreaterThanOrEqualTo: 3)
        .snapshots()
        .asyncMap((reviewsSnapshot) async {
      Set doctorIds =
          reviewsSnapshot.docs.map((doc) => doc['doctorId']).toSet();
      List<DocumentSnapshot> popularDoctors = [];

      for (var doctorId in doctorIds) {
        DocumentSnapshot doctorSnapshot =
            await firestore.collection('doctors').doc(doctorId).get();
        popularDoctors.add(doctorSnapshot);
      }

      return popularDoctors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _fetchPopularDoctors(firestore),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('لا يوجد أطباء مشهورين حالياً'));
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final doctor = snapshot.data![index];
              final doctorId = doctor.id;

              return Consumer<FavoritesNotifier>(
                builder: (context, notifier, _) {
                  final isFavorite = notifier.isFavorite(doctorId);

                  return _buildDoctorCard(
                      context, doctor, isFavorite, notifier);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, DocumentSnapshot doctor,
      bool isFavorite, FavoritesNotifier notifier) {
    final doctorId = doctor.id;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfilePage(doctor: doctor),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 240,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      doctor['imageUrl'],
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorite
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: isFavorite ? Colors.red : Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        notifier.toggleFavorite(doctorId);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                doctor['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                doctor['specialty'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${doctor['consultationFee']} جنيه',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: Container(
                width: 240,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 20,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 14,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
