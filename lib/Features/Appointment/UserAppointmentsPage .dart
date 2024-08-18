import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Appointment/Appointmentdetailspage.dart';
import 'package:intl/intl.dart'; // لإضافة تنسيق التاريخ والوقت

class UserAppointmentsPage extends StatefulWidget {
  @override
  _UserAppointmentsPageState createState() => _UserAppointmentsPageState();
}

class _UserAppointmentsPageState extends State<UserAppointmentsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // الآن يحتوي على تابين فقط
      child: Scaffold(
        appBar: AppBar(
          title: Text('مواعيدي'),
          backgroundColor: Colors.purple,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'النشطة'),
              Tab(text: 'المكتملة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAppointmentsTab('Booked'),
            _buildCompletedAppointmentsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'لا توجد مواعيد ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        final appointments = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];

            // نقل المواعيد المكتملة تلقائيًا
            final appointmentEnd =
                (appointment['appointmentEnd'] as Timestamp).toDate();
            if (appointmentEnd.isBefore(DateTime.now()) &&
                appointment['status'] == 'Booked') {
              FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(appointment.id)
                  .update({'status': 'Completed'});
              return SizedBox(); // حذف العنصر من القائمة النشطة
            }

            return _buildAppointmentCard(appointment, status);
          },
        );
      },
    );
  }

  Widget _buildCompletedAppointmentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .where('status', isEqualTo: 'Completed') // عرض المكتملة فقط
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'لا توجد مواعيد .',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        final appointments = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCard(appointment, 'Completed');
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(
      QueryDocumentSnapshot appointment, String status) {
    final doctorId = appointment['doctorId'];
    final name = appointment['name'];
    final address = appointment['address'];
    final phone = appointment['phone'];
    final condition = appointment['condition'];
    final appointmentStart =
        (appointment['appointmentStart'] as Timestamp).toDate();
    final appointmentEnd =
        (appointment['appointmentEnd'] as Timestamp).toDate();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
        ),
        title: Text(
          'الاسم: $name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('العنوان: $address', style: TextStyle(fontSize: 14)),
            Text('الهاتف: $phone', style: TextStyle(fontSize: 14)),
            Text('الحالة: $condition', style: TextStyle(fontSize: 14)),
            Text('بداية: ${DateFormat.jm().format(appointmentStart)}',
                style: TextStyle(fontSize: 14)),
            Text('نهاية: ${DateFormat.jm().format(appointmentEnd)}',
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.remove, color: Colors.red),
              onPressed: () {
                if (status == 'Completed') {
                  _confirmDeleteAppointment(context, appointment.id);
                } else {
                  _deleteAppointment(context, appointment.id);
                }
              },
            ),
          ],
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
  }

  void _deleteAppointment(BuildContext context, String appointmentId) {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف الموعد بنجاح')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الحذف: $error')),
      );
    });
  }

  void _confirmDeleteAppointment(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل تريد حذف هذا الموعد نهائيًا؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(appointmentId)
                  .delete()
                  .then((_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف الموعد بنجاح')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('حدث خطأ أثناء الحذف: $error')),
                );
              });
            },
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }
}
