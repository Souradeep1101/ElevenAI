import 'package:eleven_ai/core/firebase/database/database.dart';
import 'package:eleven_ai/screens/content/chat.dart';
import 'package:eleven_ai/widgets/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({Key? key}) : super(key: key);

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  final TextEditingController chatTitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DatabaseReference? chatParentData;
  dynamic chatChildData;
  bool _isLoading = false;

  @override
  void dispose() {
    chatTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Chat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: chatTitle,
                  decoration: const InputDecoration(
                    labelText: 'Chat Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a chat title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: CustomElevatedButton(
                      isLoading: _isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          chatParentData = await Database().writeData(
                            databaseReference: FirebaseDatabase.instance,
                            path:
                                'chats/${FirebaseAuth.instance.currentUser!.uid}/',
                            data: {
                              'chat_title': chatTitle.text.trim(),
                            },
                            overwriteData: false,
                            pushData: true,
                            context: context,
                          );
                          chatChildData = await Database().writeData(
                            databaseReference: FirebaseDatabase.instance,
                            path:
                                'chats/${FirebaseAuth.instance.currentUser!.uid}/${chatParentData?.key}/chat_message/',
                            data: {
                              'role': 'system',
                              'content':
                                  'Your name is Eleven and you are a helpful assistant.',
                            },
                            overwriteData: false,
                            pushData: true,
                            context: context,
                          );
                          if (chatParentData != null && chatChildData != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chat(
                                  chatPath:
                                      'chats/${FirebaseAuth.instance.currentUser!.uid}/${chatParentData?.key}/chat_message',
                                  title: chatTitle.text.trim(),
                                  chatKey: chatParentData?.key,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      text: 'Create Chat',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
