import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runnn/admin/chatAdmin/chat_to_user.dart';

class AllChat extends StatefulWidget {
  const AllChat({Key? key}); // Fixed the constructor parameter.

  @override
  State<AllChat> createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Chat'),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("กำลังโหลดข้อมูล");
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      return _Chat(data['email'], data['email']);
    } else {
      return Container();
    }
  }

  Widget _Chat(String userEmail, String receiverUserId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Chat_Rooms')
          .doc('${userEmail}_admin@gmail.com')
          .collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("กำลังโหลดข้อมูล");
        }
        final datachat = snapshot.data?.docs;

        // Assuming that there is only one message for this user in the collection.
        if (datachat != null && datachat.isNotEmpty) {
          final lastMessage = datachat.last.data() as Map<String, dynamic>;
          final message = lastMessage['message'] as String?;

          return ListTile(
            title: Text(userEmail), // Display the user's email
            subtitle:
                Text(message ?? 'No message available'), // Handle null message
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatToUser(
                    receiverUserID: receiverUserId,
                  ),
                ),
              );
            },
          );
        } else {
          // Handle the case where there are no messages.
          return ListTile(
            title: Text(userEmail), // Display the user's email.
            subtitle: const Text("No messages"),
          );
        }
      },
    );
  }
}
