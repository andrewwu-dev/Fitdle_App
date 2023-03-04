import 'dart:async';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/redeem/redeem_vm.dart';
import 'package:fitdle/pages/redeem/reward_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({Key? key}) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  late final RedeemVM _redeemVM;
  late StreamSubscription _errorSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _redeemVM = RedeemVM();
    _redeemVM.getRewards().then(
      (_) {
        _isLoading = false;
        setState(() {});
      },
    );
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _redeemVM.dispose();
    _errorSubscription.cancel();
  }

  _listen() {
    _errorSubscription = _redeemVM.error.listen((msg) {
      _isLoading = false;
      setState(() {});
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return fitdleSpinner();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: appBarColor,
        toolbarHeight: 100,
        titleSpacing: appBarPadding,
        title: fitdleText(redeem, h2),
      ),
      body: body(size),
    );
  }

  body(Size size) {
    if (_redeemVM.rewards.isEmpty) {
      return Center(
        child: fitdleText(noRewardsAvailable, h3),
      );
    } else {
      return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(regular, 0, regular, 0),
        child: Column(children: [
          Image.asset(redeemSplash, height: size.width * 0.5),
          const SizedBox(height: small),
          Row(
            children: [
              Image.asset(coin, height: 30),
              fitdleText("${_redeemVM.user.numPoints}", h5),
            ],
          ),
          const SizedBox(height: regular),
          Expanded(
            child: ListView.separated(
                primary: false,
                itemCount: _redeemVM.rewards.length,
                itemBuilder: (BuildContext context, int index) {
                  final reward = _redeemVM.rewards[index];
                  return GestureDetector(
                    onTap: () {
                      _redeemVM.redeemReward(index, reward.id).then((code) {
                        if (code == null) return;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title:
                                  fitdleText("Code", h4, align: TextAlign.left),
                              content: fitdleText(code, h5),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child:
                                      fitdleText(ok, h4, color: Colors.purple),
                                )
                              ]),
                        );
                        setState(() {});
                      });
                    },
                    child: RewardBox(
                        imgURL: reward.imgURL,
                        title: reward.title,
                        description: reward.description ?? "",
                        cost: reward.cost),
                  );
                },
                separatorBuilder: (
                  BuildContext context,
                  int index,
                ) =>
                    const SizedBox(height: 20)),
          )
        ]),
      );
    }
  }
}
