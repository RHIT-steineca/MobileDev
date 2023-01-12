import 'package:flutter/material.dart';
import 'package:movie_quotes/components/movie_quote_row_component.dart';
import 'package:movie_quotes/models/movie_quote.dart';
import 'package:movie_quotes/pages/movie_quote_details_page.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  final quotes = <MovieQuote>[];
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quotes.add(
      MovieQuote(
        quote: "I'll be back",
        movie: "The Terminator",
      ),
    );
    quotes.add(
      MovieQuote(
        quote:
            "Hello. My name is Inigo Montoya. You killed my father. Prepare to die.",
        movie: "The Princess Bride",
      ),
    );
  }

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MovieQuoteRow> movieRows = quotes
        .map((mq) => MovieQuoteRow(
              movieQuote: mq,
              onTap: () {
                print(
                    "You clicked on the movie quote ${mq.quote} - ${mq.movie}");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MovieQuoteDetailsPage(mq);
                    },
                  ),
                );
              },
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: movieRows,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateQuoteDialog(context);
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
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
                  quotes.add(
                    MovieQuote(
                      quote: quoteTextController.text,
                      movie: movieTextController.text,
                    ),
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
