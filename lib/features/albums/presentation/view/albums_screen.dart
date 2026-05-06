import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/data/repositories/album/mock_album_repository.dart';
import 'package:vault/data/repositories/asset/mock_asset_repository.dart';
import 'package:vault/features/albums/presentation/viemodel/albums_viewmodel.dart';
import 'package:vault/features/albums/presentation/view/widgets/album_preview_tile.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AlbumsViewModel>().fetchPreviews(); // Trigger fetch
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AlbumsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Albums")),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return switch ((
              viewModel.isLoading,
              viewModel.albumPreviews,
              viewModel.error,
            )) {
              (true, _, _) => const CircularProgressIndicator(),
              (_, _, final Exception e) => Text('Error: $e'),
              (_, final albumPreviews?, _) => GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 220,
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.7,
                ),
                itemCount: albumPreviews.length,
                itemBuilder: (context, index) {
                  final preview = albumPreviews[index];
                  return AlbumPreviewTile(
                    albumPreview: preview,
                    thumbnailUriBuilder: viewModel.getThumbnailUri,
                  );
                },
              ),
              _ => const Text("Something went wrong!"),
            };
          },
        ),
      ),
    );
  }
}
