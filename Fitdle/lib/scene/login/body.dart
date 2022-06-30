import 'package:flutter/material.dart';
import 'package:fitdle/constants/spacing.dart';
import 'package:fitdle/constants/strings.dart';
import 'package:fitdle/constants/font_size.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: top_padding, left: regular, right: regular),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                app_name,
                style: TextStyle(fontFamily: 'Roboto', fontSize: h1)
            ),
            SizedBox(height: 100),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username"
              ),
            ),
            SizedBox(height: regular),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password"
              ),
            ),
            SizedBox(height: 14),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                  forgot_password,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: hint)
              ),
            ),
            SizedBox(height: size.height/3),
            Align(
              alignment: Alignment.center,
              child: Text(
                  no_account,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: hint)
              ),
            )
          ]
      ),
    );;
  }
}