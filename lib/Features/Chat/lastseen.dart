import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamo_pharmacy/Features/Chat/chat.dart';

class LastSeenPage extends StatefulWidget {
  @override
  _LastSeenPageState createState() => _LastSeenPageState();
}

class _LastSeenPageState extends State<LastSeenPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  Future<DocumentSnapshot> _getUserData(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      userDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();
    }

    return userDoc;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('آخر الرسائل'),
        backgroundColor: Colors.deepPurple, // لون الـ AppBar جديد
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: _currentUser!.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages found.'));
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
              height: 1,
            ),
            itemBuilder: (context, index) {
              final chatRoom = snapshot.data!.docs[index];
              final lastMessage = chatRoom['lastMessage'] ?? 'No message';
              final lastMessageTime =
                  chatRoom['lastMessageTime']?.toDate() ?? DateTime.now();
              final otherParticipantId = chatRoom['participants'].firstWhere(
                (id) => id != _currentUser!.uid,
              );

              return FutureBuilder<DocumentSnapshot>(
                future: _getUserData(otherParticipantId),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Loading...'),
                    );
                  }

                  final user = userSnapshot.data;
                  final userName = user!['name'] ?? 'Unknown';
                  final userImageUrl = user['imageUrl'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userImageUrl ?? ''),
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple, // لون النص
                      ),
                    ),
                    subtitle: Text(lastMessage),
                    trailing: Text(
                      '${lastMessageTime.hour}:${lastMessageTime.minute}',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(doctor: userSnapshot.data!),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
