import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:reddit_clone/features/post/screens/add_post_type_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {'/': (route) => const MaterialPage(child: LoginScreen())},
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => MaterialPage(child: HomeScreen()),
    '/create-community': (_) => MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
      child: CommunityScreen(name: route.pathParameters['name']!),
    ),
    '/mod-tools/:name': (route) => MaterialPage(
      child: ModToolsScreen(name: route.pathParameters['name']!),
    ),
    '/edit-community/:name': (route) => MaterialPage(
      child: EditCommunityScreen(name: route.pathParameters['name']!),
    ),
    '/add-mods/:name': (route) =>
        MaterialPage(child: AddModsScreen(name: route.pathParameters['name']!)),
    '/user-profile/:name': (route) => MaterialPage(
      child: UserProfileScreen(uid: route.pathParameters['name']!),
    ),
    '/edit-profile/:name': (route) => MaterialPage(
      child: EditProfileScreen(uid: route.pathParameters['name']!),
    ),
    '/add-post/:type': (route) => MaterialPage(
      child: AddPostTypeScreen(type: route.pathParameters['type']!),
    ),
  },
);
