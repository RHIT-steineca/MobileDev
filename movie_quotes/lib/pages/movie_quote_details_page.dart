import 'package:flutter/material.dart';

import '../models/movie_quote.dart';

class MovieQuoteDetailsPage extends StatefulWidget {
  final MovieQuote mq;
  const MovieQuoteDetailsPage(this.mq, {super.key});

  @override
  State<MovieQuoteDetailsPage> createState() => _MovieQuoteDetailsPageState();
}

class _MovieQuoteDetailsPageState extends State<MovieQuoteDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
        actions: [
          IconButton(
            onPressed: () {
              print("Clicked edit");
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              print("Clicked delete");
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          )
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
                    '"${widget.mq.quote}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "-${widget.mq.movie}",
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
