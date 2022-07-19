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
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          rewardImage(),
          Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  fitdleText(widget.title, h5),
                  // If null description is set to ""
                  fitdleText(widget.description, 10.0, weight: FontWeight.w300)
                ],
              )
          ),
          SizedBox(width: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: fitdleText(widget.cost.toString(), hint, color: Colors.purple)
          )
        ],
      )
    );
  }

  Image rewardImage(){
    if(widget.imgURL == null) {
      return Image.asset("lib/resources/images/gift.jpg", height: 45, width: 49);
    } else {
      return Image.network(widget.imgURL!, fit: BoxFit.fitHeight);
    }
  }
}