import 'dart:async';

import 'package:flutterfire_ui/firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/components/movie_quote_row_component.dart';
import 'package:movie_quotes/components/user_action_drawer.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/managers/movie_quote_collection_manager.dart';
import 'package:movie_quotes/models/movie_quote.dart';
import 'package:movie_quotes/pages/login_page.dart';
import 'package:movie_quotes/pages/movie_quote_details_page.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  bool _isShowingAllQuotes = true;

  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;

  @override
  void initState() {
    super.initState();
    _showAllQuotes();

    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      setState(() {});
    });
    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      setState(() {});
    });
  }

  void _showAllQuotes() {
    setState(() {
      _isShowingAllQuotes = true;
    });
  }

  void _showOnlyMyQuotes() {
    setState(() {
      _isShowingAllQuotes = false;
    });
  }

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey);
    AuthManager.instance.removeObserver(_logoutObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
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
      body: FirestoreListView<MovieQuote>(
        query: _isShowingAllQuotes
            ? MovieQuotesCollectionManager.instance.allMovieQuotesQuery
            : MovieQuotesCollectionManager.instance.mineOnlyMovieQuotesQuery,
        itemBuilder: (context, snapshot) {
          MovieQuote mq = snapshot.data();
          return MovieQuoteRow(
            movieQuote: mq,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MovieQuoteDetailsPage(
                        mq.documentId!); // In Firebase use a documentId
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
                _showAllQuotes();
              },
              showOnlyMineCallback: () {
                _showOnlyMyQuotes();
              },
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthManager.instance.isSignedIn) {
            showCreateQuoteDialog(context);
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

  Future<void> showCreateQuoteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Movie Quote'),
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
                    labelText: 'Enter the quote',
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
                    labelText: 'Enter the movie',
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
                  MovieQuotesCollectionManager.instance.addQuote(
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
