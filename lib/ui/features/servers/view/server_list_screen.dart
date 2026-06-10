import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/ui/core/widgets/profile_button.dart';
import 'package:vault/ui/features/servers/viewmodel/servers_viewmodel.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.vaultsScreenTitle),
        actions: const [ProfileButton()],
      ),
      drawer: SidebarMenu(),
      body: Consumer<ServersViewModel>(
        builder: (context, svm, child) {
          final servers = svm.servers;

          if (servers.isEmpty) {
            return RefreshIndicator(
              onRefresh: svm.refreshServers,
              child: ListView(physics: const AlwaysScrollableScrollPhysics()),
            );
          }

          return RefreshIndicator(
            onRefresh: svm.refreshServers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.dns),
                    subtitle: Text(localizations.vaultServerLabel),
                    title: Text(server.serverUrl),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        await context.read<ServersViewModel>().disconnect(
                          server.serverUrl,
                        );

                        if (context.mounted) {
                          context.read<ServersViewModel>().refreshServers();
                        }
                      },
                    ),

                    onTap: () {
                      Navigator.pushNamed(context, '/albums');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-server');

          if (context.mounted) {
            context.read<ServersViewModel>().refreshServers();
          }
        },
        tooltip: localizations.addServerAction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
