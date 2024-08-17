import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:hamo_pharmacy/Features/Chat/chat.dart';
import 'package:hamo_pharmacy/Features/Chat/lastseen.dart';

class DoctorProfilePage extends StatefulWidget {
  final DocumentSnapshot doctor;

  DoctorProfilePage({required this.doctor});

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  DateTime? _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String?> _bookedTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _fetchBookedTimeSlots(widget.doctor.id, _selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor['name']),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 80,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(widget.doctor['imageUrl']),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 90),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 80), // للمحافظة على موقع النصوص بعد الصورة
                      Text(
                        widget.doctor['name'],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.doctor['specialty'],
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      _buildDoctorDetails(),
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(doctor: widget.doctor)),
                            );
                          },
                          child: Text('Chat')),

                      ElevatedButton(
                        onPressed: () {
                          showAppointmentSheet(context, widget.doctor.id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Book Appointment',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorDetails() {
    return Column(
      children: [
        _buildInfoRow(
            Icons.location_on, 'العنوان: ${widget.doctor['address']}'),
        SizedBox(height: 10),
        _buildInfoRow(Icons.phone, 'رقم التليفون: ${widget.doctor['phone']}'),
        SizedBox(height: 10),
        _buildInfoRow(Icons.school, 'التعليم: ${widget.doctor['education']}'),
        SizedBox(height: 10),
        _buildInfoRow(Icons.work, 'الخبرة: ${widget.doctor['experience']}'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                      'Book an Appointment',
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
                    _buildTextField(_phoneController, 'رقم التليفون'),
                    SizedBox(height: 16),
                    _buildTextField(_conditionController, 'وصف الحاله'),
                    SizedBox(height: 16),
                    _buildDatePicker(context, _selectedDate, (date) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTimeSlot = null;
                        _fetchBookedTimeSlots(doctorId, date);
                      });
                    }),
                    SizedBox(height: 16),
                    _buildTimeSlotGridView(
                        context, _selectedDate, _selectedTimeSlot, (slot) {
                      setState(() {
                        _selectedTimeSlot = slot;
                      });
                    }, 'Booked'),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _addressController.text.isEmpty ||
                            _phoneController.text.isEmpty ||
                            _conditionController.text.isEmpty ||
                            _selectedDate == null ||
                            _selectedTimeSlot == null) {
                          showAlertDialog(
                            context,
                            'من فضلك املأ البيانات',
                            isError: true,
                          );
                          return;
                        }

                        final appointmentStart = _getTimeFromSlot(
                            _selectedDate!, _selectedTimeSlot!);

                        final appointmentEnd =
                            appointmentStart.add(Duration(minutes: 30));

                        final conflictingAppointments = await FirebaseFirestore
                            .instance
                            .collection('appointments')
                            .where('doctorId', isEqualTo: doctorId)
                            .where('appointmentStart',
                                isLessThan: appointmentEnd)
                            .where('appointmentEnd',
                                isGreaterThan: appointmentStart)
                            .get();

                        if (conflictingAppointments.docs.isNotEmpty) {
                          showAlertDialog(
                            context,
                            'هذا الموعد تم حجزه مسبقا , من فضلك احجز موعد اخر',
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
                            'status': 'Booked',
                          });
                          showAlertDialog(
                            context,
                            'تم حجز الموعد بنجاح!',
                            isSuccess: true,
                          );
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushReplacementNamed('/user_appointment');
                          });
                        } catch (e) {
                          showAlertDialog(
                            context,
                            'خطأ في الحجز، يرجى المحاولة مرة أخرى',
                            isError: true,
                          );
                        }
                      },
                      child: Text(
                        'حجز موعد',
                        style: TextStyle(color: Colors.white),
                      ),
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
      },
    );
  }

  DateTime _getTimeFromSlot(DateTime date, String slot) {
    final parts = slot.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].split(' ')[0]);
    final isPm = parts[1].contains('PM');
    return DateTime(date.year, date.month, date.day,
        isPm && hour != 12 ? hour + 12 : hour, minute);
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          selectedDate != null
              ? '${DateFormat.yMMMd().format(selectedDate)}'
              : 'Select Date',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimeSlotGridView(
      BuildContext context,
      DateTime? selectedDate,
      String? selectedTimeSlot,
      Function(String) onTimeSlotSelected,
      String status) {
    final timeSlots = _generateTimeSlots();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        final isBooked = _bookedTimeSlots.contains(slot);
        final isSelected = selectedTimeSlot == slot;
        return GestureDetector(
          onTap: !isBooked ? () => onTimeSlotSelected(slot) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.grey
                  : isSelected
                      ? Colors.blue
                      : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  List<String> _generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 12; hour <= 17; hour++) {
      final formattedHour =
          hour == 12 ? '12' : (hour % 12).toString().padLeft(2, '0');
      slots.add('$formattedHour:00 PM');
      slots.add('$formattedHour:30 PM');
    }
    return slots;
  }

  void _fetchBookedTimeSlots(String doctorId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59);

    final appointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('appointmentStart', isGreaterThanOrEqualTo: startOfDay)
        .where('appointmentEnd', isLessThanOrEqualTo: endOfDay)
        .get();

    setState(() {
      _bookedTimeSlots = appointments.docs
          .map((doc) {
            final start = (doc['appointmentStart'] as Timestamp).toDate();
            final hour = start.hour == 12
                ? '12'
                : (start.hour % 12).toString().padLeft(2, '0');
            final minute = start.minute.toString().padLeft(2, '0');
            final period = start.hour >= 12 ? 'PM' : 'AM';

            return doc['status'] == 'Cancelled'
                ? null
                : '$hour:$minute $period';
          })
          .where((slot) => slot != null)
          .toList();
    });
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
                'OK',
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
}
