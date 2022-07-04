import 'package:fitdle/constants+utility.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  signupButtonPressed() {
    Navigator.pushNamed(context, "create_account");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: topPadding, left: regular, right: regular),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                  appName,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: h1)
              ),
              const SizedBox(height: 100),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: email
                ),
              ),
              const SizedBox(height: regular),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: password
                ),
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                    forgotPassword,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: hint)
                ),
              ),
              SizedBox(height: regular),
              CupertinoButton(
                  color: Colors.purple,
                  onPressed: () {},   // TODO: Add button function
                  child: const Text(
                    login,
                    style: TextStyle(
                        fontFamily: 'Roboto', fontSize: button),
                  )
              ),
              // Push create account button to bottom of screen
              SizedBox(height: size.height / 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
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
                        style: const TextStyle(fontFamily: 'Roboto',
                            fontSize: hint,
                            color: Colors.purple),
                      )
                  )
                ],
              )
            ]
        ),
      ),
    );
  }
}

