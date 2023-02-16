import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';

class ErrorBox extends StatelessWidget {
  final String errortxt;
  const ErrorBox({super.key, required this.errortxt});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: errortxt.isNotEmpty,
      child: Container(
        alignment: Alignment.center,
        child: fitdleText(errortxt, h5, color: Colors.red),
      ),
    );
  }
}
