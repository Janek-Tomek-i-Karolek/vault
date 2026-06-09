import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/extensions/FastScrollPhysics.dart';
import 'package:vault/ui/features/albums/viemodel/asset_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:vault/ui/features/albums/view/widgets/asset_viewer.dart';
import 'package:vault/ui/features/albums/view/widgets/pointer_listener.dart';

enum _DragIntent { none, scroll, dismiss }

class AssetScreen extends StatefulWidget {
  const AssetScreen({
    super.key,
    required this.serverConnection,
    required this.assets,
    required this.album,
    required this.index,
  });
  final List<Asset> assets;
  final Album album;
  final int index;
  final ServerConnection serverConnection;

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  final ValueNotifier<bool> _isZoomed = ValueNotifier(false);
  final ValueNotifier<bool> _isShowingDetails = ValueNotifier(false);
  bool _uiVisible = true;
  double _snapOffset = 0.0;

  Size? _imageSize;
  DragStartDetails? _dragStart;
  _DragIntent _dragIntent = _DragIntent.none;
  Drag? _drag;

  late SnapScrollController _scrollController;
  late PageController _pageController;

  void _onZoom(double scale) {
    _isZoomed.value = scale != 1.0;

    if (_uiVisible && _isZoomed.value || !_uiVisible && !_isZoomed.value) {
      _toggleUIVisibility();
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _scrollController = SnapScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.snapPosition.snapOffset = _snapOffset;
      if (_isShowingDetails.value && _snapOffset > 0) {
        print("I am snapping currently, to _snapOffset $_snapOffset");
        _scrollController.jumpTo(_snapOffset);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _isZoomed.dispose();
    super.dispose();
  }

  void _toggleUIVisibility() {
    setState(() {
      _uiVisible = !_uiVisible;
    });
  }

  void _beginDrag(DragStartDetails details) {
    print("Beging drag");
    _dragStart = details;

    if (_isShowingDetails.value) {
      print("Beging drag - showing details");
      _dragIntent = _DragIntent.scroll;
      _startProxyDrag();
    }
  }

  void _onDragStart(BuildContext context, DragStartDetails details) {
    if (!_isShowingDetails.value && _isZoomed.value) {
      return;
    }
    _beginDrag(details);
  }

  void _onDragCancel() => _endDrag(DragEndDetails(primaryVelocity: 0.0));

  void _updateDrag(DragUpdateDetails details) {
    print("update drag");
    if (_dragStart == null) {
      return;
    }

    if (_dragIntent == _DragIntent.none) {
      _dragIntent =
          switch ((details.globalPosition - _dragStart!.globalPosition).dy) {
            < 0 => _DragIntent.scroll,
            > 0 => _DragIntent.dismiss,
            _ => _DragIntent.none,
          };
    }

    switch (_dragIntent) {
      case _DragIntent.none:
      case _DragIntent.scroll:
        if (_drag == null) {
          _startProxyDrag();
        }
        _drag?.update(details);

        _syncShowingDetails();
      case _:
    }
  }

  void _syncShowingDetails() {
    final offset = _scrollController.offset;
    if (offset > SnapScrollPhysics.minSnapDistance) {
      _isShowingDetails.value = true;
      // _viewer.setShowingDetails(true);
    } else if (offset < SnapScrollPhysics.minSnapDistance - kTouchSlop) {
      _isShowingDetails.value = false;
    }
  }

  bool _willClose(double scrollVelocity) =>
      _scrollController.hasClients &&
      _snapOffset > 0 &&
      _scrollController.position.pixels < _snapOffset &&
      SnapScrollPhysics.target(
            _scrollController.position,
            scrollVelocity,
            _snapOffset,
          ) <
          SnapScrollPhysics.minSnapDistance;

  void _endDrag(DragEndDetails details) {
    print("end drag");
    final intent = _dragIntent;
    _dragIntent = _DragIntent.none;

    switch (intent) {
      case _DragIntent.none:
      case _DragIntent.scroll:
        final scrollVelocity = -(details.primaryVelocity ?? 0.0);
        _isShowingDetails.value = !_willClose(scrollVelocity);

        _drag?.end(details);
        _drag = null;
      case _:
    }
  }

  void _startProxyDrag() {
    if (_scrollController.hasClients && _dragStart != null) {
      _drag = _scrollController.position.drag(_dragStart!, () => _drag = null);
    }
  }

  void _onPageBuild(Size imageSize) {
    _imageSize = imageSize;
  }

  double _getImageHeight(double maxWidth, double maxHeight, Asset? asset) {
    final imageHeight = _imageSize?.height;
    if (imageHeight != null) {
      return imageHeight;
    }

    if (asset == null || asset.width == null || asset.height == null) {
      return maxHeight;
    }

    final r = asset.width! / asset.height!;
    return min(maxWidth / r, maxHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewportWidth = MediaQuery.widthOf(context);
    final viewportHeight = MediaQuery.heightOf(context);
    final imageHeight = _getImageHeight(
      viewportWidth,
      viewportHeight,
      widget.assets[widget.index],
    );
    final detailsOffset =
        (viewportHeight + imageHeight - kMinInteractiveDimension) / 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedOpacity(
          opacity: _uiVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: _uiVisible
              ? AppBar(
                  backgroundColor: Colors.black38,
                  foregroundColor: theme.colorScheme.onSurface,
                )
              : const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: AnimatedOpacity(
        opacity: _uiVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: _uiVisible
            ? BottomAppBar(
                color: Colors.black38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        await context
                            .read<AssetViewModel>()
                            .removeAssetFromAlbum(
                              widget.serverConnection,
                              widget.album,
                              widget.assets[widget.index],
                            );
                      },
                      tooltip: 'Add Photos',
                      backgroundColor: Colors.transparent,
                      foregroundColor: theme.colorScheme.onSurface,
                      splashColor: theme.colorScheme.primary,
                      child: const Icon(Icons.delete_outline),
                    ),
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
              // Determine scroll physics based on zoom and pointer state
              final scrollPhysics = isZoomed || moreThanOnePointer
                  ? const NeverScrollableScrollPhysics()
                  : const SnapScrollPhysics();

              final pagePhysics = isZoomed || moreThanOnePointer
                  ? const NeverScrollableScrollPhysics()
                  : const FastClampingScrollPhysics();

              // return PageView.builder(
              //   itemCount: widget.assets.length,
              //   allowImplicitScrolling: true,
              //   scrollCacheExtent: ScrollCacheExtent.viewport(1),
              //   controller: _pageController,
              //   physics: pagePhysics,
              //   itemBuilder: (_, index) {
              return SingleChildScrollView(
                physics: scrollPhysics,
                controller: _scrollController,
                child: Stack(
                  children: [
                    SizedBox(
                      width: viewportWidth,
                      height: viewportHeight,
                      child: RepaintBoundary(
                        child: AssetViewer(
                          asset: widget.assets[widget.index],
                          onZoom: _onZoom,
                          onTap: _toggleUIVisibility,
                          onDragStart: _onDragStart,
                          onDragUpdate: _updateDrag,
                          onDragEnd: _endDrag,
                          onDragCancel: _onDragCancel,
                          onPageBuild: _onPageBuild,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _isShowingDetails,
                      builder: (context, isShowingDetails, child) {
                        return IgnorePointer(
                          ignoring: !isShowingDetails,
                          child: Column(
                            children: [
                              SizedBox(height: detailsOffset),
                              GestureDetector(
                                onVerticalDragStart: _beginDrag,
                                onVerticalDragUpdate: _updateDrag,
                                onVerticalDragEnd: _endDrag,
                                onVerticalDragCancel: _onDragCancel,
                                child: SizedBox(
                                  height: 600,
                                  child: ColoredBox(
                                    color: theme.colorScheme.primary,
                                    child: Center(child: Text("dupa jasiu")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        //   );
        // },
      ),
    );
  }
}
