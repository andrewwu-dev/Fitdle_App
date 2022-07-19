import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  const Task(
      {super.key,
      required this.category,
      required this.icon,
      required this.unit,
      required this.goal,
      required this.taskProgress});

  final String category;
  final Icon icon;
  final String unit;
  final int goal;
  final int taskProgress;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 30),
            widget.icon,
            const SizedBox(width: 10),
            fitdleText(widget.category, body, weight: FontWeight.bold),
          ],
        ),
        const Divider(
          height: 10,
          thickness: 1,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            fitdleText(progress, body),
            Row(children: [
              fitdleText("${widget.taskProgress} / ${widget.goal}", h5, color: Colors.purple, weight: FontWeight.bold),
              const SizedBox(width: 5),
              fitdleText(widget.unit, body),
            ])
          ],
        ),
      ]),
    );
  }
}
