import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/widgets/confirm_button.dart';
import 'package:vault/ui/features/auth/view/widgets/auth_text_field.dart';
import 'package:vault/ui/features/auth/viewmodel/auth_view_model.dart';

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
    final AppLocalizations? localizations = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(localizations!.appTitle), // TODO: Logo

              const SizedBox(height: 50),
              Text(
                localizations.welcome,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              // Username
              const SizedBox(height: 25),
              AuthTextField(
                controller: _usernameController,
                obscureText: false,
                hintText: localizations.usernameLabel,
                onChanged: (value) {
                  context.read<AuthViewModel>().updateLogin(value);
                },
              ),

              // Password
              const SizedBox(height: 25),
              AuthTextField(
                controller: _passwordController,
                obscureText: true,
                hintText: localizations.passwordLabel,
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
                      child: Text(localizations.forgotPasswordQuestion),
                      onTap: () {
                        context.read<AuthViewModel>().forgotPassword();
                      },
                    ),
                  ],
                ),
              ),

              Selector<AuthViewModel, bool>(
                selector: (_, avm) => avm.isLoginFormValid,
                builder: (context, isValid, _) {
                  return ConfirmButton(
                    text: localizations.loginAction,
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

              const SizedBox(height: 25),
              InkWell(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/register'),
                child: Text(
                  localizations.createNewAccountAction,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
