import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/features/connection/viewmodel/connection_viewmodel.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      child: FilledButton(
        onPressed: () => context.read<ConnectionViewModel>().disconnect(),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text("Disconnect"),
      ),
    );
  }
}
