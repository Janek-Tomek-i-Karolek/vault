import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 70,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child: Text('Menu', style: TextStyle(fontSize: 24)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Albums'),
            onTap: () => Navigator.pushNamed(context, '/albums'),
          ),
          ListTile(
            leading: const Icon(Icons.dns),
            title: const Text('Server List'),
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
