import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamo_pharmacy/Features/Appointment/Appointmentdetailspage.dart';

class UserAppointmentsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواعيدي'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: _auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data?.docs;

          if (appointments == null || appointments.isEmpty) {
            return Center(
              child: Text(
                'ليس لديك مواعيد.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final doctorId = appointment['doctorId'];
              final name = appointment['name'];
              final address = appointment['address'];
              final phone = appointment['phone'];
              final condition = appointment['condition'];
              final appointmentStart =
                  (appointment['appointmentStart'] as Timestamp).toDate();
              final appointmentEnd =
                  (appointment['appointmentEnd'] as Timestamp).toDate();
              final status = appointment['status'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('الاسم: $name', style: TextStyle(fontSize: 14)),
                      Text('العنوان: $address', style: TextStyle(fontSize: 14)),
                      Text('الهاتف: $phone', style: TextStyle(fontSize: 14)),
                      Text('الحالة: $condition',
                          style: TextStyle(fontSize: 14)),
                      Text('بداية: ${appointmentStart.toLocal()}',
                          style: TextStyle(fontSize: 14)),
                      Text('نهاية: ${appointmentEnd.toLocal()}',
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text(
                        'الحالة: $status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: status == 'Booked' ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailPage(
                          appointment: appointment,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
