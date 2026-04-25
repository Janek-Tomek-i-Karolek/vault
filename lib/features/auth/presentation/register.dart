import 'package:flutter/material.dart';
import 'package:vault/features/auth/presentation/widgets/confirm_button.dart';
import 'package:vault/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final ValueNotifier<Color> buttonColorNotifier;

  @override
  void initState() {
    super.initState();
    buttonColorNotifier = ValueNotifier<Color>(Colors.grey);
    emailController.addListener(_updateButtonColor);
    usernameController.addListener(_updateButtonColor);
    passwordController.addListener(_updateButtonColor);
  }

  void _updateButtonColor() {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      buttonColorNotifier.value = const Color.fromRGBO(86, 201, 115, 1);
    } else {
      buttonColorNotifier.value = Colors.grey;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    buttonColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.yellow,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("vault"),

              const SizedBox(height: 50),
              const Text(
                "joł madafaka!",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: emailController,
                obscureText: false,
                hintText: "Adres E-mail",
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: usernameController,
                obscureText: false,
                hintText: "Nazwa Użytkownika",
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Hasło",
              ),

              const SizedBox(height: 10),
              ConfirmButton(
                text: "Zarejestruj się",
                colorNotifier: buttonColorNotifier,
                onTap: () {
                  print("kliknieto zarejestruj sie");
                },
              ),

              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  print("Załóż nowe konto tapped");
                },
                child: const Text(
                  "Zaloguj się",
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
