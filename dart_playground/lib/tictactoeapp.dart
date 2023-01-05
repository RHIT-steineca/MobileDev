import 'package:flutter/material.dart';
import 'dart:ui';

import 'tictactoegame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Tic-Tac-Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var game = TicTacToeGame();

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];
    for (var k = 0; k < 9; k++) {
      buttons.add(
        InkWell(
          onTap: () {
            setState(() {
              game.selectSquare(k);
            });
          },
          child: Image.asset(
            (game.board[k] == Mark.x)
                ? Image.asset("tictactoe_images/x.png")
                : ((game.board[k] == Mark.o)
                    ? Image.asset("tictactoe_images/o.png")
                    : Image.asset("tictactoe_images/blank.png")),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              game.stateString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Container(
                constraints: BoxConstraints(maxWidth: 400.0),
                child: GridView.count(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: buttons,
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    game = TicTacToeGame();
                  });
                },
                child: const Text(
                  "New Game",
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              const SizedBox(width: 20.0),
            ])
          ],
        ),
      ),
    );
  }
}
