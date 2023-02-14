import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/photo.dart';
import '../managers/photo_document_manager.dart';
import '../managers/photo_collection_manager.dart';
import '../managers/auth_manager.dart';

class PhotoDetailsPage extends StatefulWidget {
  final String documentId;
  const PhotoDetailsPage(this.documentId, {super.key});

  @override
  State<PhotoDetailsPage> createState() => _PhotoDetailsPageState();
}

class _PhotoDetailsPageState extends State<PhotoDetailsPage> {
  final titleTextController = TextEditingController();
  final urlTextController = TextEditingController();

  StreamSubscription? photoSubscription;

  @override
  void initState() {
    super.initState();

    photoSubscription = PhotoDocumentManager.instance.startListening(
      widget.documentId,
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    titleTextController.dispose();
    urlTextController.dispose();
    PhotoDocumentManager.instance.stopListening(photoSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showEditDelete =
        PhotoDocumentManager.instance.latestPhoto != null &&
            AuthManager.instance.uid.isNotEmpty &&
            AuthManager.instance.uid ==
                PhotoDocumentManager.instance.latestPhoto!.authorUID;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Bucket"),
        actions: [
          Visibility(
            visible: showEditDelete,
            child: IconButton(
              onPressed: () {
                showEditPhotoDialog(context);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          Visibility(
            visible: showEditDelete,
            child: IconButton(
              onPressed: () {
                final justDeletedTitle =
                    PhotoDocumentManager.instance.latestPhoto!.title;
                final justDeletedURL =
                    PhotoDocumentManager.instance.latestPhoto!.url;
                PhotoDocumentManager.instance.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        PhotoCollectionManager.instance.addPhoto(
                          title: justDeletedTitle,
                          url: justDeletedURL,
                        );
                      },
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: SizedBox(
            width: 700.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25.0),
                  child: Text(
                    PhotoDocumentManager.instance.latestPhoto?.title ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  constraints:
                      BoxConstraints(maxHeight: 600.0, maxWidth: 600.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        PhotoDocumentManager.instance.latestPhoto?.url ?? "",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showEditPhotoDialog(BuildContext context) {
    titleTextController.text =
        PhotoDocumentManager.instance.latestPhoto?.title ?? "";
    urlTextController.text =
        PhotoDocumentManager.instance.latestPhoto?.url ?? "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Photo'),
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
                    labelText: 'Edit Title',
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
                    labelText: 'Edit URL',
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
              child: const Text('Save Changes'),
              onPressed: () {
                setState(() {
                  PhotoDocumentManager.instance.editPhoto(
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

class LabelledTextDisplay extends StatelessWidget {
  final String title;
  final String content;
  final IconData iconData;

  const LabelledTextDisplay({
    super.key,
    required this.title,
    required this.content,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w800,
                fontFamily: "Caveat"),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(iconData),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 18.0,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
