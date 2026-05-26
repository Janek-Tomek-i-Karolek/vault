import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/core/widgets/confirm_button.dart';
import 'package:vault/ui/features/auth/view/widgets/auth_text_field.dart';
import 'package:vault/ui/features/auth/viewmodel/auth_view_model.dart';

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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("vault"), // TODO: Trzeba jakieś logo stworzyć

              const SizedBox(height: 50),
              const Text(
                "Witamy w kolonii",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: emailController,
                obscureText: false,
                hintText: "E-mail address",
                onChanged: (value) =>
                    context.read<AuthViewModel>().updateEmail(value),
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: usernameController,
                obscureText: false,
                hintText: "Username",
                onChanged: (value) =>
                    context.read<AuthViewModel>().updateLogin(value),
              ),

              const SizedBox(height: 25),
              AuthTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Password",
                onChanged: (value) =>
                    context.read<AuthViewModel>().updatePassword(value),
              ),

              const SizedBox(height: 10),
              Selector<AuthViewModel, bool>(
                selector: (_, avm) => avm.isRegisterFormValid,
                builder: (context, isValid, _) {
                  return ConfirmButton(
                    text: "Register",
                    onTap: isValid
                        ? () async {
                            await context.read<AuthViewModel>().register();
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/albums');
                          }
                        : null,
                  );
                },
              ),

              const SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.popAndPushNamed(context, '/login'),
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
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
