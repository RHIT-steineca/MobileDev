import 'dart:async';

import 'package:flutterfire_ui/firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_bucket/managers/auth_manager.dart';
import 'package:photo_bucket/managers/photo_collection_manager.dart';
import 'package:photo_bucket/components/photo_row_component.dart';
import 'package:photo_bucket/components/user_action_drawer.dart';
import 'package:photo_bucket/models/photo.dart';
import 'package:photo_bucket/pages/photo_details_page.dart';
import 'package:photo_bucket/pages/login_page.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({super.key});

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final titleTextController = TextEditingController();
  final urlTextController = TextEditingController();

  bool _isShowingAllPhotos = true;

  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;

  @override
  void initState() {
    super.initState();
    _showAllPhotos();

    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      setState(() {});
    });
    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      setState(() {});
    });
  }

  void _showAllPhotos() {
    setState(() {
      _isShowingAllPhotos = true;
    });
  }

  void _showOnlyMyPhotos() {
    setState(() {
      _isShowingAllPhotos = false;
    });
  }

  @override
  void dispose() {
    titleTextController.dispose();
    urlTextController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey);
    AuthManager.instance.removeObserver(_logoutObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Bucket"),
        actions: AuthManager.instance.isSignedIn
            ? null
            : [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const LoginPage();
                    }));
                  },
                  tooltip: "Log in",
                  icon: const Icon(Icons.login),
                ),
              ],
      ),
      backgroundColor: Colors.grey[100],
      body: FirestoreListView<Photo>(
        query: _isShowingAllPhotos
            ? PhotoCollectionManager.instance.allPhotosQuery
            : PhotoCollectionManager.instance.mineOnlyPhotosQuery,
        itemBuilder: (context, snapshot) {
          Photo p = snapshot.data();
          return PhotoRow(
            photo: p,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PhotoDetailsPage(
                        p.documentId!); // In Firebase use a documentId
                  },
                ),
              );
              setState(() {});
            },
          );
        },
      ),
      drawer: AuthManager.instance.isSignedIn
          ? UserActionDrawer(
              showAllCallback: () {
                _showAllPhotos();
              },
              showOnlyMineCallback: () {
                _showOnlyMyPhotos();
              },
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthManager.instance.isSignedIn) {
            showCreatePhotoDialog(context);
          } else {
            showMustLogInDialog(context);
          }
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMustLogInDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Required"),
            content:
                const Text("You must be signed in to perform this action."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginPage();
                  }));
                },
                child: const Text("Log In"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  Future<void> showCreatePhotoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: titleTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the photo\'s name',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: urlTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the photo\'s url',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                setState(() {
                  PhotoCollectionManager.instance.addPhoto(
                    title: titleTextController.text,
                    url: urlTextController.text,
                  );
                  titleTextController.text = "";
                  urlTextController.text = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
