import 'package:flutter/material.dart';
import 'package:vault/l10n/vault_localizations.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = AppLocalizations.of(context);
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 70,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child: Text(
                localizations!.navBarTitle,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: Text(localizations.albumsNavBarEntry),
            onTap: () => Navigator.pushNamed(context, '/albums'),
          ),
          ListTile(
            leading: const Icon(Icons.dns),
            title: Text(localizations.serverListNavBarEntry),
            onTap: () => Navigator.pushNamed(context, '/server-list'),
          ),
          // Template for future nav options
          // ListTile(
          //  leading: const Icon(),
          //  title: const Text(''),
          //  onTap: () => Navigator.pushNamed(context, '/route'),
          //),
        ],
      ),
    );
  }
}
