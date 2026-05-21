import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';

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
    context.read<AlbumViewModel>().loadAlbum(
      widget.serverConnection,
      widget.albumId,
    );
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
      appBar: AppBar(title: Text(appBarTitle), centerTitle: true),
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
            final tileSize = _tileSize(
              originalWidth: asset.width,
              originalHeight: asset.height,
            );

            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: AssetTile(
                "${album.serverConnection.serverUrl}/api/assets/${asset.id}/thumbnail?size=thumbnail",
                // height: max(asset.height?.toDouble() ?? double.nan, 200),
                // width: asset.width?.toDouble(),
                width: tileSize["width"],
                height: tileSize["height"],
                headers: {
                  "x-api-key": album.serverConnection.apiKey,
                  "content-type": "application/json",
                },
              ),
            );
          },
        ),
        _ => const Text("Something went wrong!"),
      },
    );
  }

  Map<String, double> _tileSize({int? originalWidth, int? originalHeight}) {
    if (originalWidth == null || originalHeight == null) {
      return {"width": 100, "height": 200};
    }
    double aspectRatio = originalWidth / originalHeight;
    if (aspectRatio == 1 || aspectRatio < 1) {
      return {"width": 100, "height": 200};
    } else {
      return {"width": 100, "height": 300};
    }
  }
}

class AssetTile extends StatelessWidget {
  final String uri;
  final double? width;
  final double? height;
  final Map<String, String>? headers;
  final VoidCallback? onTap;

  const AssetTile(
    this.uri, {
    super.key,
    this.width,
    this.height,
    this.headers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: GestureDetector(
          onTap: onTap,
          child: Image.network(uri, headers: headers, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
