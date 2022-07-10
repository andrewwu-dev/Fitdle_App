import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/font_size.dart';


Widget fitdleText(label, size, [color]) {
  color ??= Colors.black;
  return Text(
      label,
      style: TextStyle(fontFamily: 'Roboto', fontSize: size, color: color)
  );
}

Widget fitdleTextField(controller, placeholder) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: placeholder
    ),
  );
}

Widget fitdlePasswordField(controller, placeholder) {
  return TextField(
    controller: controller,
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: placeholder
    ),
  );
}

Widget primaryButton(label, action, {isEnabled=true}) {
  return CupertinoButton(
      color: Colors.purple,
      onPressed: isEnabled ? action : null,
      child: fitdleText(label, button, Colors.white)
  );
}

