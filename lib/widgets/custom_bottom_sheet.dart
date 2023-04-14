import 'package:eleven_ai/controllers/custom_getx_controller.dart';
import 'package:eleven_ai/core/firebase/store/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

class CustomModalBottomSheet extends StatefulWidget {
  const CustomModalBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomModalBottomSheet> createState() => _CustomModalBottomSheetState();
}

class _CustomModalBottomSheetState extends State<CustomModalBottomSheet> {
  dynamic imageFile;
  CustomGetXController customGetXController = Get.find<CustomGetXController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            'Choose Profile Picture',
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(LineIcons.camera),
                onPressed: () async {
                  imageFile = await PickImage().pickImage(context: context);
                  customGetXController.updateImageFile(imageFile);
                },
                label: const Text("Camera"),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(LineIcons.image),
                onPressed: () async {
                  imageFile = await PickImage().pickImage(
                    context: context,
                    source: ImageSource.gallery,
                  );
                  customGetXController.updateImageFile(imageFile);
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
