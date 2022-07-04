import 'package:fitdle/constants+utility.dart';
import 'package:flutter/cupertino.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
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
              style: const TextStyle(fontFamily: 'Roboto',
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

  signupButtonPressed() {
    Navigator.popAndPushNamed(context, "personal_info");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB (regular, topPadding, regular, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            fitdleText(createAccount, h1),
            const SizedBox(height: large),
            fitdleTextField(email),
            const SizedBox(height: regular),
            fitdleTextField(password),
            const SizedBox(height: regular),
            fitdleTextField(confirmPassword),
            const SizedBox(height: regular),
            primaryButton(signup, signupButtonPressed),
            SizedBox(height: size.height / 6),
            loginButton()
          ],
        ),
      ),
    );
  }
}
