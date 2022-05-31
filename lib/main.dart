import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = StreamChatClient(
    '454yk64xnhgj',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(id: 'user01'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidXNlcl9pZCI6InVzZXIwMSIsImlhdCI6MTUxNjIzOTAyMn0.vJDidNX4tPIDSEMqXTNxVBT-7-lN8sMROcIiPDcR9Tc',
  );

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: const ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
          filter: Filter.in_(
            'members',
            [StreamChat.of(context).currentUser!.id],
          ),
          sort: const [SortOption('last_message_at')],
          limit: 20,
          channelWidget:  ChannelPage(),
        ),
      ),
    );
  }
}


class ChannelPage extends StatefulWidget {

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  Message? quotedMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              // ...
              onMessageSwiped: (message) {
                setState(() {
                  quotedMessage = message;
                });
              },
            ),
          ),
          MessageInput(
            actions: [
              InkWell(
                child: Icon(
                  Icons.location_on,
                  size: 20.0,
                  color: StreamChatTheme.of(context).colorTheme.accentPrimary,
                ),
                onTap: () {
                  // Do something here
                  print("clickedincon");

                },
              ),
            ],
            quotedMessage: quotedMessage,
            disableAttachments: true,
            onQuotedMessageCleared: () {
              setState(() => quotedMessage = null);
            },
          ),
        ],
      ),
    );
  }
}