import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linearlightsout/lightsoutgame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linear Lights Out',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Linear Lights Out'),
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
  final int appnumbuttons = 3;
  var game = LightsOutGame(3);

  @override
  Widget build(BuildContext context) {
    final lightButtons = <Widget>[];
    for (var k = 0; k < appnumbuttons; k++) {
      lightButtons.add(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 100,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                game.selectLight(k);
              });
            },
            child: Image.asset((game.linearlights[k] == true)
                ? "assets/images/light_on.png"
                : "assets/images/light_off.png"),
          ),
        ),
      );
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                game.stateString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: lightButtons,
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                onPressed: () {
                  setState(() {
                    game = LightsOutGame(appnumbuttons);
                  });
                },
                child: const Text(
                  "New Game",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
