import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_model_utils.dart';

const String kMovieQuoteCollectionPath = "MovieQuotes";
const String kMovieQuote_authorUID = "authorUID";
const String kMovieQuote_quote = "quote";
const String kMovieQuote_movie = "movie";
const String kMovieQuote_lastTouched = "lastTouched";

class MovieQuote {
  String? documentId;
  String authorUID;
  String quote;
  String movie;
  Timestamp lastTouched;

  MovieQuote({
    this.documentId,
    required this.authorUID,
    required this.quote,
    required this.movie,
    required this.lastTouched,
  });

  MovieQuote.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          authorUID:
              FirestoreModelUtils.getStringField(doc, kMovieQuote_authorUID),
          quote: FirestoreModelUtils.getStringField(doc, kMovieQuote_quote),
          movie: FirestoreModelUtils.getStringField(doc, kMovieQuote_movie),
          lastTouched: FirestoreModelUtils.getTimestampField(
              doc, kMovieQuote_lastTouched),
        );

  Map<String, Object?> toMap() {
    return {
      kMovieQuote_authorUID: authorUID,
      kMovieQuote_lastTouched: lastTouched,
      kMovieQuote_movie: movie,
      kMovieQuote_quote: quote,
    };
  }
}
