import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/view/chat/channel_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UsersListScreen extends StatelessWidget {
  final String currentUserId;
  const UsersListScreen({Key? key, required this.currentUserId}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;

    return Scaffold(
      appBar: AppBar(title: const Text("Select User")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!
              .where((u) => u['uid'] != currentUserId) // exclude current user
              .toList();

          if (users.isEmpty) return const Center(child: Text("No users found"));

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['photoURL'] ?? ''),
                ),
                title: Text(user['name'] ?? 'User'),
                onTap: () async {
                  try {
                    final otherUserId = user['uid'];

                    // ✅ No updateUser here
                    final channel = client.channel(
                      'messaging',
                      extraData: {
                        'members': [currentUserId, otherUserId],
                      },
                    );

                    await channel.watch();

                    if (!context.mounted) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StreamChannel(
                          channel: channel,
                          child: const ChannelPage(),
                        ),
                      ),
                    );
                  } catch (e) {
                    print("Error opening chat: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to open chat: $e")),
                    );
                  }
                }

              );
            },
          );
        },
      ),
    );
  }
}
