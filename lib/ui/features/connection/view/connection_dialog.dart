import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/features/connection/viewmodel/connection_viewmodel.dart';
import 'package:vault/ui/core/widgets/confirm_button.dart';
import 'package:vault/utils/result.dart';

class ConnectionDialog extends StatefulWidget {
  const ConnectionDialog({super.key});

  @override
  State<ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<ConnectionDialog> {
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
    final AppLocalizations? localizations = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logo_dev, size: 60),
            const SizedBox(height: 16),

            TextField(
              controller: _serverUrlController,
              onChanged: (value) =>
                  context.read<ConnectionViewModel>().updateServerUrl(value),
              decoration: InputDecoration(
                label: Text(localizations!.serverUrlLabel),
                prefixIcon: Icon(Icons.domain),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _apiKeyController,
              onChanged: (value) =>
                  context.read<ConnectionViewModel>().updateApiKey(value),
              decoration: InputDecoration(
                label: Text(localizations.apiKeyLabel),
                prefixIcon: Icon(Icons.key),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),

            const SizedBox(height: 24),

            Selector<ConnectionViewModel, bool>(
              selector: (_, cvm) => cvm.isConnectionFormValid,
              builder: (_, isValid, _) {
                return ConfirmButton(
                  text: AppLocalizations.of(context)!.connectAction,
                  onTap: isValid
                      ? () async {
                          final AppLocalizations? localizations =
                              AppLocalizations.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );
                          final vm = context.read<ConnectionViewModel>();

                          final success = await vm.connect(localizations);
                          if (context.mounted) Navigator.of(context).pop();

                          if (!success) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  vm.errorMessage ??
                                      localizations!.unknownErrorMessage,
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
