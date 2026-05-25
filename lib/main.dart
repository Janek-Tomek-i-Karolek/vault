import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/data/repositories/album/demo_api_album_repository.dart';
import 'package:vault/data/repositories/album/mock_album_repository.dart';
import 'package:vault/data/repositories/asset/mock_asset_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/view/album_screen.dart';
import 'package:vault/ui/features/albums/view/albums_screen.dart';
import 'package:vault/ui/features/auth/view/login_screen.dart';
import 'package:vault/ui/features/auth/view/register_screen.dart';
import 'package:vault/ui/features/auth/viewmodel/auth_view_model.dart';
import 'package:vault/ui/core/theme/material_theme.dart';
import 'package:vault/ui/features/servers/view/server_list_screen.dart';
import 'package:vault/ui/features/servers/viewmodel/servers_viewmodel.dart';
import 'package:vault/ui/features/user/view/profile_screen.dart';
import 'package:vault/ui/features/connection/view/connection_dialog.dart';
import 'package:vault/ui/features/connection/viewmodel/connection_viewmodel.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';
import 'package:vault/utils/secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => ServersViewModel(
            connectionRepository:
                LocalConnectionRepository(), // TODO: Try sharing this repo
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectionViewModel(
            connectionRepository:
                LocalConnectionRepository(), // TODO: Try sharing this repo
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AlbumsViewModel(
            albumRepository: MockAlbumRepository(),
            assetRepository: MockAssetRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AlbumViewModel(albumRepository: DemoApiAlbumRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'vault',
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
        themeMode: ThemeMode.system,
        // home: const ServerListScreen(),
        home: AlbumScreen(
          serverConnection: ServerConnection(
            serverUrl: Uri.https('demo.immich.app', "").toString(),
            // NOTE: na docsach szybko deaktywują klucze skurczybyki
            apiKey: "PP1hLvOURSgbnx7FIjh3Zu9KvJbSxjQKFzUAxXjxE",
          ),
          albumId: "f0b9c2d8-e4cc-4bdb-9c36-cda764479bd0",
        ),
        routes: {
          "/login": (context) => LoginScreen(),
          "/register": (context) => RegisterScreen(),
          "/albums": (context) => AlbumsScreen(),
          "/server-list-screen": (context) => ServerListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/add-server') {
            return PageRouteBuilder(
              opaque: false,
              barrierDismissible: true,
              barrierColor: Colors.black,
              pageBuilder: (_, _, _) {
                return const ConnectionDialog();
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
