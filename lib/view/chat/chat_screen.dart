import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StreamChannelListController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final client = StreamChat.of(context).client;
      _controller = StreamChannelListController(
        client: client,
        filter: Filter.in_('members', [client.state.currentUser!.id]),
        limit: 20,
      );
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamChannelListView(
        controller: _controller,
        onChannelTap: (channel) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamChannel(
                channel: channel,
                child: const _ChannelPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChannelPage extends StatelessWidget {
  const _ChannelPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: [
          Expanded(child: StreamMessageListView()),
          StreamMessageInput(),
        ],
      ),
    );
  }
}