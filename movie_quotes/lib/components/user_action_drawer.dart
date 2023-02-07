import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/managers/auth_manager.dart';

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
                color: Colors.blue,
              ),
              child: Text(
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
                "Movie Quotes",
              )),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Show Only My Quotes"),
            onTap: () {
              showOnlyMineCallback();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Show All Quotes"),
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
