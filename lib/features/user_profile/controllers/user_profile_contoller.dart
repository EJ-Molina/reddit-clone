import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileContollerProvider = StateNotifierProvider((ref) {
  return UserProfileContoller(
    userProfileRepository: ref.watch(userProfileRepositoryProvider),
    ref: ref,
    storageRepositoryProvider: ref.watch(storageRepositoryProvider),
  );
});

class UserProfileContoller extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepositoryProvider _storageRepositoryProvider;
  final Ref _ref;

  UserProfileContoller({
    required this._userProfileRepository,
    required this._ref,
    required this._storageRepositoryProvider,
  }) : super(false);

  void editProfile({
    required UserModel user,
    required String updatedName,
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepositoryProvider.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepositoryProvider.storeFile(
        path: 'users/banner',
        id: user.name,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    //Updated UserModel
    user = user.copyWith(name: updatedName);

    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }
}
