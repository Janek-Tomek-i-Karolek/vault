import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/core/nav/sidebar_menu.dart';
import 'package:vault/ui/core/widgets/profile_button.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';
import 'package:vault/ui/features/albums/view/widgets/album_preview_tile.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AlbumsViewModel>().fetchPreviews();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Lazy preview loading
    final viewModel = context.read<AlbumsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Albums"),
        actions: const [ProfileButton()],
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
                    return SearchBar(
                      controller: controller,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {},
                      onChanged: (input) {
                        viewModel.filterPreviews(input);
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                        return [Text("hehe"), Text("hehe 2")];
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
                    (true, null, _) => SizedBox(
                      height: 10,
                      width: 10,
                      child: const CircularProgressIndicator(),
                    ),
                    (_, _, final Exception e) => Text('Error: $e'),
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
                    _ => const Text("Something went wrong!"),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
