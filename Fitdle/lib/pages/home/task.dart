import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  const Task(
      {super.key,
      required this.category,
      required this.unit,
      required this.goal,
      required this.taskProgress,
      required this.color});

  final String category;
  final String unit;
  final int goal;
  final int taskProgress;
  final Color color;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          fitdleText(widget.category, h4,
              color: Colors.white, weight: FontWeight.bold),
          Row(children: [
            fitdleText("${widget.taskProgress} / ${widget.goal}", h4,
                color: Colors.white, weight: FontWeight.bold),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: fitdleText(widget.unit, hint, color: Colors.white),
            )
          ])
        ],
      ),
    );
  }
}
