import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/Model/medecinmodel.dart'; // استيراد الـ models
import 'package:hamo_pharmacy/Features/HomeScreen/views/medecindetails.dart'; // استيراد الـ models

class CartPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _removeFromCart(String docId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('cart').doc(docId).delete();
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
                    return ListTile(
                      title: Text(data['name']),
                      leading: Image.network(data['imageUrl']),
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
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeFromCart(docs[index].id),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
