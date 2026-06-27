import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen({super.key, required this.name});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  @override
  Widget build(BuildContext context) {
    var isLoading = ref.watch(communityControllerProvider);
    return ref
        .watch(getUserCommunityByNameProvider(widget.name))
        .when(
          data: (community) => Scaffold(
            appBar: AppBar(
              title: Text('Edit Community'),
              actions: [
                if (isLoading)
                  const Loader()
                else
                  TextButton(
                    onPressed: () => save(community),
                    child: Text('Save'),
                  ),
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
                                        : community.banner ==
                                                  Constants.bannerDefault ||
                                              community.banner.isEmpty
                                        ? Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          )
                                        : Image.network(community.banner),
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
                                            community.avatar,
                                          ),
                                          radius: 32,
                                        ),
                                ),
                              ),
                            ],
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

  void save(Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .editCommunity(
          community: community,
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
        );
  }
}
