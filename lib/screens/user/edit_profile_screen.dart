import 'package:eleven_ai/controllers/custom_getx_controller.dart';
import 'package:eleven_ai/core/firebase/database/database.dart';
import 'package:eleven_ai/core/firebase/store/storage.dart';
import 'package:eleven_ai/widgets/change_profile_image.dart';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eleven_ai/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final CustomGetXController customGetXController =
      Get.put(CustomGetXController());
  bool isSuccessfullyUploaded = false;
  String? imageUrl;
  dynamic userData;
  bool _isLoading = false;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    controller.text = FirebaseAuth.instance.currentUser!.displayName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomGetXController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: ChangeProfileImage(
                    imageFile: controller.imageFile,
                    isImagePicked: controller.isImagePicked,
                    initialImageUrl:
                        FirebaseAuth.instance.currentUser?.photoURL,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: this.controller,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: CustomElevatedButton(
                      isLoading: _isLoading,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (controller.imageFile != null) {
                          isSuccessfullyUploaded = await Storage().uploadFile(
                              filePath: controller.imageFile!['path'],
                              fileName: controller.imageFile!['file_name'],
                              directory:
                                  'profile_img/${FirebaseAuth.instance.currentUser!.uid}/',
                              context: context);
                          if (isSuccessfullyUploaded) {
                            imageUrl = await FirebaseStorage.instance
                                .ref()
                                .child(
                                  'profile_img/${FirebaseAuth.instance.currentUser!.uid}/${controller.imageFile!['file_name']}',
                                )
                                .getDownloadURL();
                            if (imageUrl != null) {
                              userData = await Database().writeData(
                                databaseReference: FirebaseDatabase.instance,
                                path:
                                    'users/${FirebaseAuth.instance.currentUser!.uid}',
                                data: {'image_url': imageUrl},
                                overwriteData: false,
                                pushData: false,
                                context: context,
                              );
                              await FirebaseAuth.instance.currentUser!
                                  .updatePhotoURL(imageUrl);
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                        try {
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(this.controller.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              message:
                                  'Your credentials have been successfully updated',
                              margin: const EdgeInsets.only(bottom: 200),
                            ),
                          );
                          Navigator.popUntil(
                            context,
                            (Route<dynamic> route) => route.isFirst,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              message:
                                  'An error occurred while updating your credentials: $e',
                              margin: const EdgeInsets.only(bottom: 200),
                            ),
                          );
                        }
                      },
                      text: 'Save Changes',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    });
  }
}
