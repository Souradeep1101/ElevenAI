import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CustomProfileImageAvatar extends StatefulWidget {
  final String? imageUrl;

  const CustomProfileImageAvatar({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<CustomProfileImageAvatar> createState() =>
      _CustomProfileImageAvatarState();
}

class _CustomProfileImageAvatarState extends State<CustomProfileImageAvatar> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl ?? '',
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: 60,
        backgroundImage: imageProvider,
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return CircleAvatar(
          radius: 60,
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        );
      },
      errorWidget: (context, url, error) {
        if (url.isEmpty) {
          return const CircleAvatar(
            radius: 60,
            child: Icon(
              LineIcons.userCircleAlt,
              size: 120,
            ),
          );
        } else {
          return const CircleAvatar(
            radius: 60,
            child: Icon(
              LineIcons.exclamationCircle,
              size: 120,
            ),
          );
        }
      },
    );
  }
}
