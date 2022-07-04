import 'package:fitdle/constants+utility.dart';
import 'package:flutter/cupertino.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
            const SizedBox(height: regular),
            const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: confirmPassword
              ),
            ),
            const SizedBox(height: regular),
            CupertinoButton(
                color: Colors.purple,
                onPressed: () {},   // TODO: Add button function
                child: fitdleText(signup, button)
            ),
            SizedBox(height: size.height / 6),
            loginButton()
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Already have an account?"
        ),
        TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.black12)
            ),
            onPressed: loginButtonPressed,
            child: const Text(
              "Sign in",
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
}
