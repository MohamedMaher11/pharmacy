import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamo_pharmacy/Features/Appointment/UserAppointmentsPage%20.dart';

class DoctorProfilePage extends StatelessWidget {
  final DocumentSnapshot doctor;

  DoctorProfilePage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor['name']),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(doctor['imageUrl']),
              backgroundColor: Colors.orangeAccent,
            ),
            SizedBox(height: 20),
            Text(
              doctor['name'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              doctor['specialty'],
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      Icons.location_on, 'العنوان: ${doctor['address']}'),
                  SizedBox(height: 10),
                  _buildInfoRow(Icons.phone, 'الهاتف: ${doctor['phone']}'),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                showAppointmentSheet(context, doctor.id);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'احجز موعد',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            info,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void showAppointmentSheet(BuildContext context, String doctorId) {
    final _nameController = TextEditingController();
    final _addressController = TextEditingController();
    final _phoneController = TextEditingController();
    final _conditionController = TextEditingController();
    DateTime? _selectedDate;
    TimeOfDay? _selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'احجز موعد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildTextField(_nameController, 'الاسم'),
                SizedBox(height: 16),
                _buildTextField(_addressController, 'العنوان'),
                SizedBox(height: 16),
                _buildTextField(_phoneController, 'رقم الهاتف'),
                SizedBox(height: 16),
                _buildTextField(_conditionController, 'الحالة'),
                SizedBox(height: 16),
                _buildDatePicker(context, _selectedDate, (date) {
                  _selectedDate = date;
                }),
                SizedBox(height: 16),
                _buildTimePicker(context, _selectedTime, (time) {
                  _selectedTime = time;
                }),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _addressController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _conditionController.text.isEmpty ||
                        _selectedDate == null ||
                        _selectedTime == null) {
                      showAlertDialog(
                        context,
                        'يرجى ملء جميع الحقول',
                        isError: true,
                      );
                      return;
                    }

                    final appointmentStart = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    );

                    final appointmentEnd =
                        appointmentStart.add(Duration(minutes: 30));

                    final conflictingAppointments = await FirebaseFirestore
                        .instance
                        .collection('appointments')
                        .where('doctorId', isEqualTo: doctorId)
                        .where('appointmentStart', isLessThan: appointmentEnd)
                        .where('appointmentEnd',
                            isGreaterThan: appointmentStart)
                        .get();

                    if (conflictingAppointments.docs.isNotEmpty) {
                      showAlertDialog(
                        context,
                        'هذا الوقت محجوز بالفعل. يرجى اختيار وقت آخر.',
                        isError: true,
                      );
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('appointments')
                          .add({
                        'userId': FirebaseAuth.instance.currentUser?.uid,
                        'doctorId': doctorId,
                        'name': _nameController.text,
                        'address': _addressController.text,
                        'phone': _phoneController.text,
                        'condition': _conditionController.text,
                        'appointmentStart': appointmentStart,
                        'appointmentEnd': appointmentEnd,
                        'status': 'محجوز',
                      });
                      print('تم حجز الموعد بنجاح!');
                      print('تم حجز الموعد بنجاح!'); // للتأكد من الوصول إلى هنا
                      showAlertDialog(
                        context,
                        'تم حجز الموعد بنجاح!',
                        isSuccess: true,
                      );
                      Navigator.of(context)
                          .pushReplacementNamed('/user_appointment');
                    } catch (e) {
                      print(e); // لطباعة الخطأ في حالة حدوثه
                      showAlertDialog(
                        context,
                        'فشل في حجز الموعد. يرجى المحاولة مرة أخرى.',
                        isError: true,
                      );
                    }
                  },
                  child: Text('احجز موعد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message,
      {bool isError = false, bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isSuccess
              ? Colors.green[50]
              : isError
                  ? Colors.red[50]
                  : Colors.white,
          title: Icon(
            isSuccess
                ? Icons.check_circle_outline
                : isError
                    ? Icons.error_outline
                    : Icons.info_outline,
            color: isSuccess
                ? Colors.green
                : isError
                    ? Colors.red
                    : Colors.blue,
            size: 50,
          ),
          content: Text(
            message,
            style: TextStyle(
              color: isSuccess
                  ? Colors.green[800]
                  : isError
                      ? Colors.red[800]
                      : Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'تم',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, DateTime? selectedDate,
      Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != selectedDate) {
          onDateSelected(picked);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'تاريخ الموعد',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: selectedDate != null
                ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                : '',
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, TimeOfDay? selectedTime,
      Function(TimeOfDay) onTimeSelected) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null && picked != selectedTime) {
          onTimeSelected(picked);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'وقت الموعد',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Icon(Icons.access_time),
          ),
          controller: TextEditingController(
            text: selectedTime != null ? '${selectedTime.format(context)}' : '',
          ),
        ),
      ),
    );
  }
}
