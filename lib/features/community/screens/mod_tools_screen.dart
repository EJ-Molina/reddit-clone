import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mod Tools')),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text('Add Moderators'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Moderators'),
            onTap: () => navigateToEditCommunityScreen(context),
          ),
        ],
      ),
    );
  }

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }
}
