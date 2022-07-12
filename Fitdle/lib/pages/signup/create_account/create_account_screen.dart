import 'dart:async';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/signup/create_account/create_account_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/common.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late final CreateAccountVM _createAccountVM;
  late StreamSubscription _navigationSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _createAccountVM = CreateAccountVM();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _createAccountVM.dispose();
    _navigationSubscription.cancel();
  }

  _listen() {
    _navigationSubscription = _createAccountVM.done.listen((value) {
      Navigator.pushNamed(context, "personal_info");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: _createAccountVM.subject.stream,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            Fluttertoast.showToast(
              msg: snapshot.error.toString(),
              toastLength: Toast.LENGTH_SHORT
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            // TODO: Wrap in SingleChildScrollView so keyboard doesn't cause overflow
            // TODO: Figure out why CircularProgressIndicator is not appearing
            body: Stack (
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB (regular, topPadding, regular, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      fitdleText(createAccount, h1),
                      const SizedBox(height: large),
                      fitdleTextField(emailController, email),
                      const SizedBox(height: regular),
                      fitdlePasswordField(passwordController, password),
                      const SizedBox(height: regular),
                      fitdlePasswordField(confirmPasswordController, confirmPassword),
                      const SizedBox(height: regular),
                      primaryButton(signup, signupButtonPressed, isEnabled: !_isLoading),
                      SizedBox(height: size.height / 6),
                      loginButton()
                    ],
                  ),
                ),
                Visibility(
                    visible: _isLoading,
                    child: const CircularProgressIndicator()
                )
              ],
            )
          );
        }
    );
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
            alreadyHaveAccount
        ),
        TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.black12)
            ),
            onPressed: loginButtonPressed,
            child: const Text(
              login,
              style: TextStyle(fontFamily: 'Roboto',
                  fontSize: hint,
                  color: Colors.purple),
            )
        )
      ],
    );
  }

  loginButtonPressed() {
    Navigator.pop(context);
  }

  signupButtonPressed() async {
    _isLoading = true;
    _createAccountVM.firebaseSignup(emailController.text, passwordController.text);
    _isLoading = false;
  }
}
