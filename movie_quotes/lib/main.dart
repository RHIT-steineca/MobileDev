import 'package:flutter/material.dart';
import 'package:movie_quotes/pages/movie_quotes_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MovieQuotesListPage(),
    );
  }
}