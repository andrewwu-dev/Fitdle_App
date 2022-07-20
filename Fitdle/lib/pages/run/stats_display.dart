import 'package:fitdle/components/common.dart';
import 'package:flutter/material.dart';

class StatsDisplay extends StatefulWidget {
  const StatsDisplay(
      {super.key,
      required this.value,
      required this.label,
      required this.valueFontSize,
      required this.labelFontSize});

  final String value;
  final String label;
  final double valueFontSize;
  final double labelFontSize;

  @override
  State<StatsDisplay> createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        fitdleText(widget.value, widget.valueFontSize),
        const SizedBox(
          width: 140,
          child: Divider(
            height: 10,
            thickness: 1,
            color: Colors.black,
          ),
        ),
        fitdleText(widget.label, widget.labelFontSize),
      ]
    );
  }
}
