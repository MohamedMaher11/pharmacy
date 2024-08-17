import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  final DocumentSnapshot doctor;

  ChatScreen({required this.doctor});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;
  late String _chatRoomId;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _chatRoomId = _getChatRoomId();
  }

  String _getChatRoomId() {
    final userId = _currentUser?.uid;
    final doctorId = widget.doctor.id;
    return userId!.compareTo(doctorId) > 0
        ? '$userId\_$doctorId'
        : '$doctorId\_$userId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.doctor['imageUrl'] ?? ''),
            ),
            SizedBox(width: 8),
            Text(widget.doctor['name'], style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.deepPurple, // لون الـ AppBar جديد
      ),
      body: Stack(
        children: [
          // خلفية متدرجة بألوان مودرن
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.blue.shade100, // لون أزرق فاتح
                Colors.purple.shade100, // لون أرجواني فاتح
                Colors.pink.shade100, // لون وردي فاتح
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.2, 0.8],
            )),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(_chatRoomId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data!.docs[index];
                        final isMe = message['senderId'] == _currentUser!.uid;
                        return _buildMessageBubble(message['text'], isMe);
                      },
                    );
                  },
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          decoration: BoxDecoration(
            color: isMe
                ? Colors
                    .deepPurple // الرسائل بتاعة المستخدم باللون الأرجواني الغامق
                : Colors.purple
                    .shade50, // الرسائل بتاعة الدكتور باللون الأرجواني الفاتح
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك...',
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.deepPurple),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final message = _messageController.text.trim();
    final timestamp = Timestamp.now();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatRoomId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': _currentUser!.uid,
      'receiverId': widget.doctor.id,
      'timestamp': timestamp,
    });

    FirebaseFirestore.instance.collection('chats').doc(_chatRoomId).set({
      'participants': [_currentUser!.uid, widget.doctor.id],
      'lastMessage': message,
      'lastMessageTime': timestamp,
    });

    _messageController.clear();
  }
}
