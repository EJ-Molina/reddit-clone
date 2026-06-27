import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  const AddModsScreen({super.key, required this.name});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int ctr = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: saveMod, icon: Icon(Icons.add))],
      ),
      body: ref
          .watch(getUserCommunityByNameProvider(widget.name))
          .when(
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (_, index) {
                  var memberId = community.members[index];
                  // get info by ID
                  return ref
                      .watch(getUserDataProvider(memberId))
                      .when(
                        data: (user) {
                          if (community.mods.contains(user.uid) && ctr == 1) {
                            uids.add(user.uid);
                          }
                          return CheckboxListTile(
                            value: uids.contains(user.uid),
                            onChanged: (value) {
                              if (value!) {
                                addUid(memberId);
                              } else {
                                removeUid(memberId);
                              }
                            },
                            title: Text(user.name),
                          );
                        },
                        error: (error, stackTracing) =>
                            ErrorScreen(errorText: error.toString()),
                        loading: () => const Loader(),
                      );
                },
              );
            },
            error: (error, stackTracing) =>
                ErrorScreen(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  void addUid(String uid) {
    uids.add(uid);
    setState(() {});
  }

  void removeUid(String uid) {
    uids.remove(uid);
    setState(() {});
  }

  void saveMod() {
    ref
        .read(communityControllerProvider.notifier)
        .addMod(widget.name, uids.toList(), context);
  }
}
