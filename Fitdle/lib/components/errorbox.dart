import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String errortxt;
  ErrorBox({required this.errortxt});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: null != errortxt && errortxt.isNotEmpty,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          errortxt,
          style: TextStyle(
            color: Colors.red,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
