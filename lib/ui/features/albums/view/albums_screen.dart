import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:provider/provider.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/ui/core/widgets/profile_button.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/view/widgets/album_preview_tile.dart';

class AlbumsScreen extends StatefulWidget {
  final ServerConnection serverConnection;

  const AlbumsScreen({required this.serverConnection, super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AlbumsViewModel>().fetchPreviews(widget.serverConnection);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Lazy preview loading
    final viewModel = context.read<AlbumsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Albums"),
        actions: const [ProfileButton()],
        foregroundColor: theme.colorScheme.onSurface,
      ),
      drawer: SidebarMenu(),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return switch ((
              viewModel.isLoading,
              viewModel.albumPreviews,
              viewModel.error,
            )) {
              (true, null, _) => const CircularProgressIndicator(),
              (_, _, final Exception e) => Text('Error: $e'),
              (_, final albumPreviews?, _) => RefreshIndicator(
                onRefresh: () async {
                  context.read<AlbumsViewModel>().fetchPreviews(
                    widget.serverConnection,
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    // childAspectRatio: 0.85,
                  ),
                  itemCount: albumPreviews.length,
                  itemBuilder: (context, index) {
                    final preview = albumPreviews[index];
                    return AlbumPreviewTile(albumPreview: preview);
                  },
                ),
              ),
              _ => const Text("Something went wrong!"),
            };
          },
        ),
      ),
    );
  }
}
