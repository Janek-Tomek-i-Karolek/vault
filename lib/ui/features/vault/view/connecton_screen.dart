import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/features/vault/viewmodel/vault_viewmodel.dart';
import 'package:vault/ui/core/widgets/confirm_button.dart';

class ConnectonScreen extends StatefulWidget {
  const ConnectonScreen({super.key});

  @override
  State<ConnectonScreen> createState() => _ConnectonScreenState();
}

class _ConnectonScreenState extends State<ConnectonScreen> {
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
      appBar: AppBar(
        title: const Text("Connect to Vault"),
        actions: [TextButton(onPressed: () {}, child: const Text("Save"))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 80),
              const SizedBox(height: 8),

              // Server URL
              TextField(
                controller: _serverUrlController,
                onChanged: (value) {
                  context.read<VaultViewModel>().updateServerUrl(value);
                },
                decoration: const InputDecoration(
                  label: Text("Server URL"),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 24),

              // Api Key
              TextField(
                controller: _apiKeyController,
                onChanged: (value) {
                  context.read<VaultViewModel>().updateApiKey(value);
                },
                decoration: const InputDecoration(
                  label: Text("Api Key"),
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              Selector<VaultViewModel, bool>(
                selector: (_, vvm) => vvm.isConnectionFormValid,
                builder: (_, isValid, _) {
                  return ConfirmButton(
                    text: "Connect",
                    onTap: isValid
                        ? () => context.read<VaultViewModel>().connect()
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
