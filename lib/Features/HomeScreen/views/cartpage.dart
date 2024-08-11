import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/Model/medecinmodel.dart'; // استيراد الـ models
import 'package:hamo_pharmacy/Features/HomeScreen/views/medecindetails.dart'; // استيراد الـ models

class CartPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _removeFromCart(BuildContext context, String docId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('cart').doc(docId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item removed from cart')),
        );
      } catch (e) {
        print('Failed to remove from cart: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('cart')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }

          double totalPrice = 0;
          docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            totalPrice += (data['price'] as num).toDouble();
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(data['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        leading: Image.network(
                          data['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        subtitle: Text('\$${data['price'].toStringAsFixed(2)}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicineDetailPage(
                                medicine: Medicine(
                                  name: data['name'],
                                  imageUrl: data['imageUrl'],
                                  price: data['price'],
                                  description: data['description'],
                                ),
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(FontAwesomeIcons.trashAlt,
                              color: Colors.red),
                          onPressed: () =>
                              _removeFromCart(context, docs[index].id),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              SizedBox(
                  height: 16), // Add some space between total and the button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 340,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your buy functionality here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Proceed to checkout')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800], // Background color
                      padding:
                          EdgeInsets.symmetric(vertical: 15), // Button height
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Buy',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space at the bottom
            ],
          );
        },
      ),
    );
  }
}
