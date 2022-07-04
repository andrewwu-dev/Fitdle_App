import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitdle/constants+utility.dart';

Widget fitdleText(label, size, [color]) {
  color ??= Colors.black;
  return Text(
      label,
      style: TextStyle(fontFamily: 'Roboto', fontSize: size, color: color)
  );
}

Widget fitdleTextField(placeholder) {
  return TextField(
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: placeholder
    ),
  );
}



Widget primaryButton(label, action) {
  return CupertinoButton(
      color: Colors.purple,
      onPressed: action,
      child: fitdleText(label, button, Colors.white)
  );
}