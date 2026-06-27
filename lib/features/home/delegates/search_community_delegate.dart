import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ref
        .watch(searchEjProvider(query))
        .when(
          data: (communites) => ListView.builder(
            itemCount: communites.length,
            itemBuilder: (BuildContext context, int index) {
              final community = communites[index];
              return communites.isEmpty
                  ? Center(child: Text('No results'))
                  : ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      title: Text('r/${community.name}'),
                      onTap: () => navigateToCommunity(context, community.name),
                    );
            },
          ),
          error: (error, stackTrace) =>
              ErrorScreen(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref
        .watch(searchEjProvider(query))
        .when(
          data: (communites) => ListView.builder(
            itemCount: communites.length,
            itemBuilder: (BuildContext context, int index) {
              final community = communites[index];
              return communites.isEmpty
                  ? Center(child: Text('No results'))
                  : ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      title: Text('r/${community.name}'),
                      onTap: () => navigateToCommunity(context, community.name),
                    );
            },
          ),
          error: (error, stackTrace) =>
              ErrorScreen(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}
