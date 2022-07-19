import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/redeem/redeem_vm.dart';
import 'package:fitdle/pages/redeem/reward_box.dart';
import 'package:flutter/material.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({Key? key}) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  late final RedeemVM _redeemVM;
  //late StreamSubscription _errorSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _redeemVM = RedeemVM();
    _redeemVM.getRewards().then((_) {
      _isLoading = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _redeemVM.dispose();
    //_errorSubscription.cancel();
  }

  // TODO: Find a way to refresh/redraw when this page becomes visible again

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return fitdleSpinner();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: const Text(
                redeem,
                style: TextStyle(fontFamily: 'Roboto', fontSize: h2, color: Colors.black),
            ),
      ),
      body: body(size)
    );
  }

  body(size) {
    if(_redeemVM.rewards.isEmpty) {
      return Center(
        child: fitdleText(noRewardsAvailable, h3),
      );
    } else {
      return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(regular, regular, regular, 0),
        child: Column(
          children: [
            fitdleText("Your balance: ${_redeemVM.user.numPoints}", h2),
            SizedBox(height: regular),
            Expanded(child: ListView.separated(
                itemCount: _redeemVM.rewards.length,
                itemBuilder: (BuildContext context, int index) {
                  final reward = _redeemVM.rewards[index];
                  return RewardBox(
                      imgURL: reward.imgURL,
                      title: reward.title,
                      description: reward.description ?? "",
                      cost: reward.cost
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20)
              )
            )
          ],
        )
      );
    }
  }
}
