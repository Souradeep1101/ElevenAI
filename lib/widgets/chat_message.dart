import 'package:cached_network_image/cached_network_image.dart';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isMe;
  final Animation<double>? animation;
  final bool shouldAnimateText;
  final bool isImage;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isMe,
    this.shouldAnimateText = false,
    this.animation,
    this.isImage = false,
  }) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: widget.animation!,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: InkWell(
        onLongPress: () {
          Clipboard.setData(
            ClipboardData(text: widget.text),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: 'Text copied to clipboard',
              margin: const EdgeInsets.only(bottom: 200),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  child: Text(widget.isMe ? 'Me' : 'El'),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isMe ? 'You' : 'El',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: (!widget.isMe && widget.isImage)
                          ? CachedNetworkImage(
                              imageUrl: widget.text,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return const CircleAvatar(
                                  radius: 60,
                                  child: Icon(
                                    LineIcons.exclamationCircle,
                                    size: 120,
                                  ),
                                );
                              },
                            )
                          : Text(
                              widget.text,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
