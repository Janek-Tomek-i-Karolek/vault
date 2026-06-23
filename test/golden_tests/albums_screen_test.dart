import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:vault/data/repositories/album/demo_api_album_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/theme/material_theme.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/view/albums_screen.dart';
import 'package:vault/utils/result.dart';

final _testConnection = ServerConnection(serverUrl: "hehe", apiKey: "pdw123");

final testAlbums = [
  Album(
    id: "1",
    name: "Album 1",
    assets: [],
    serverConnection: _testConnection,
    thumbnailId: null,
  ),
  Album(
    id: "2",
    name: "Album 2",
    assets: [],
    serverConnection: _testConnection,
    thumbnailId: null,
  ),
  Album(
    id: "3",
    name: "Album 3",
    assets: [],
    serverConnection: _testConnection,
    thumbnailId: null,
  ),
];

final testAlbumPreviews = [
  AlbumPreview(
    albumName: "Album 1",
    serverConnection: _testConnection,
    thumbnail: null,
  ),
  AlbumPreview(
    albumName: "Album 2",
    serverConnection: _testConnection,
    thumbnail: null,
  ),
  AlbumPreview(
    albumName: "Album 3",
    serverConnection: _testConnection,
    thumbnail: null,
  ),
];

class FakeAlbumRepository implements DemoApiAlbumRepository {
  @override
  Future<Result<Album>> addAlbum(
    ServerConnection serverConnection,
    String albumName,
  ) async {
    return Result.ok(testAlbums[0]);
  }

  @override
  Future<Result<void>> addAssetsToAlbum(
    ServerConnection serverConnection,
    Album album,
    List<Asset> assets,
  ) async {
    return Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    return Result.ok(null);
  }

  @override
  Future<Result<Album>> getAlbum(
    ServerConnection serverConnection,
    String id,
  ) async {
    return Result.ok(testAlbums[0]);
  }

  @override
  Future<Result<List<AlbumPreview>>> getAlbumPreviews(
    ServerConnection serverConnection,
  ) async {
    return Result.ok(testAlbumPreviews);
  }

  @override
  Future<Result<List<Album>>> getAlbums(
    ServerConnection serverConnection,
  ) async {
    return Result.ok(testAlbums);
  }

  @override
  Future<Result<void>> removeAssetFromAlbum(
    ServerConnection serverConnection,
    Album album,
    Asset asset,
  ) async {
    return Result.ok(null);
  }
}

class FakeConnectionRepository implements ConnectionRepository {
  @override
  Future<Result<ServerConnection>> connect({
    required String serverUrl,
    required String apiKey,
  }) async {
    return Result.ok(_testConnection);
  }

  @override
  Future<Result<void>> disconnect({required String serverUrl}) async {
    return Result.ok(null);
  }

  @override
  Future<Result<ServerConnection>> getConnectionByUrl({
    required String serverUrl,
  }) async {
    return Result.ok(_testConnection);
  }

  @override
  Future<Result<List<ServerConnection>>> getConnections() async {
    return Result.ok([_testConnection]);
  }

  @override
  Future<Result<List<String>>> getServers({required String userId}) async {
    return Result.ok(["abc"]);
  }

  @override
  Future<Result<bool>> testConnection({
    required ServerConnection connection,
  }) async {
    return Result.ok(true);
  }
}

void main() {
  final TextTheme textTheme = TextTheme();
  final MaterialTheme materialTheme = MaterialTheme(textTheme);

  final fakeAlbumsViewModel = AlbumsViewModel(
    albumRepository: FakeAlbumRepository(),
    connectionRepository: FakeConnectionRepository(),
  );

  testGoldens('AlbumsScreen Light Golden Test', (WidgetTester tester) async {
    await tester.pumpWidgetBuilder(
      MaterialApp(
        theme: materialTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ChangeNotifierProvider<AlbumsViewModel>.value(
          value: fakeAlbumsViewModel,
          child: const AlbumsScreen(),
        ),
      ),
    );

    await screenMatchesGolden(tester, "albums_screen_light", autoHeight: true);
  });

  testGoldens('AlbumsScreen Dark Golden Test', (WidgetTester tester) async {
    await tester.pumpWidgetBuilder(
      MaterialApp(
        theme: materialTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ChangeNotifierProvider<AlbumsViewModel>.value(
          value: fakeAlbumsViewModel,
          child: const AlbumsScreen(),
        ),
      ),
    );

    await screenMatchesGolden(tester, "albums_screen_dark", autoHeight: true);
  });
}
