import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'doctorrestervationdetails.dart'; // تأكد من تحديث مسار الصفحة بشكل صحيح

class DoctorReservationsPage extends StatefulWidget {
  @override
  _DoctorReservationsPageState createState() => _DoctorReservationsPageState();
}

class _DoctorReservationsPageState extends State<DoctorReservationsPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حجوزاتي'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          _buildDatePicker(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('doctorId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('appointmentStart',
                      isGreaterThanOrEqualTo: _startOfDay(_selectedDate))
                  .where('appointmentEnd',
                      isLessThanOrEqualTo: _endOfDay(_selectedDate))
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('لا توجد حجوزات في هذا اليوم'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final appointment = snapshot.data!.docs[index];
                    return _buildReservationCard(context, appointment);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 0, 0, 0);
  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('اختر تاريخ:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selected != null) {
                  setState(() {
                    _selectedDate = selected;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(DateFormat.yMMMd().format(_selectedDate),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(
      BuildContext context, DocumentSnapshot appointment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ReservationDetailsPage(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المريض: ${appointment['name']}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            SizedBox(height: 5),
            Text(
              'من: ${DateFormat.jm().format(appointment['appointmentStart'].toDate())} '
              'إلى: ${DateFormat.jm().format(appointment['appointmentEnd'].toDate())}',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 5),
            Text('رقم الهاتف: ${appointment['phone']}',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
