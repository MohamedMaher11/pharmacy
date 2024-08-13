import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot appointment;

  AppointmentDetailPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الموعد'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('doctors')
              .doc(doctorId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('معلومات الطبيب غير متوفرة.'));
            }

            final doctorData = snapshot.data!;
            final doctorName = doctorData['name'] ?? 'طبيب غير معروف';
            final doctorImageUrl = doctorData['imageUrl'] ?? '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: doctorImageUrl.isNotEmpty
                          ? NetworkImage(doctorImageUrl)
                          : null,
                      child: doctorImageUrl.isEmpty
                          ? Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      doctorName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildInfoCard(
                    icon: Icons.person,
                    label: 'اسم المريض',
                    value: name,
                  ),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    label: 'العنوان',
                    value: address,
                  ),
                  _buildInfoCard(
                    icon: Icons.phone,
                    label: 'رقم الهاتف',
                    value: phone,
                  ),
                  _buildInfoCard(
                    icon: Icons.health_and_safety,
                    label: 'الحالة',
                    value: condition,
                  ),
                  _buildInfoCard(
                    icon: Icons.access_time,
                    label: 'موعد البداية',
                    value: '${appointmentStart.toLocal()}',
                  ),
                  _buildInfoCard(
                    icon: Icons.access_time,
                    label: 'موعد النهاية',
                    value: '${appointmentEnd.toLocal()}',
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'الحالة: $status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: status == 'Booked' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      icon: Icon(Icons.delete),
                      label: Text('حذف الموعد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('رجوع'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required String label, required String value}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذا الموعد؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('appointments')
                    .doc(appointment.id)
                    .update({'status': 'Cancelled'}).then((_) {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Go back to the appointments list
                }).catchError((error) {
                  print('فشل في إلغاء الموعد: $error');
                });
              },
              child: Text('حذف', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}
