import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserActionDrawer extends StatelessWidget {
  const UserActionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
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
            leading: const Icon(Icons.person),
            title: const Text("Show Only My Quotes"),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Show All Quotes"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
