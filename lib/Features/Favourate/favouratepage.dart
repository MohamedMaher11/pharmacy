import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/DetailsPage/medecindetails.dart';
import 'package:hamo_pharmacy/Features/Model/medecinmodel.dart'; // استيراد الـ models

class FavoritesPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _removeFromFavorites(BuildContext context, String docId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('favorites').doc(docId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item removed from favorites')),
        );
      } catch (e) {
        print('Failed to remove from favorites: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('favorites')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text('Your favorites list is empty'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    icon: Icon(FontAwesomeIcons.trashAlt, color: Colors.red),
                    onPressed: () =>
                        _removeFromFavorites(context, docs[index].id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
