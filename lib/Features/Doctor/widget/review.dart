import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

Widget buildReviewsSection({required String doctor}) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('reviews')
        .where('doctorId', isEqualTo: doctor)
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        print(
            'Error fetching reviews: ${snapshot.error}'); // طباعة الخطأ إذا حدث
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        print('No reviews found for this doctor'); // طباعة إذا لم توجد تقييمات
        return Text('لا توجد تقييمات لهذا الطبيب بعد.');
      }

      final reviews = snapshot.data!.docs;
      print('Number of reviews: ${reviews.length}'); // طباعة عدد التقييمات

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return buildReviewCard(review);
        },
      );
    },
  );
}

Widget buildReviewCard(DocumentSnapshot review) {
  try {
    print('Review Card Data: ${review.data()}'); // طباعة بيانات الكارد للتأكد
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(review['userImageUrl']),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['userName'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  RatingBarIndicator(
                    rating: review['rating'],
                    itemBuilder: (context, index) => Icon(
                      FontAwesomeIcons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                  ),
                  SizedBox(height: 10),
                  Text(review['review']),
                  SizedBox(height: 10),
                  Text(
                    DateFormat.yMMMd().format(
                      (review['timestamp'] as Timestamp).toDate(),
                    ),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } catch (e) {
    return SizedBox.shrink();
  }
}
