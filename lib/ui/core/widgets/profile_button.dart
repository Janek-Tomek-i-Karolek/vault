import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: () {
        Navigator.pushNamed(context, '/profile');
      },
    );
  }
}
