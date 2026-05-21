import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/data/repositories/album/demo_api_album_repository.dart';
import 'package:vault/data/repositories/album/mock_album_repository.dart';
import 'package:vault/data/repositories/asset/mock_asset_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/view/album_screen.dart';
import 'package:vault/ui/features/albums/view/albums_screen.dart';
import 'package:vault/ui/features/auth/view/login_screen.dart';
import 'package:vault/ui/features/auth/view/register_screen.dart';
import 'package:vault/ui/features/auth/viewmodel/auth_view_model.dart';
import 'package:vault/ui/core/theme/material_theme.dart';
import 'package:vault/ui/features/user/view/profile_screen.dart';
import 'package:vault/ui/features/connection/view/connection_screen.dart';
import 'package:vault/ui/features/connection/viewmodel/connection_viewmodel.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';
import 'package:vault/utils/secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => ConnectionViewModel(
            connectionRepository: ImmichConnectionRepository(),
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
        home: Selector<ConnectionViewModel, ConnectionStatus>(
          selector: (_, viewModel) => viewModel.status,
          builder: (_, status, _) {
            return switch (status) {
              ConnectionStatus.loading => const CircularProgressIndicator(),
              ConnectionStatus.connected => const AlbumsScreen(),
              ConnectionStatus.disconnected => const ConnectionScreen(),
            };
          },
        ),
        routes: {
          "/login": (context) => LoginScreen(),
          "/register": (context) => RegisterScreen(),
          "/albums": (context) => AlbumsScreen(),
          "/connect": (context) => ConnectionScreen(),
        },
      ),
    );
  }
}
