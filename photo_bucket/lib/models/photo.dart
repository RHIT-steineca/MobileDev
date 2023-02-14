import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_model_utils.dart';

const String kPhotoCollectionPath = "PhotoBucket";
const String kPhoto_authorUID = "authorUID";
const String kPhoto_title = "title";
const String kPhoto_url = "url";
const String kPhoto_lastTouched = "lastTouched";

class Photo {
  String? documentId;
  String authorUID;
  String title;
  String url;
  Timestamp lastTouched;

  Photo({
    this.documentId,
    required this.authorUID,
    required this.title,
    required this.url,
    required this.lastTouched,
  });

  Photo.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          authorUID: FirestoreModelUtils.getStringField(doc, kPhoto_authorUID),
          title: FirestoreModelUtils.getStringField(doc, kPhoto_title),
          url: FirestoreModelUtils.getStringField(doc, kPhoto_url),
          lastTouched:
              FirestoreModelUtils.getTimestampField(doc, kPhoto_lastTouched),
        );

  Map<String, Object?> toMap() {
    return {
      kPhoto_authorUID: authorUID,
      kPhoto_lastTouched: lastTouched,
      kPhoto_title: title,
      kPhoto_url: url,
    };
  }
}
