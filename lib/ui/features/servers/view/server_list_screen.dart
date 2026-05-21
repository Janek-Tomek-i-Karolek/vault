import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/features/servers/viewmodel/servers_viewmodel.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Vaults')),

      body: Consumer<ServersViewModel>(
        builder: (context, viewModel, child) {
          final servers = viewModel.servers;

          if (servers.isEmpty) {
            return RefreshIndicator(
              onRefresh: viewModel.refreshServers,
              child: ListView(physics: const AlwaysScrollableScrollPhysics()),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.refreshServers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.dns),
                    subtitle: Text("Vault Server"),
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
        tooltip: 'Add Server',
        child: const Icon(Icons.add),
      ),
    );
  }
}
