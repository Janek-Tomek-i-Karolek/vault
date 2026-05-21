import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/features/connection/viewmodel/connection_viewmodel.dart';
import 'package:vault/ui/core/widgets/confirm_button.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  late final TextEditingController _serverUrlController =
      TextEditingController();
  late final TextEditingController _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _serverUrlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.logo_dev, size: 80),
              const SizedBox(height: 8),

              // Server URL
              TextField(
                controller: _serverUrlController,
                onChanged: (value) {
                  context.read<ConnectionViewModel>().updateServerUrl(value);
                },
                decoration: const InputDecoration(
                  label: Text("Server URL"),
                  prefixIcon: Icon(Icons.domain),
                ),
              ),

              const SizedBox(height: 24),

              // Api Key
              TextField(
                controller: _apiKeyController,
                onChanged: (value) {
                  context.read<ConnectionViewModel>().updateApiKey(value);
                },
                decoration: const InputDecoration(
                  label: Text("Api Key"),
                  prefixIcon: Icon(Icons.key),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              Selector<ConnectionViewModel, bool>(
                selector: (_, cvm) => cvm.isConnectionFormValid,
                builder: (_, isValid, _) {
                  return ConfirmButton(
                    text: "Connect",
                    onTap: isValid
                        ? () => context.read<ConnectionViewModel>().connect()
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
