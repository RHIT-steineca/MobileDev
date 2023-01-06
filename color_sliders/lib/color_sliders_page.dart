import 'package:color_sliders/color_sliders_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ColorSlidersPage extends StatefulWidget {
  const ColorSlidersPage({super.key});

  @override
  State<ColorSlidersPage> createState() => _ColorSlidersPageState();
}

class _ColorSlidersPageState extends State<ColorSlidersPage> {
  double redvalue = 0.5;
  double greenvalue = 0.5;
  double bluevalue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Color Sliders"),
        ),
        body: Column(
          children: [
            ColorSlider(
              title: "Red",
              value: redvalue,
              color: Colors.red,
              onChange: (newValue) {
                setState(() {
                  redvalue = newValue;
                });
              },
            ),
            ColorSlider(
              title: "Green",
              value: greenvalue,
              color: Colors.green,
              onChange: (newValue) {
                setState(() {
                  greenvalue = newValue;
                });
              },
            ),
            ColorSlider(
              title: "Blue",
              value: bluevalue,
              color: Colors.blue,
              onChange: (newValue) {
                setState(() {
                  bluevalue = newValue;
                });
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                color: Color.fromRGBO((255 * redvalue).round(),
                    (255 * greenvalue).round(), (255 * bluevalue).round(), 1.0),
              ),
            )
          ],
        ));
  }
}
