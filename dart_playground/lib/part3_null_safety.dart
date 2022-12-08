import 'package:flutter/material.dart';

void main() {
  // double? nullableDouble = null; // allows null
  // double? nullableDouble; // same thing
  // double nonNullableDouble = null; // wont compile

  // ?. optional chaining; if thing != null, do next step
  // ! or !. forced unwrapping; I, as dev, promise thing != null
  // late double willBeNonNull; // preemptive !

  ElevatedButton? button;
  button = ElevatedButton(onPressed: null, child: null);
  if (7 > 6) {
    Text? txt = const Text("Hello World!");
    txt = null;
    button = ElevatedButton(onPressed: null, child: txt);
  } else {
    button = null;
  }
  print("Button = $button");
  print("Buttons child text = ${button?.child}");
  print("Data = ${((button?.child) as Text?)?.data}"); // fully bulletproof
  // print("Data = ${((button?.child) as Text).data}"); // protect null button
  // print("Data = ${((button!.child) as Text?)?.data}"); // protect null child
}
