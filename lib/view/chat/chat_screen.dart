import 'package:edu_link/view/chat/channel_page.dart';
import 'package:edu_link/view/chat/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:stream_chat_flutter/stream_chat_flutter.dart' show Filter, StreamChannelListController, StreamChat, SortOption, StreamChannelListView, StreamChannel;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  StreamChannelListController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final client = StreamChat.of(context).client;
      final user = StreamChat.of(context).currentUser;
      if (user != null) {
        _controller = StreamChannelListController(
          client: client,
          filter: Filter.in_('members', [user.id]), 
          channelStateSort: const [SortOption('last_message_at')],
          limit: 30,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Fetch all Firebase users
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view chats')),
      );
    }

    final currentUser = StreamChat.of(context).currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UsersListScreen(currentUserId: currentUser.id)));
      },child: Icon(Icons.chat_bubble),),
      body: RefreshIndicator(
        onRefresh: _controller!.refresh,
        child: StreamChannelListView(
          controller: _controller!,
          onChannelTap: (channel) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                ),
              ),
            );
          },
          emptyBuilder: (context) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Let's start chatting!"),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text("New Chat"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UsersListScreen(currentUserId: currentUser.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
