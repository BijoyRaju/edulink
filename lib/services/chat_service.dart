// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class ChatService {
//   final StreamChatClient client;
//   ChatService(this.client);

//   Future<Channel> createOrJoinChannel(String channelId,{String? name})async{
//     final channel = client.channel(
//       'messaging',
//       id: channelId,
//       extraData: {
//         'name' : name ?? channelId
//       }
//     );
//     await channel.watch();
//     return channel;
//   }

//   StreamChatClient getClient(){
//     return client;
//   }
// }