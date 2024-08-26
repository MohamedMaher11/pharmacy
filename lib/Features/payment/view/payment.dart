import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this for loading spinner

class PaymentPage extends StatefulWidget {
  final double totalAmount;

  PaymentPage({required this.totalAmount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _currentStep = 0;
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _completePayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate payment processing

    setState(() {
      _isProcessing = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('نجحت العمليه '),
        content: Text('لقد تمت العمليه بنجاح'),
        actions: [
          TextButton(
            onPressed: () {
              _saveTransaction();

              Navigator.of(context).pushNamed('/transaction_history');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isProcessing
          ? Center(
              child: SpinKitFadingCircle(
                color: Colors.deepPurple,
                size: 50.0,
              ),
            )
          : Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: _currentStep == 0 ? _nextStep : _completePayment,
              onStepCancel: _currentStep == 0
                  ? null
                  : () {
                      setState(() {
                        _currentStep--;
                      });
                    },
              controlsBuilder: (context, ControlsDetails details) {
                return Row(
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: Text('Back'),
                      ),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Center(
                          child: Text(
                        _currentStep == 0 ? 'Next' : 'Complete Payment',
                        style: TextStyle(color: Colors.white),
                      )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ],
                );
              },
              steps: [
                Step(
                  title: Text(
                    'Details',
                  ),
                  content: _buildPaymentDetailsForm(),
                  isActive: _currentStep >= 0,
                  state: _currentStep == 0
                      ? StepState.editing
                      : StepState.complete,
                ),
                Step(
                  title: Text('Confirm'),
                  content: _buildConfirmPayment(),
                  isActive: _currentStep >= 1,
                  state: _currentStep == 1
                      ? StepState.editing
                      : StepState.complete,
                ),
              ],
            ),
    );
  }

  Widget _buildPaymentDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.credit_card),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 16) {
                return 'Enter a valid card number';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter expiry date';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Enter a valid CVV';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Card Holder Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter card holder name';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _saveTransaction() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle error - user not logged in
      return;
    }

    final transaction = {
      'userId': userId,
      'item': 'Purchase', // يمكنك تغيير الوصف بناءً على احتياجاتك
      'amount': widget.totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Success',
    };

    try {
      await FirebaseFirestore.instance.collection('history').add(transaction);
    } catch (e) {
      // Handle error - possibly show a message to the user
      print('Failed to add transaction: $e');
    }
  }

  Widget _buildConfirmPayment() {
    final cardNumber = _cardNumberController.text;
    final maskedCardNumber = cardNumber.length >= 4
        ? '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}'
        : '**** **** **** ${cardNumber.padLeft(4, '*')}'; // Handle short card numbers

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount to be paid:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '\$${widget.totalAmount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 24, color: Colors.green),
        ),
        SizedBox(height: 16),
        Text(
          'Card Number: $maskedCardNumber',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Expiry Date: ${_expiryDateController.text}',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Card Holder: ${_nameController.text}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
