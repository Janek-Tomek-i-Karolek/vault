import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/ui/core/widgets/profile_button.dart';
import 'package:vault/ui/features/albums/viemodel/add_album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/view/add_album_dialog.dart';
import 'package:vault/ui/features/albums/view/widgets/album_preview_tile.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  String _currentSearchTerm = "";
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();

    context.read<AlbumsViewModel>().fetchPreviews();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AlbumsViewModel>();
    final theme = Theme.of(context);
    final AppLocalizations? localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.albumsScreenTitle),
        actions: const [ProfileButton()],
        foregroundColor: theme.colorScheme.onSurface,
      ),
      drawer: SidebarMenu(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    _searchController = controller;
                    return SearchBar(
                      controller: controller,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {},
                      onChanged: (input) {
                        viewModel.filterPreviews(input);
                        _currentSearchTerm = input;
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder: (BuildContext _, SearchController _) {
                    return [];
                  },
                ),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  return switch ((
                    viewModel.isLoading,
                    viewModel.filteredAlbumPreviews,
                    viewModel.error,
                  )) {
                    (true, null, _) => Center(
                      child: const CircularProgressIndicator(),
                    ),
                    (_, _, final Exception e) => Center(
                      child: Text(
                        localizations.genericErrorMessage(e.toString()),
                      ),
                    ),
                    (_, final albumPreviews?, _) => RefreshIndicator(
                      onRefresh: () async {
                        context.read<AlbumsViewModel>().fetchPreviews();
                      },
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
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
                    _ => Text(localizations.unknownErrorMessage),
                  };
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          await Navigator.pushNamed(context, "/add-album");

          if (context.mounted &&
              context.read<AddAlbumViewModel>().didAddAlbum()) {
            await viewModel.fetchPreviews();
            _searchController.clear();
          }
        },
        tooltip: localizations.addAlbumAction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
