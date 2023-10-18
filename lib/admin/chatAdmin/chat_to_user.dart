import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/main.dart';

class ChatToUser extends StatefulWidget {
  final String receiverUserID;
  const ChatToUser({super.key, required this.receiverUserID});

  @override
  State<ChatToUser> createState() => _ChatToUserState();
}

class _ChatToUserState extends State<ChatToUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แชทกับ${widget.receiverUserID}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Chat_Rooms")
          .doc('${widget.receiverUserID}_$senderEmail')
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('กำลังโหลดข้อมูล');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderEmail'] == senderEmail)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderEmail'] == senderEmail)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderEmail'] == senderEmail)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'],
              style: Textstyle().text18,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (data['senderEmail'] == senderEmail)
                      ? Colors.blue.shade300
                      : Colors.grey.shade300),
              child: Text(
                data['message'],
                style: Textstyle().text16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _messageController = TextEditingController();
  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
              child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: 'พิมพ์ข้อความ...',
                    hintStyle: TextStyle(color: Colors.blueAccent),
                    border: InputBorder.none),
              ),
            ),
          )),
          IconButton(
              onPressed: sendMessage, icon: const Icon(Icons.send_rounded)),
        ],
      ),
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Timestamp timestamp = Timestamp.now();
  final senderEmail = FirebaseAuth.instance.currentUser!.email;

  sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection("Chat_Rooms")
          .doc('${widget.receiverUserID}_$senderEmail')
          .collection('messages')
          .add({
        'senderEmail': senderEmail,
        'receiverId': widget.receiverUserID,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    _messageController.clear();
  }
}
