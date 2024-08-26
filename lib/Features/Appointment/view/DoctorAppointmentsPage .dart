import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentsPage extends StatelessWidget {
  final String doctorId;

  DoctorAppointmentsPage({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المواعيد'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data?.docs;

          if (appointments == null || appointments.isEmpty) {
            return Center(
              child: Text('لا توجد مواعيد حتى الآن.'),
            );
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text('المريض: ${appointment['name']}'),
                subtitle: Text(
                    'التاريخ: ${appointment['appointmentStart'].toDate()}'),
                trailing: Text(appointment['status']),
              );
            },
          );
        },
      ),
    );
  }
}
