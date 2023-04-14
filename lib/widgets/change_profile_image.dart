import 'dart:io';
import 'package:eleven_ai/widgets/custom_bottom_sheet.dart';
import 'package:eleven_ai/widgets/custom_profile_image_avatar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ChangeProfileImage extends StatefulWidget {
  final dynamic imageFile;
  final String? initialImageUrl;
  final bool isImagePicked;

  const ChangeProfileImage({
    Key? key,
    required this.imageFile,
    required this.isImagePicked,
    this.initialImageUrl,
  }) : super(key: key);

  @override
  State<ChangeProfileImage> createState() => _ChangeProfileImageState();
}

class _ChangeProfileImageState extends State<ChangeProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.initialImageUrl == null || widget.isImagePicked)
            ? CircleAvatar(
                radius: 60,
                backgroundImage: (widget.imageFile != null)
                    ? FileImage(File(widget.imageFile!['path']))
                    : null,
              )
            : CustomProfileImageAvatar(
                imageUrl: widget.initialImageUrl,
              ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                LineIcons.camera,
                color: Colors.black,
                size: 28.0,
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) => const CustomModalBottomSheet(),
              );
            },
          ),
        ),
      ],
    );
  }
}
