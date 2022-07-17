import 'dart:async';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/common.dart';
import 'login_vm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginVM _loginVM;
  late StreamSubscription _navigationSubscription;
  late StreamSubscription _errorSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loginVM = LoginVM();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _loginVM.dispose();
    _navigationSubscription.cancel();
    _errorSubscription.cancel();
  }

  _listen() {
    _navigationSubscription = _loginVM.done.listen((value) {
      Navigator.popAndPushNamed(context, "dashboard");
    });

    _errorSubscription = _loginVM.error.listen((msg) {
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: size.height/12, left: regular, right: regular),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fitdleText(appName, h1),
                SizedBox(height: size.height / 6),
                fitdleTextField(emailController, email),
                const SizedBox(height: regular),
                fitdlePasswordField(passwordController, password),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                      forgotPassword,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: hint)
                  ),
                ),
                const SizedBox(height: regular),
                primaryButton(login, loginButtonPressed),
                // Push create account button to bottom of screen
                SizedBox(height: size.height / 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        noAccount
                    ),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.black12)
                        ),
                        onPressed: signupButtonPressed,
                        child: const Text(
                          signup,
                          style: TextStyle(fontFamily: 'Roboto',
                              fontSize: hint,
                              color: Colors.purple),
                        )
                    )
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  loginButtonPressed() {
    setState(() {
      _isLoading = true;
      
    });
    _loginVM.login(emailController.text, passwordController.text);
    _isLoading = false;
  }

  signupButtonPressed() {
    Navigator.pushNamed(context, "create_account");
  }
}

