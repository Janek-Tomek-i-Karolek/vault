import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/extensions/FastScrollPhysics.dart';
import 'package:vault/ui/features/albums/viemodel/asset_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/features/albums/view/widgets/pointer_listener.dart';
import 'package:vault/ui/features/albums/view/widgets/single_asset_page_viewer.dart';

class AssetViewer extends StatefulWidget {
  const AssetViewer({
    super.key,
    required this.serverConnection,
    required this.assets,
    required this.album,
    required this.startIndex,
  });
  final List<Asset> assets;
  final Album album;
  final int startIndex;
  final ServerConnection serverConnection;

  @override
  State<AssetViewer> createState() => _AssetViewerState();
}

class _AssetViewerState extends State<AssetViewer> {
  final ValueNotifier<bool> _isZoomed = ValueNotifier(false);
  bool _topBottomAppBar = true;
  bool _bottomAppBar = true;

  late int _currentIndex;

  void _onZoom(double scale) {
    _isZoomed.value = scale != 1.0;

    if (_topBottomAppBar && _isZoomed.value ||
        !_topBottomAppBar && !_isZoomed.value) {
      _toggleUIVisibility();
    }
  }

  void _onDetails(bool visible) {
    setState(() {
      _bottomAppBar = !visible;
    });
  }

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _isZoomed.dispose();
    super.dispose();
  }

  void _toggleUIVisibility() {
    setState(() {
      _topBottomAppBar = !_topBottomAppBar;
    });
  }

  void _pageChanged(int index) {
    _currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedOpacity(
          opacity: _topBottomAppBar ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: _topBottomAppBar
              ? AppBar(
                  backgroundColor: Colors.black38,
                  foregroundColor: theme.colorScheme.onSurface,
                )
              : const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: AnimatedOpacity(
        opacity: _topBottomAppBar ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: _topBottomAppBar && _bottomAppBar
            ? BottomAppBar(
                color: Colors.black38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _shareButton(context, theme),
                    _downloadButton(context, theme),
                    _removeButton(context, theme),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isZoomed,
        builder: (_, isZoomed, _) {
          return PointersListener(
            builder: (_, moreThanOnePointer) {
              final pagePhysics = isZoomed || moreThanOnePointer
                  ? const NeverScrollableScrollPhysics()
                  : const FastClampingScrollPhysics();
              return PageView.builder(
                itemCount: widget.assets.length,
                allowImplicitScrolling: true,
                scrollCacheExtent: ScrollCacheExtent.viewport(1),
                controller: _pageController,
                physics: pagePhysics,
                onPageChanged: _pageChanged,
                itemBuilder: (_, index) {
                  return SingleAssetPageViewer(
                    asset: widget.assets[index],
                    onZoom: _onZoom,
                    onDetails: _onDetails,
                    onTap: _toggleUIVisibility,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _floatingButton({
    required VoidCallback onPressed,
    required IconData icon,
    required ThemeData theme,
    required String tooltip,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: Colors.transparent,
      foregroundColor: theme.colorScheme.onSurface,
      splashColor: theme.colorScheme.primary,
      heroTag: "hero-$tooltip",
      child: Icon(icon),
    );
  }

  Widget _removeButton(BuildContext context, ThemeData theme) =>
      _floatingButton(
        theme: theme,
        icon: Icons.delete_outline,
        tooltip: 'Remove Photo',
        onPressed: () async {
          await context.read<AssetViewModel>().removeAssetFromAlbum(
            widget.serverConnection,
            widget.album,
            widget.assets[_currentIndex],
          );
        },
      );

  Widget _shareButton(BuildContext context, ThemeData theme) => _floatingButton(
    theme: theme,
    icon: Icons.share,
    tooltip: 'Share Photo',
    onPressed: () async {
      print("share pressed");
    },
  );

  Widget _downloadButton(BuildContext context, ThemeData theme) =>
      _floatingButton(
        theme: theme,
        icon: Icons.download,
        tooltip: 'Download Photo',
        onPressed: () async {
          print("Download pressed");
        },
      );
}
