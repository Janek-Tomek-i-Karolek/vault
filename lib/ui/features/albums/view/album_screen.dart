import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/ui/core/widgets/profile_button.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';
import 'package:vault/ui/features/albums/view/asset_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlbumViewModel>();

    final String appBarTitle = switch ((viewModel.isLoading, viewModel.album)) {
      (true, _) => "Loading...",
      (_, final album?) => album.name,
      _ => "Album",
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        actions: const [ProfileButton()],
      ),
      body: switch ((viewModel.isLoading, viewModel.album, viewModel.error)) {
        (true, _, _) => const Center(child: CircularProgressIndicator()),
        (_, _, final Exception e) => Center(child: Text("Error: $e")),
        (_, final album?, _) => MasonryGridView.builder(
          itemCount: album.assets.length,
          cacheExtent: 500.0,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final asset = album.assets[index];
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: AssetTile(
                asset: asset,
                onAssetSelected: (asset) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AssetScreen(asset: asset),
                    // builder: (context) => PhotoView(
                    //   imageProvider: NetworkImage(
                    //     asset.previewUri,
                    //     headers: asset.headers,
                    //   ),
                    //   loadingBuilder: (context, progress) => Center(
                    //     child: SizedBox(
                    //       width: 20.0,
                    //       height: 20.0,
                    //       child: CircularProgressIndicator(
                    //         value: progress == null
                    //             ? null
                    //             : progress.cumulativeBytesLoaded /
                    //                   progress.expectedTotalBytes!,
                    //       ),
                    //     ),
                    //   ),
                    //   minScale: PhotoViewComputedScale.contained * 1.0,
                    //   gaplessPlayback: true,
                    // ),
                  ),
                ),
              ),
            );
          },
        ),
        _ => const Text("Something went wrong!"),
      },
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
    return SizedBox(
      width: tileSize["width"],
      height: tileSize["height"],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: GestureDetector(
          onTap: () => onAssetSelected?.call(asset),
          child: Image.network(
            asset.thumbnailUri,
            headers: asset.headers,
            fit: BoxFit.cover,
          ),
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
