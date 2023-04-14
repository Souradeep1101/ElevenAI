import 'dart:typed_data';
import 'package:eleven_ai/controllers/custom_getx_controller.dart';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart' as get_x;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:eleven_ai/core/firebase/database/database.dart';
import 'package:eleven_ai/core/services/api/api.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eleven_ai/widgets/chat_message.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/foundation.dart' as foundation;

class Chat extends StatefulWidget {
  final String title;
  final String? chatKey;
  final String chatPath;
  final String? imagePath;
  final bool isImage;

  const Chat({
    Key? key,
    this.title = '',
    this.chatKey,
    this.chatPath = '',
    this.isImage = false,
    this.imagePath,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showEmoji = false;
  dynamic chatChildData;
  dynamic gptData;
  dynamic imageData;
  List<Map<String, dynamic>> data = [];
  late AnimationController animationController;
  late Animation<Color?> colorTween;
  bool isLoading = false;
  CustomGetXController customGetXController =
      get_x.Get.find<CustomGetXController>();

  void _handleChatSubmit({
    required String text,
    List? data,
    required String? apiKey,
  }) async {
    if (_formKey.currentState!.validate()) {
      _textController.clear();
      setState(() {
        isLoading = true;
      });
      chatChildData = await Database().writeData(
        databaseReference: FirebaseDatabase.instance,
        path: widget.chatPath,
        data: {
          'role': 'user',
          'content': text,
        },
        overwriteData: false,
        pushData: true,
        context: context,
      );
      gptData = await Api().generateText(
        messages: data,
        context: context,
        apiKey: apiKey,
      );
      setState(() {
        isLoading = false;
      });
      if (gptData != null) {
        chatChildData = await Database().writeData(
          databaseReference: FirebaseDatabase.instance,
          path: widget.chatPath,
          data: gptData,
          overwriteData: false,
          pushData: true,
          context: context,
        );
      }
    }
  }

  void _handleImageSubmit({
    required String text,
    required String? apiKey,
  }) async {
    _textController.clear();
    setState(() {
      isLoading = true;
    });
    chatChildData = await Database().writeData(
      databaseReference: FirebaseDatabase.instance,
      path: widget.imagePath!,
      data: {
        'role': 'user',
        'content': text,
      },
      overwriteData: false,
      pushData: true,
      context: context,
    );
    Map<String?, Response?>? data = await Api().generateImage(
      message: text,
      context: context,
      apiKey: apiKey,
    );
    var response = data?.values.first;
    if (response != null) {
      Uint8List imageBytes = response.bodyBytes;
      UploadTask uploadTask = FirebaseStorage.instance
          .ref(
              'ai_art/${FirebaseAuth.instance.currentUser!.uid}/${path.basename(data!.keys.first!)}.jpg')
          .putData(imageBytes);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      if (storageTaskSnapshot.state == TaskState.success) {
        String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
        imageData = await Database().writeData(
          databaseReference: FirebaseDatabase.instance,
          path: widget.imagePath!,
          // widget.imagePath
          data: {
            'role': 'assistant',
            'content': imageUrl,
          },
          overwriteData: false,
          pushData: true,
          context: context,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Error uploading image to Firebase Cloud Storage',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );
    colorTween = animationController.drive(
      ColorTween(
        begin: const Color(0xFFFFDAB9),
        end: const Color(0xFFFFA500),
      ),
    );
    animationController.repeat();
    if (!widget.isImage) {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();
      final Query query = databaseReference.child(widget.chatPath).orderByKey();
      query.onChildAdded.listen((event) {
        dynamic dataM = event.snapshot.value;
        Map<String, dynamic> dataMap = Map<String, dynamic>.from(dataM as Map);
        data.add(dataMap);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return get_x.GetBuilder<CustomGetXController>(builder: (controller) {
      return Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: WillPopScope(
            onWillPop: () {
              if (showEmoji) {
                setState(() {
                  showEmoji = !showEmoji;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: (!widget.isImage)
                          ? FirebaseAnimatedList(
                              query: FirebaseDatabase.instance
                                  .ref(widget.chatPath),
                              sort: (a, b) {
                                return b.key!.compareTo(a.key!);
                              },
                              reverse: true,
                              padding: const EdgeInsets.all(8),
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                dynamic value = snapshot.value;
                                if (value['content'] != null &&
                                    value['role'] != 'system') {
                                  return ChatMessage(
                                    text: value['content'],
                                    isMe: (value['role'] == 'user')
                                        ? true
                                        : false,
                                    animation: animation,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          : FirebaseAnimatedList(
                              query: FirebaseDatabase.instance
                                  .ref(widget.imagePath!),
                              sort: (a, b) {
                                return b.key!.compareTo(a.key!);
                              },
                              reverse: true,
                              padding: const EdgeInsets.all(8),
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                dynamic value = snapshot.value;
                                if (value['content'] != null &&
                                    value['role'] != 'system') {
                                  if (value['role'] == 'user') {
                                    return ChatMessage(
                                      text: value['content'],
                                      isMe: true,
                                      animation: animation,
                                    );
                                  } else {
                                    return ChatMessage(
                                      text: value['content'],
                                      isMe: false,
                                      animation: animation,
                                      isImage: true,
                                    );
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                    ),
                    (isLoading)
                        ? LinearProgressIndicator(
                            minHeight: 6,
                            backgroundColor: Theme.of(context).backgroundColor,
                            valueColor: colorTween,
                          )
                        : const SizedBox(),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              LineIcons.smilingFaceWithHeartEyes,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                showEmoji = true;
                              });
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: isLoading,
                              onTap: () {
                                if (showEmoji) {
                                  setState(() {
                                    showEmoji = !showEmoji;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text!';
                                }
                                return null;
                              },
                              cursorColor: Colors.white,
                              controller: _textController,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type your message',
                                hintStyle: GoogleFonts.nunitoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              LineIcons.paperPlane,
                              color: Colors.white,
                            ),
                            onPressed: () => (!isLoading)
                                ? (!widget.isImage)
                                    ? _handleChatSubmit(
                                        text: _textController.text,
                                        data: data,
                                        apiKey: controller.apiKey)
                                    : _handleImageSubmit(
                                        text: _textController.text,
                                        apiKey: controller.apiKey,
                                      )
                                : () {},
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 300),
                      child: (showEmoji)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: EmojiPicker(
                                textEditingController: _textController,
                                config: Config(
                                  columns: 7,
                                  emojiSizeMax: 32 *
                                      (foundation.defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? 1.30
                                          : 1.0),
                                  bgColor: Theme.of(context).backgroundColor,
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: double.maxFinite,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
