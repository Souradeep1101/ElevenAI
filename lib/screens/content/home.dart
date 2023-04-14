import 'package:eleven_ai/screens/content/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eleven_ai/models/data/home_topic_data.dart';
import 'package:line_icons/line_icons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Explore Topics',
                style: GoogleFonts.nunitoSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: homeTopics.length,
                itemBuilder: (context, index) {
                  final topic = homeTopics[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: Icon(
                          topic.icon,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          topic.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        subtitle: Text(
                          topic.subtitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        trailing: Icon(
                          LineIcons.arrowRight,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                chatPath:
                                    'topics/${homeTopics[index].databaseTitle}/${FirebaseAuth.instance.currentUser!.uid}',
                                title: homeTopics[index].title,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
