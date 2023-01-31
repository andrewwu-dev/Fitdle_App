import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/font_size.dart';


Widget fitdleText(label, size, {color=Colors.black, weight=FontWeight.w400, align=TextAlign.center}) {
  return Text(
    label,
    style: TextStyle(fontFamily: "Roboto", fontSize: size, color: color, fontWeight: weight),
    overflow: TextOverflow.clip,
    textAlign: align
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

Widget primaryButton(label, action, {size=button, isEnabled=true}) {
  return CupertinoButton(
    color: Colors.purple,
    onPressed: isEnabled ? action : null,
    child: fitdleText(label, size, color: Colors.white)
  );
}

Scaffold fitdleSpinner() {
  // Need Scaffold to have white background and Center otherwise spinner takes
  // up whole screen.
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(color: Colors.purple),
    ),
  );
}

