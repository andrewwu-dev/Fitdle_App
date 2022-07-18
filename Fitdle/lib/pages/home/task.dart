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
            Text(widget.category,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: body,
                    fontWeight: FontWeight.bold))
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
            const Text(progress,
                style: TextStyle(fontFamily: 'Roboto', fontSize: body)),
            Row(children: [
              Text("${widget.taskProgress} / ${widget.goal}",
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: h5,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple)),
              const SizedBox(width: 5),
              Text(widget.unit,
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: body))
            ])
          ],
        ),
      ]),
    );
  }
}
