import 'package:eleven_ai/core/firebase/database/database.dart';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ChatTile extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final String? chatKey;
  final Animation<double> animation;

  const ChatTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.chatKey,
    required this.animation,
  }) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _isDeleting = false;
  dynamic allChatData;
  final _formKey = GlobalKey<FormState>();

  Future<void> editAction() async {
    if (_formKey.currentState!.validate()) {
      allChatData = await Database().writeData(
        databaseReference: FirebaseDatabase.instance,
        path:
            'chats/${FirebaseAuth.instance.currentUser!.uid}/${widget.chatKey}',
        data: {
          'chat_title': _controller.text.trim(),
        },
        overwriteData: false,
        pushData: false,
        context: context,
      );
      if (allChatData != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Renaming to ${_controller.text.trim()}.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Failed to rename!',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      }
      setState(() {
        _isEditing = false;
      });
    }
  }

  void deleteAction() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Successfully deleted ${widget.title}.',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      _isDeleting = false;
      await FirebaseDatabase.instance
          .ref(
              'chats/${FirebaseAuth.instance.currentUser!.uid}/${widget.chatKey}')
          .remove();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to delete ${widget.title}!',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
    }
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: widget.animation,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              focusColor: Theme.of(context).primaryColor,
              onTap: (_isEditing)
                  ? () {}
                  : (_isDeleting)
                      ? () {}
                      : widget.onTap,
              child: ListTile(
                horizontalTitleGap: double.minPositive,
                leading: Icon(
                  LineIcons.comment,
                  color: Theme.of(context).primaryColor,
                ),
                title: _isEditing
                    ? TextFormField(
                        controller: _controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a chat title';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      )
                    : _isDeleting
                        ? Text(
                            'Are you sure you want to delete?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    _isEditing
                        ? IconButton(
                            onPressed: editAction,
                            icon: Icon(
                              LineIcons.check,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : _isDeleting
                            ? IconButton(
                                onPressed: deleteAction,
                                icon: Icon(
                                  LineIcons.check,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                                icon: Icon(
                                  LineIcons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                    _isEditing
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            icon: Icon(
                              LineIcons.times,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : _isDeleting
                            ? IconButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _isDeleting = false;
                                    });
                                  }
                                },
                                icon: Icon(
                                  LineIcons.times,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isDeleting = true;
                                  });
                                },
                                icon: Icon(
                                  LineIcons.trash,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
