import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var communityList = ref.watch(getUserCommunityProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Create a community'),
              leading: Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            communityList.when(
              data: (data) => Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    var item = data[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item.avatar),
                      ),
                      title: Text('/r${item.name}'),
                      onTap: () => navigateToCommunity(context, item),
                    );
                  },
                  itemCount: data.length,
                ),
              ),
              error: (error, stackTracing) =>
                  ErrorScreen(errorText: error.toString()),
              loading: () => const Loader(),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }
}
