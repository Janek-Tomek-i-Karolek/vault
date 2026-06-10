import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/extensions/FastScrollPhysics.dart';
import 'package:vault/ui/features/albums/view/widgets/asset_details.dart';
import 'package:vault/ui/features/albums/view/widgets/photo_view.dart';

enum _DragIntent { none, scroll, dismiss }

class SingleAssetPageViewer extends StatefulWidget {
  final Asset asset;
  final Function(double)? onZoom;
  final Function(bool)? onDetails;
  final VoidCallback? onTap;

  const SingleAssetPageViewer({
    super.key,
    required this.asset,
    this.onZoom,
    this.onDetails,
    this.onTap,
  });
  @override
  State<SingleAssetPageViewer> createState() => _SingleAssetPageViewerState();
}

class _SingleAssetPageViewerState extends State<SingleAssetPageViewer> {
  final ValueNotifier<bool> _isZoomed = ValueNotifier(false);
  final ValueNotifier<bool> _isShowingDetails = ValueNotifier(false);

  late SnapScrollController _scrollController;

  Size? _imageSize;
  double _snapOffset = 0.0;
  _DragIntent _dragIntent = _DragIntent.none;
  DragStartDetails? _dragStart;
  Drag? _drag;

  void _onZoom(double scale) {
    widget.onZoom?.call(scale);
    _isZoomed.value = scale != 1.0;
  }

  void _onImageDragStart(DragStartDetails details) {
    if (!_isShowingDetails.value || _isZoomed.value) {
      return;
    }
    _beginDrag(details);
  }

  void _beginDrag(DragStartDetails details) {
    _dragStart = details;

    if (_isShowingDetails.value) {
      _dragIntent = _DragIntent.scroll;
      _startProxyDrag();
    }
  }

  void _updateDrag(DragUpdateDetails details) {
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
    } else if (offset < SnapScrollPhysics.minSnapDistance - kTouchSlop) {
      _isShowingDetails.value = false;
    }
  }

  void _endDrag(DragEndDetails details) {
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

  void _onDragCancel() => _endDrag(DragEndDetails(primaryVelocity: 0.0));

  void _startProxyDrag() {
    if (_scrollController.hasClients && _dragStart != null) {
      _drag = _scrollController.position.drag(_dragStart!, () => _drag = null);
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

  void _onShowingDetails() {
    widget.onDetails?.call(_isShowingDetails.value);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = SnapScrollController();
    _isShowingDetails.addListener(_onShowingDetails);

    // TODO: resolve how to hide/open details on new page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.snapPosition.snapOffset = _snapOffset;
      if (_isShowingDetails.value && _snapOffset > 0) {
        _scrollController.jumpTo(_snapOffset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isZoomed.dispose();
    _isShowingDetails.dispose();
    super.dispose();
  }

  PhotoView _buildPhotoView({bool? disableZoomGestures}) {
    return PhotoView(
      asset: widget.asset,
      onZoom: _onZoom,
      onTap: widget.onTap,
      disableZoomGestures: disableZoomGestures,
      onDragStart: _beginDrag,
      onDragUpdate: _updateDrag,
      onDragEnd: _endDrag,
      onDragCancel: _onDragCancel,
      onPageBuild: _onPageBuild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewportWidth = MediaQuery.widthOf(context);
    final viewportHeight = MediaQuery.heightOf(context);
    final imageHeight = _getImageHeight(
      viewportWidth,
      viewportHeight,
      widget.asset,
    );
    final detailsOffset =
        (viewportHeight + imageHeight - kMinInteractiveDimension) / 2;

    final snapTarget = viewportHeight / 3;

    _snapOffset = detailsOffset - snapTarget;

    if (_scrollController.hasClients) {
      _scrollController.snapPosition.snapOffset = _snapOffset;
    }

    return SingleChildScrollView(
      physics: const SnapScrollPhysics(),
      controller: _scrollController,
      hitTestBehavior: HitTestBehavior.opaque,
      child: ValueListenableBuilder(
        valueListenable: _isShowingDetails,
        builder: (context, isShowingDetails, child) {
          return Stack(
            children: [
              SizedBox(
                width: viewportWidth,
                height: viewportHeight,
                child: _buildPhotoView(disableZoomGestures: isShowingDetails),
              ),
              IgnorePointer(
                ignoring: !isShowingDetails,
                child: Column(
                  children: [
                    SizedBox(height: detailsOffset),
                    GestureDetector(
                      onVerticalDragStart: _onImageDragStart,
                      onVerticalDragUpdate: _updateDrag,
                      onVerticalDragEnd: _endDrag,
                      onVerticalDragCancel: _onDragCancel,
                      child: AnimatedOpacity(
                        opacity: isShowingDetails ? 1.0 : 0.0,
                        duration: Durations.short2,
                        child: AssetDetails(
                          details: widget.asset.details,
                          minHeight: viewportHeight - snapTarget,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
