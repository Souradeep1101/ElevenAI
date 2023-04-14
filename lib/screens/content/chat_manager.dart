import 'package:eleven_ai/screens/content/chat.dart';
import 'package:eleven_ai/screens/content/create_chat.dart';
import 'package:eleven_ai/widgets/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ChatManager extends StatefulWidget {
  const ChatManager({Key? key}) : super(key: key);

  @override
  State<ChatManager> createState() => _ChatManagerState();
}

class _ChatManagerState extends State<ChatManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Chats',
                style: GoogleFonts.nunitoSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref('chats/${FirebaseAuth.instance.currentUser!.uid}/')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.exclamationCircle,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text('An error occurred while retrieving data.',
                                style: Theme.of(context).textTheme.headline4),
                          ],
                        ),
                      );
                    }
                    if (snapshot.data?.snapshot.value == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Conversations Yet?',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Click on the button to start a conversation.',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return FirebaseAnimatedList(
                        query: FirebaseDatabase.instance.ref(
                            'chats/${FirebaseAuth.instance.currentUser!.uid}/'),
                        sort: (a, b) {
                          return b.key!.compareTo(a.key!);
                        },
                        itemBuilder: (context, snapshot, animation, index) {
                          dynamic value = snapshot.value;
                          return ChatTile(
                            title: value['chat_title'],
                            chatKey: snapshot.key,
                            animation: animation,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chat(
                                    chatPath:
                                        'chats/${FirebaseAuth.instance.currentUser!.uid}/${snapshot.key}/chat_message/',
                                    title: value['chat_title'],
                                    chatKey: snapshot.key,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateChat(),
            ),
          );
        },
        child: const Icon(LineIcons.plus),
      ),
    );
  }
}
