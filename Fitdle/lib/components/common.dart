import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/font_size.dart';


Widget fitdleText(label, size, {color=Colors.black, weight=FontWeight.w400}) {
  return Text(
      label,
      style: TextStyle(fontFamily: "Roboto", fontSize: size, color: color, fontWeight: weight)
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
      child: fitdleText(label, button, color: Colors.white)
  );
}

