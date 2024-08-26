// lib/widgets/notifications_overlay.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamo_pharmacy/Features/Appointment/view/Appointmentdetailspage.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsOverlay extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final Function() onNotificationTap;

  NotificationsOverlay({
    required this.auth,
    required this.firestore,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        elevation: 5,
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('appointments')
                    .where('doctorId', isEqualTo: user?.uid)
                    .orderBy('appointmentStart', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final appointments = snapshot.data!.docs;

                  if (appointments.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: Text('لا يوجد إشعارات',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey))),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: appointments.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      final data = appointment.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return SizedBox.shrink();
                      }

                      final appointmentTimestamp =
                          data['appointmentStart'] as Timestamp?;
                      final appointmentTime = appointmentTimestamp?.toDate();
                      final formattedTime = appointmentTime != null
                          ? DateFormat('yyyy-MM-dd – kk:mm')
                              .format(appointmentTime)
                          : 'غير متاح';

                      final isRead = data['isRead'] as bool? ?? false;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          tileColor: isRead ? Colors.grey[200] : Colors.white,
                          leading: CircleAvatar(
                            backgroundColor:
                                isRead ? Colors.grey[300] : Colors.blue,
                            child: Icon(
                              isRead
                                  ? FontAwesomeIcons.solidBell
                                  : FontAwesomeIcons.bell,
                              color: isRead ? Colors.grey : Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            'موعد مع ${data['name']}',
                            style: TextStyle(
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.bold,
                              color: isRead ? Colors.black : Colors.blue,
                            ),
                          ),
                          subtitle: Text(
                            'الوقت: $formattedTime',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          onTap: () {
                            appointment.reference.update({'isRead': true});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentDetailPage(
                                  appointment:
                                      appointment, // تأكد من أن هذه القيمة صحيحة
                                ),
                              ),
                            ); // Notify the parent widget
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final batch = firestore.batch();
                  final user = auth.currentUser;

                  if (user != null) {
                    final querySnapshot = await firestore
                        .collection('appointments')
                        .where('doctorId', isEqualTo: user.uid)
                        .where('isRead', isEqualTo: false)
                        .get();

                    for (var doc in querySnapshot.docs) {
                      batch.update(doc.reference, {'isRead': true});
                    }

                    await batch.commit();
                  }
                },
                child: Text('اجعل الكل مقروءه'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
