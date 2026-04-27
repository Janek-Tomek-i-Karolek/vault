import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/features/auth/presentation/view/widgets/confirm_button.dart';
import 'package:vault/features/auth/presentation/view/widgets/auth_text_field.dart';
import 'package:vault/features/auth/presentation/viewmodel/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
              const Text("vault"), // TODO: Logo

              const SizedBox(height: 50),
              const Text(
                "Witamy w kolonii",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Username
              const SizedBox(height: 25),
              AuthTextField(
                controller: _usernameController,
                obscureText: false,
                hintText: "Nazwa Użytkownika",
                onChanged: (value) {
                  context.read<AuthViewModel>().updateLogin(value);
                },
              ),

              // Password
              const SizedBox(height: 25),
              AuthTextField(
                controller: _passwordController,
                obscureText: true,
                hintText: "Hasło",
                onChanged: (value) {
                  context.read<AuthViewModel>().updatePassword(value);
                },
              ),

              // Forgot Password
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Text("Nie pamiętasz hasła?"),
                      onTap: () {
                        context.read<AuthViewModel>().forgotPassword();
                      },
                    ),
                  ],
                ),
              ),

              Selector<AuthViewModel, Color>(
                selector: (_, avm) => avm.buttonColor,
                builder: (_, data, _) {
                  return ConfirmButton(
                    text: "Zaloguj się",
                    buttonColor: data,
                    onTap: () => context.read<AuthViewModel>().login(),
                  );
                },
              ),

              const SizedBox(height: 25),
              InkWell(
                onTap: () {},
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
