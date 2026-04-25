import 'package:flutter/material.dart';
import 'package:vault/features/auth/presentation/widgets/confirm_button.dart';
import 'package:vault/features/auth/presentation/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final ValueNotifier<Color> buttonColorNotifier;

  @override
  void initState() {
    super.initState();
    buttonColorNotifier = ValueNotifier<Color>(Colors.grey);
    usernameController.addListener(_updateButtonColor);
    passwordController.addListener(_updateButtonColor);
  }

  void _updateButtonColor() {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      buttonColorNotifier.value = const Color.fromRGBO(86, 201, 115, 1);
    } else {
      buttonColorNotifier.value = Colors.grey;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    buttonColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("vault"),

              const SizedBox(height: 50),
              const Text(
                "yo madafaka!",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //Username
              const SizedBox(height: 25),
              AuthTextField(
                controller: usernameController,
                obscureText: false,
                hintText: "Nazwa Użytkownika",
              ),

              //Password
              const SizedBox(height: 25),
              AuthTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Hasło",
              ),

              //Forgot Password
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Text("Nie pamiętasz hasła?"),
                      onTap: () {
                        print("forgot password");
                      },
                    ),
                  ],
                ),
              ),

              ConfirmButton(
                text: "Zaloguj się",
                colorNotifier: buttonColorNotifier,
                onTap: () {
                  if (usernameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    print(
                      "Logging in with username: ${usernameController.text}",
                    );
                  } else {
                    print("Please fill in all fields.");
                  }
                },
              ),


              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  print("Załóż nowe konto tapped");
                },
                child: const Text(
                  "Załóż nowe konto",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 14, 140, 243),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
