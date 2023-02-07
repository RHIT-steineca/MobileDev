import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_quotes/components/user_action_drawer.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/managers/movie_quote_collection_manager.dart';
import 'package:movie_quotes/managers/movie_quote_document_manager.dart';

import '../models/movie_quote.dart';

class MovieQuoteDetailsPage extends StatefulWidget {
  final String documentId;
  const MovieQuoteDetailsPage(this.documentId, {super.key});

  @override
  State<MovieQuoteDetailsPage> createState() => _MovieQuoteDetailsPageState();
}

class _MovieQuoteDetailsPageState extends State<MovieQuoteDetailsPage> {
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  StreamSubscription? movieQuoteSubscription;

  @override
  void initState() {
    super.initState();

    movieQuoteSubscription = MovieQuotesDocumentManager.instance.startListening(
      widget.documentId,
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    MovieQuotesDocumentManager.instance.stopListening(movieQuoteSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showEditDelete =
        MovieQuotesDocumentManager.instance.latestMovieQuote != null &&
            AuthManager.instance.uid.isNotEmpty &&
            AuthManager.instance.uid ==
                MovieQuotesDocumentManager.instance.latestMovieQuote!.authorUID;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
        actions: [
          Visibility(
            visible: showEditDelete,
            child: IconButton(
              onPressed: () {
                print("Clicked edit");
                showEditQuoteDialog(context);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          Visibility(
            visible: showEditDelete,
            child: IconButton(
              onPressed: () {
                print("Clicked delete");
                final justDeletedQuote =
                    MovieQuotesDocumentManager.instance.latestMovieQuote!.quote;
                final justDeletedMovie =
                    MovieQuotesDocumentManager.instance.latestMovieQuote!.movie;
                MovieQuotesDocumentManager.instance.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Quote Deleted"),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        MovieQuotesCollectionManager.instance.addQuote(
                          quote: justDeletedQuote,
                          movie: justDeletedMovie,
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
                    MovieQuotesDocumentManager
                            .instance.latestMovieQuote?.quote ??
                        "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    MovieQuotesDocumentManager
                            .instance.latestMovieQuote?.movie ??
                        "",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontStyle: FontStyle.italic,
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

  Future<void> showEditQuoteDialog(BuildContext context) {
    quoteTextController.text =
        MovieQuotesDocumentManager.instance.latestMovieQuote?.quote ?? "";
    movieTextController.text =
        MovieQuotesDocumentManager.instance.latestMovieQuote?.movie ?? "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Movie Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: quoteTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Edit quote',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: movieTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Edit movie',
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
              child: const Text('Save Change'),
              onPressed: () {
                setState(() {
                  MovieQuotesDocumentManager.instance.editQuote(
                    quote: quoteTextController.text,
                    movie: movieTextController.text,
                  );
                  quoteTextController.text = "";
                  movieTextController.text = "";
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
