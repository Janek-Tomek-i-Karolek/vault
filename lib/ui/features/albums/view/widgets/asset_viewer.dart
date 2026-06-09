import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';

enum Delta { height, width }

class AssetViewer extends StatefulWidget {
  const AssetViewer({
    super.key,
    required this.asset,
    required this.onZoom,
    required this.onTap,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.onDragCancel,
    this.onPageBuild,
  });
  final Asset asset;
  final Function(double) onZoom;
  final Function() onTap;
  final Function(BuildContext context, DragStartDetails details)? onDragStart;
  final Function(DragEndDetails details)? onDragEnd;
  final Function(DragUpdateDetails details)? onDragUpdate;
  final Function(Size imageSize)? onPageBuild;
  final VoidCallback? onDragCancel;

  @override
  State<AssetViewer> createState() => _AssetViewerState();
}

class _AssetViewerState extends State<AssetViewer>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _imageKey = GlobalKey();

  static const double kTargetScale = 2.5;
  static const double kOriginalScaleThreshold = 3.0;
  static const int kZoomDuration = 300;

  late final AnimationController _animationControllerZoom;
  late Size size;
  late EdgeInsets imageBoundaryMargin;

  final ValueNotifier<bool> _isFull = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isOriginal = ValueNotifier<bool>(false);
  bool _isScaleInteraction = false;
  Animation<Matrix4>? _animationZoom;
  Offset? _doubleTapLocation;

  void _onAnimateZoom() {
    _transformationController.value = _animationZoom!.value;
    if (!_animationControllerZoom.isAnimating) {
      _animationZoom!.removeListener(_onAnimateZoom);
      _animationZoom = null;
      _animationControllerZoom.reset();
    }
  }

  ({double d1, double d2}) _calculateDeltas({required Delta axis}) {
    final imageSize = _imageKey.currentContext!.size!;

    final center = Offset(size.width / 2, size.height / 2);
    late final double d1;
    late final double d2;

    final (
      double imageFactor,
      double viewPortFactor,
      double centerFactor,
      double tapFactor,
    ) = switch (axis) {
      Delta.height => (
        imageSize.height,
        size.height,
        center.dy,
        _doubleTapLocation!.dy,
      ),
      Delta.width => (
        imageSize.width,
        size.width,
        center.dx,
        _doubleTapLocation!.dx,
      ),
    };

    if (imageFactor == viewPortFactor) {
      d1 = tapFactor;
      d2 = -tapFactor;
    } else if (imageFactor * kTargetScale > viewPortFactor) {
      final margin = (viewPortFactor - imageFactor) / 2;
      final constraints = [-margin * 2, -margin];
      final shift = constraints.fold(0.0, (sum, value) => sum - value) / 2;
      final standardised = [for (var val in constraints) val + shift];
      final tapCenterOffset = centerFactor - tapFactor;
      // shift back to remove standarisation
      d2 = max(min(standardised[1], tapCenterOffset), standardised[0]) - shift;
      d1 = 0;
    } else {
      d1 = centerFactor;
      d2 = -centerFactor;
    }
    return (d1: d1, d2: d2);
  }

  Matrix4 _zoomEndMatrix() {
    final yDelta = _calculateDeltas(axis: Delta.height);
    final xDelta = _calculateDeltas(axis: Delta.width);

    return Matrix4.identity()
      ..translateByDouble(xDelta.d1, yDelta.d1, 1, 1)
      ..scaleByDouble(kTargetScale, kTargetScale, kTargetScale, 1)
      ..translateByDouble(xDelta.d2, yDelta.d2, 1, 1);
  }

  void _animateZoomInitialize() {
    if (!_animationControllerZoom.isAnimating) {
      final currentTransform = _transformationController.value;
      final endMatrix = currentTransform != Matrix4.identity()
          ? Matrix4.identity()
          : _zoomEndMatrix();
      _animationZoom = Matrix4Tween(begin: currentTransform, end: endMatrix)
          .animate(
            CurvedAnimation(
              parent: _animationControllerZoom,
              curve: Curves.ease,
            ),
          );
      _animationZoom!.addListener(_onAnimateZoom);
      _animationControllerZoom.forward();
    }
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (details.pointerCount > 1) {
      // this means that the user is using two fingers
      // i want to listen to scaling only
      _isScaleInteraction = true;
      _isFull.value = false;
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _isScaleInteraction = false;

    // update boundary margin aftet reenabling
    _onTransformationChange();
  }

  void _onTransformationChange() {
    final scale = _transformationController.value.getMaxScaleOnAxis();

    // notify parent layout
    widget.onZoom(scale);

    // track resolution threshold
    _isOriginal.value = scale >= kOriginalScaleThreshold;

    // update boundary margin constraints
    if (!_isScaleInteraction) {
      final imageSize = _imageKey.currentContext!.size;
      if (imageSize != null) {
        final isFull = imageSize.height * scale >= size.height;
        if (isFull != _isFull.value) {
          final yMargin = (size.height - imageSize.height) / 2;
          imageBoundaryMargin = EdgeInsets.fromLTRB(0, -yMargin, 0, -yMargin);
          _isFull.value = isFull;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationControllerZoom = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: kZoomDuration),
    );
    _transformationController.addListener(_onTransformationChange);
  }

  @override
  void dispose() {
    _animationControllerZoom.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onPageBuild ?? (),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        size = Size(constraints.maxWidth, constraints.maxHeight);
        return ValueListenableBuilder(
          valueListenable: _isFull,
          builder: (context, isFull, child) {
            return InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 1.0,
              maxScale: 10,
              constrained: false,
              panAxis: isFull ? PanAxis.free : PanAxis.horizontal,
              boundaryMargin: isFull ? imageBoundaryMargin : EdgeInsets.zero,
              transformationController: _transformationController,
              onInteractionStart: _onInteractionStart,
              onInteractionEnd: _onInteractionEnd,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: _animateZoomInitialize,
                onTap: widget.onTap,
                onDoubleTapDown: (details) =>
                    _doubleTapLocation = details.localPosition,
                onDoubleTapCancel: () => _doubleTapLocation = null,
                onVerticalDragStart: widget.onDragStart != null
                    ? (details) => widget.onDragStart!(context, details)
                    : null,
                onVerticalDragUpdate: widget.onDragUpdate,
                onVerticalDragEnd: widget.onDragEnd,
                onVerticalDragCancel: widget.onDragCancel,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Center(
                    child: ValueListenableBuilder(
                      valueListenable: _isOriginal,
                      builder: (context, isOriginal, child) {
                        return Image.network(
                          key: _imageKey,
                          isOriginal
                              ? widget.asset.originalUri
                              : widget.asset.previewUri,
                          headers: widget.asset.headers,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
