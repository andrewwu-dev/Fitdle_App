import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
class ErrorBox extends StatelessWidget {
  final String errortxt;
  ErrorBox({required this.errortxt});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: null != errortxt && errortxt.isNotEmpty,
      child: Container(
        alignment: Alignment.center,
        child: fitdleText(errortxt, h5, color: Colors.red),
      ),
    );
  }
}
