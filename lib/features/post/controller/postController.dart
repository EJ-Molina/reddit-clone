import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider((ref) {
  return Postcontroller(
    postRepository: ref.watch(postRepositoryProvider),
    storageRepositoryProvider: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

class Postcontroller extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepositoryProvider _storageRepositoryProvider;

  Postcontroller({
    required this._postRepository,
    required this._ref,
    required this._storageRepositoryProvider,
  }) : super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      description: description,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
    );

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      link: link,
      createdAt: DateTime.now(),
      awards: [],
    );

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepositoryProvider.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackbar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        link: r,
        createdAt: DateTime.now(),
        awards: [],
      );

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackbar(context, l.message), (r) {
        showSnackbar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    });
  }
}
