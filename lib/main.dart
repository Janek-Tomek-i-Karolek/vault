import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vault/data/repositories/album/demo_api_album_repository.dart';
import 'package:vault/data/repositories/asset/immich_asset_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/ui/features/albums/viemodel/add_album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/asset_viewmodel.dart';
import 'package:vault/ui/features/albums/view/add_album_dialog.dart';
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
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => AddAlbumViewModel(
            connectionRepository: LocalConnectionRepository(),
          ),
        ),
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
          create: (_) => AssetViewModel(
            albumRepository: DemoApiAlbumRepository(),
            assetRepository: ImmichAssetRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AlbumsViewModel(
            albumRepository: DemoApiAlbumRepository(),
            connectionRepository: LocalConnectionRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AlbumViewModel(
            albumRepository: DemoApiAlbumRepository(),
            assetRepository: ImmichAssetRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'vault',
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,

        home: AlbumsScreen(),
        routes: {
          "/login": (context) => LoginScreen(),
          "/register": (context) => RegisterScreen(),
          "/albums": (context) => AlbumsScreen(),
          "/server-list": (context) => ServerListScreen(),
          "/profile": (context) => ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/add-server') {
            return PageRouteBuilder(
              opaque: false,
              barrierDismissible: true,
              barrierColor: Colors.black54,
              pageBuilder: (_, _, _) {
                return const ConnectionDialog();
              },
            );
          } else if (settings.name == "/add-album") {
            return PageRouteBuilder(
              opaque: false,
              barrierDismissible: true,
              barrierColor: Colors.black54,
              pageBuilder: (_, _, _) {
                return const AddAlbumDialog();
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
