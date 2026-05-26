import 'package:flutter/material.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/domain/user/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: viewmodel
  final String _currentEmail = User.email;
  final String _currentUsername = User.username;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: _currentUsername);
    _emailController = TextEditingController(text: _currentEmail);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [TextButton(onPressed: () {}, child: const Text("Save"))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 80),
              const SizedBox(height: 8),

              Text(
                _currentUsername,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 40),

              // Username
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text("Username"),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 24),

              // Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const Spacer(),

              OutlinedButton(onPressed: () {}, child: const Text("Sign Out")),
            ],
          ),
        ),
      ),
    );
  }
}
