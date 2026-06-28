import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/postController.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleCtr = TextEditingController();
  final descCtr = TextEditingController();
  final linkCtr = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  File? bannerFile;
  // File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res == null) return;
    bannerFile = File(res.path);
    setState(() {});
  }

  // void selectProfileImage() async {
  //   final res = await pickImage();

  //   if (res == null) return;
  //   profileFile = File(res.path);
  //   setState(() {});
  // }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleCtr.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareImagePost(
            context: context,
            title: titleCtr.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleCtr.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareTextPost(
            context: context,
            title: titleCtr.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descCtr.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleCtr.text.isNotEmpty &&
        linkCtr.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareLinkPost(
            context: context,
            title: titleCtr.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkCtr.text.trim(),
          );
    } else {
      showSnackbar(context, 'Please enter all the fields');
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          fontWeight: .bold,
          fontSize: 16,
          letterSpacing: .5,
        ),
        title: Text('Post ${widget.type}'),
        centerTitle: true,
        actions: [TextButton(onPressed: sharePost, child: Text('Share'))],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleCtr,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter title here',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: .circular(10),
                      ),
                      border: InputBorder.none,
                    ),
                    maxLength: 30,
                  ),
                  Gap(10),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: Radius.circular(10),
                          dashPattern: [10, 4],
                          strokeCap: .round,
                          // color:
                          // Pallete.darkModeAppTheme.textTheme.bodyMedium!.color!,
                          color: currentTheme.textTheme.bodyMedium!.color!,
                        ),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: .circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descCtr,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter Description here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: .circular(10),
                        ),
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),

                  if (isTypeLink)
                    TextField(
                      controller: linkCtr,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter link here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: .circular(10),
                        ),
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                  const Gap(20),
                  Align(alignment: .topLeft, child: Text('Select Community')),
                  ref
                      .watch(getUserCommunityProvider)
                      .when(
                        data: (data) {
                          communities = data;

                          if (data.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (community) => DropdownMenuItem(
                                    value: community,
                                    child: Text(community.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              selectedCommunity = val;
                              setState(() {});
                            },
                          );
                        },
                        error: (error, stackTracing) =>
                            ErrorScreen(errorText: error.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
    );
  }
}
