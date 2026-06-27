import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider = StateNotifierProvider((ref) {
  return CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    storageRepositoryProvider: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

final getUserCommunityProvider = StreamProvider.autoDispose((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getUserCommunityByNameProvider = StreamProvider.autoDispose.family((
  ref,
  String name,
) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.autoDispose.family((
  ref,
  String query,
) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final searchEjProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchEj(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepositoryProvider _storageRepositoryProvider;
  final Ref _ref;

  CommunityController({
    required this._communityRepository,
    required this._ref,
    required this._storageRepositoryProvider,
  }) : super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    // final result = await _ref.watch(communityRepositoryProvider).createCommunity(community);
    final result = await _communityRepository.createCommunity(community);
    state = false;
    result.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Community created successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    var uid = _ref.watch(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required Community community,
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepositoryProvider.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepositoryProvider.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void joinOrLeaveCommunity(
    Community community,
    String uid,
    BuildContext context,
  ) async {
    Either<Failure, void> res;
    if (community.members.contains(uid)) {
      res = await _communityRepository.leaveCommunity(community.name, uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, uid);
    }

    res.fold((l) => showSnackbar(context, l.message), (r) {
      if (community.members.contains(uid)) {
        showSnackbar(context, 'Community left successfully!');
      } else {
        showSnackbar(context, 'Community left successfully!');
      }
    });
  }

  void addMod(
    String communityName,
    List<String> uids,
    BuildContext context,
  ) async {
    final res = await _communityRepository.addMod(communityName, uids);

    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Updated successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> searchEj(String query) {
    return _communityRepository.searchEj(query);
  }
}
