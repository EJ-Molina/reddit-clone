import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider = StateNotifierProvider((ref) {
  return CommunityController(
    communityRepository: ref.read(communityRepositoryProvider),
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
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({required this._communityRepository, required this._ref})
    : super(false);

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
}
