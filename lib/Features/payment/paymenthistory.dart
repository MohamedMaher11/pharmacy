import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Transaction History'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: Text('User not logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('history')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Dismissible(
                key: Key(docs[index].id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteTransaction(docs[index].id);
                },
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(data['item'] ?? 'No item'),
                    subtitle: Text(
                      'Amount: \$${(data['amount'] as num?)?.toStringAsFixed(2) ?? '0.00'}\nDate: ${DateFormat.yMMMd().add_jm().format((data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now())}',
                    ),
                    trailing: Text(
                      'Status: ${data['status'] ?? 'Unknown'}',
                      style: TextStyle(
                        color: (data['status'] ?? '') == 'Success'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    onTap: () => _showTransactionDetails(context, data),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('history').doc(transactionId).delete();
    } catch (e) {
      // Handle error - possibly show a message to the user
      print('Failed to delete transaction: $e');
    }
  }

  void _showTransactionDetails(
      BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Item: ${data['item'] ?? 'No item'}'),
            SizedBox(height: 8),
            Text(
                'Amount: \$${(data['amount'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
            SizedBox(height: 8),
            Text(
                'Date: ${DateFormat.yMMMd().add_jm().format((data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now())}'),
            SizedBox(height: 8),
            Text('Status: ${data['status'] ?? 'Unknown'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
