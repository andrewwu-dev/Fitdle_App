import 'package:fitdle/components/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';

class RewardBox extends StatefulWidget {
  String? imgURL;
  String title;
  String? description;
  int cost;

  RewardBox({Key? key, this.imgURL, required this.title, this.description, required this.cost}) : super(key: key);

  @override
  State<RewardBox> createState() => _RewardBoxState();
}

class _RewardBoxState extends State<RewardBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "lib/resources/images/gift.jpg",
            height: 45,
            width: 49,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fitdleText(widget.title, h5),
              // If null description is set to ""
              fitdleText(widget.description, body, weight: FontWeight.w300)
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: fitdleText(widget.cost.toString(), hint, color: Colors.purple)
          )
        ],
      )
    );
  }
}
