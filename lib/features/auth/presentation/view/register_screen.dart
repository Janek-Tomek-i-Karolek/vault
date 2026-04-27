import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/features/auth/presentation/view/widgets/confirm_button.dart';
import 'package:vault/features/auth/presentation/view/widgets/auth_text_field.dart';
import 'package:vault/features/auth/presentation/viewmodel/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
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
              const Text("vault"), // TODO: Trzeba jakieś logo stworzyć

              const SizedBox(height: 50),
              const Text(
                "Witamy w kolonii",
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
                onChanged: (value) =>
                    context.read<AuthViewModel>().updateEmail(value),
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: usernameController,
                obscureText: false,
                hintText: "Nazwa Użytkownika",
                onChanged: (value) =>
                    context.read<AuthViewModel>().updateLogin(value),
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Hasło",
                onChanged: (value) =>
                    context.read<AuthViewModel>().updatePassword(value),
              ),

              const SizedBox(height: 10),
              Selector<AuthViewModel, Color>(
                selector: (_, avm) => avm.buttonColor,
                builder: (_, data, _) {
                  return ConfirmButton(
                    text: "Zarejestruj się",
                    buttonColor: data,
                    onTap: () => context.read<AuthViewModel>().register(),
                  );
                },
              ),

              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
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
