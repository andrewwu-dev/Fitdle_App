import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';

class RewardBox extends StatefulWidget {
  final String? imgURL;
  final String title;
  final String? description;
  final int cost;

  const RewardBox(
      {Key? key,
      this.imgURL,
      required this.title,
      this.description,
      required this.cost})
      : super(key: key);

  @override
  State<RewardBox> createState() => _RewardBoxState();
}

class _RewardBoxState extends State<RewardBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              rewardImage(),
              Flexible(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fitdleText(widget.title, h5),
                  const SizedBox(height: 10),
                  fitdleText(widget.description, 10.0,
                      weight: FontWeight.w300, align: TextAlign.center)
                ],
              )),
              const SizedBox(width: 5),
              Align(
                  alignment: Alignment.bottomRight,
                  child: fitdleText(widget.cost.toString(), hint,
                      color: Colors.purple))
            ],
          ),
        ));
  }

  Image rewardImage() {
    if (widget.imgURL == null) {
      return Image.asset("lib/resources/images/gift.jpg",
          height: 45, width: 49);
    } else {
      return Image.network(widget.imgURL!, height: 60);
    }
  }
}
