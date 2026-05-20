import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';

class AlbumScreen extends StatefulWidget {
  final String albumId;

  const AlbumScreen({super.key, required this.albumId});

  @override
  State<StatefulWidget> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    super.initState();
    // Use microtask or addPostFrameCallback to avoid calling inherited widgets during init
    context.read<AlbumViewModel>().loadAlbum(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlbumViewModel>();

    // Safely extract the title based on state
    final String appBarTitle = switch ((viewModel.isLoading, viewModel.album)) {
      (true, _) => "Loading...",
      (_, final album!) => album.name,
      _ => "Album",
    };

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), centerTitle: true),
      body: switch ((viewModel.isLoading, viewModel.album, viewModel.error)) {
        (true, _, _) => const Center(child: CircularProgressIndicator()),
        (_, _, final Exception e) => Center(child: Text("Error: $e")),
        (_, final album!, _) => MasonryGridView.builder(
          itemCount: album.assets.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final asset = album.assets[index];

            // We pass the asset directly or use a builder pattern (discussed in Part 2)
            return Padding(
              padding: const EdgeInsets.all(1.0),
              // LayoutBuilder or a fixed aspect ratio keeps masonry stable before images load
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AssetTile(
                  viewModel.getOriginalUri(asset.id),
                  width: asset.width?.toDouble(),
                  height: asset.height?.toDouble(),
                  headers: viewModel.getHeaders,
                ),
              ),
            );
          },
        ),
      },
    );
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
    return GestureDetector(
      onTap: onTap,
      child: Image.network(
        uri,
        width: width,
        height: height,
        headers: headers,
        fit: BoxFit.cover,
      ),
    );
  }
}
