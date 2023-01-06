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
            ColorSlider(title: "Red", value: redvalue, color: Colors.red),
            ColorSlider(title: "Green", value: greenvalue, color: Colors.green),
            ColorSlider(title: "Blue", value: bluevalue, color: Colors.blue),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                color: Colors.red,
              ),
            )
          ],
        ));
  }
}
