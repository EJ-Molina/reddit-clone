import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/controllers/user_profile_contoller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.watch(userProvider)!.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileContollerProvider);
    return ref
        .watch(getUserDataProvider(widget.uid))
        .when(
          data: (user) => Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions: [
                TextButton(onPressed: () => save(user), child: Text('Save')),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(10),
                                    dashPattern: [10, 4],
                                    strokeCap: .round,
                                    color: Pallete
                                        .darkModeAppTheme
                                        .textTheme
                                        .bodyMedium!
                                        .color!,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: .circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : user.banner ==
                                                  Constants.bannerDefault ||
                                              user.banner.isEmpty
                                        ? Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          )
                                        : Image.network(user.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(
                                            profileFile!,
                                          ),
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            user.profilePic,
                                          ),
                                          radius: 32,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: .circular(10),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, stackTracing) =>
              ErrorScreen(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res == null) return;
    bannerFile = File(res.path);
    setState(() {});
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res == null) return;
    profileFile = File(res.path);
    setState(() {});
  }

  void save(UserModel user) {
    ref
        .read(userProfileContollerProvider.notifier)
        .editProfile(
          user: user,
          updatedName: nameController.text.trim(),
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
        );
  }
}
