import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final queryCtr = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    queryCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              Expanded(
                child: TextField(
                  controller: queryCtr,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: .only(top: 12, left: 20),
                    hintText: 'Search',
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        queryCtr.clear();
                        _query = "";
                      }),
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Gap(10),
              ref
                  .watch(searchCommunityProvider(_query))
                  .when(
                    data: (communties) {
                      // if (communties.isEmpty) {
                      //   return Center(child: const Text('No results'));
                      // }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: communties.length,
                          itemBuilder: (_, index) {
                            final community = communties[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: Text(community.name),
                              onTap: () =>
                                  navigateToCommunity(context, community.name),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTracing) =>
                        ErrorScreen(errorText: error.toString()),
                    loading: () => const Loader(),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}
