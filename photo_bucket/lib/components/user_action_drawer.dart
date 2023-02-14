import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_bucket/managers/auth_manager.dart';

class UserActionDrawer extends StatelessWidget {
  final Function() showAllCallback;
  final Function() showOnlyMineCallback;
  const UserActionDrawer({
    required this.showAllCallback,
    required this.showOnlyMineCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
                "Photo Bucket",
              )),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Show Only My Photos"),
            onTap: () {
              showOnlyMineCallback();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Show All Photos"),
            onTap: () {
              showAllCallback();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              AuthManager.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
