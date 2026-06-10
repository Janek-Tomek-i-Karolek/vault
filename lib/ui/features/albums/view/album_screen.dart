import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/widgets/profile_button.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';
import 'package:vault/ui/features/albums/view/asset_viewer.dart';

class AlbumScreen extends StatefulWidget {
  final String albumId;
  final ServerConnection serverConnection;

  const AlbumScreen({
    super.key,
    required this.albumId,
    required this.serverConnection,
  });

  @override
  State<StatefulWidget> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  ImageProvider? _cover;
  ImageProvider? _coverThumbhash;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlbumViewModel>().loadAlbum(
        widget.serverConnection,
        widget.albumId,
      );
    });
  }

  bool _isCover(Album album, bool justEntered) {
    if (justEntered) {
      _cover = null;
    }
    if (_cover != null) {
      return true;
    }
    if (album.thumbnailId != null) {
      for (var asset in album.assets) {
        if (asset.id == album.thumbnailId) {
          _cover = NetworkImage(asset.previewUri, headers: asset.headers);
          _coverThumbhash = asset.thumbImageProvider;
          break;
        }
      }
    }
    return _cover != null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlbumViewModel>();
    final theme = Theme.of(context);
    final AppLocalizations? localizations = AppLocalizations.of(context);

    final String appBarTitle = switch ((
      viewModel.isLoading,
      viewModel.justEntered,
      viewModel.album,
    )) {
      (true, true, _) => localizations!.loadingIndicator,
      (_, _, final album?) => album.name,
      _ => localizations!.albumScreenTitle,
    };
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<AlbumViewModel>().loadAlbum(
            widget.serverConnection,
            widget.albumId,
          );
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: switch ((
          viewModel.isLoading,
          viewModel.album,
          viewModel.error,
          viewModel.justEntered,
        )) {
          (true, _, _, true) => const Center(
            child: CircularProgressIndicator(),
          ),
          (_, _, final Exception e, _) => Center(
            child: Text(localizations!.genericErrorMessage(e.toString())),
          ),
          (_, final album?, _, final justEntered) => CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 400.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(appBarTitle),
                  background: _isCover(album, justEntered)
                      ? Stack(
                          children: [
                            // 1. The Background Image
                            Positioned.fill(
                              child: Image(
                                image: _cover!,
                                fit: BoxFit.cover,
                                frameBuilder:
                                    (
                                      context,
                                      child,
                                      int? frame,
                                      bool wasSynchronouslyLoaded,
                                    ) {
                                      if (wasSynchronouslyLoaded ||
                                          frame != null) {
                                        return child;
                                      }
                                      final widget = Image(
                                        image: _coverThumbhash!,
                                        fit: BoxFit.cover,
                                      );
                                      return widget;
                                    },
                              ),
                            ),
                            // 2. The Nice Color Overlay (with opacity/gradient)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.colorScheme.surfaceContainerHighest
                                          .withOpacity(0.2),
                                      theme.colorScheme.surfaceContainerHighest
                                          .withOpacity(0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const FlutterLogo(),
                ),
              ),
              SliverMasonryGrid(
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final asset = album.assets[index];
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: AssetTile(
                      asset: asset,
                      onAssetSelected: (asset) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AssetViewer(
                            serverConnection: widget.serverConnection,
                            album: album,
                            assets: album.assets,
                            startIndex: index,
                          ),
                        ),
                      ),
                    ),
                  );
                }, childCount: album.assets.length),
              ),
            ],
          ),

          // MasonryGridView.builder(
          //     itemCount: album.assets.length,
          //     cacheExtent: ScrollCacheExtent.viewport(3).value,
          //     gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //     ),
          //   ),
          _ => Text(localizations!.unknownErrorMessage),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<AlbumViewModel>().addAsset(
            widget.albumId,
            widget.serverConnection,
          );
        },
        tooltip: localizations!.addPhotosAction,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AssetTile extends StatelessWidget {
  final Asset asset;
  final void Function(Asset)? onAssetSelected;

  const AssetTile({super.key, required this.asset, this.onAssetSelected});

  @override
  Widget build(BuildContext context) {
    final tileSize = _tileSize(
      originalWidth: asset.width,
      originalHeight: asset.height,
    );
    final double width = tileSize["width"]!;
    final double height = tileSize["height"]!;
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.network(
          asset.thumbnailUri,
          headers: asset.headers,
          fit: BoxFit.cover,
          frameBuilder:
              (context, child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  return GestureDetector(
                    onTap: () => onAssetSelected?.call(asset),
                    child: child,
                  );
                }
                final widget = Image(
                  image: asset.thumbImageProvider!,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                );
                return widget;
              },
        ),
      ),
    );
  }

  Map<String, double> _tileSize({int? originalWidth, int? originalHeight}) {
    if (originalWidth == null || originalHeight == null) {
      return {"width": 100, "height": 200};
    }
    double aspectRatio = originalWidth / originalHeight;
    if (aspectRatio == 1 || aspectRatio > 1) {
      return {"width": 100, "height": 200};
    } else {
      return {"width": 100, "height": 300};
    }
  }
}
