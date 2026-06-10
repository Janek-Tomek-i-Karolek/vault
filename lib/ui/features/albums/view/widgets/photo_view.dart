import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/ui/features/albums/view/widgets/pointer_listener.dart';

enum Delta { height, width }

class PhotoView extends StatefulWidget {
  const PhotoView({
    super.key,
    required this.asset,
    required this.onZoom,
    this.onTap,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.onDragCancel,
    this.onPageBuild,
    this.disableZoomGestures,
  });
  final Asset asset;
  final Function(double) onZoom;
  final Function()? onTap;
  final Function(DragStartDetails details)? onDragStart;
  final Function(DragEndDetails details)? onDragEnd;
  final Function(DragUpdateDetails details)? onDragUpdate;
  final Function(Size imageSize)? onPageBuild;
  final VoidCallback? onDragCancel;
  final bool? disableZoomGestures;

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _imageKey = GlobalKey();

  static const double kTargetScale = 2.5;
  static const double kOriginalScaleThreshold = 3.0;
  static const int kZoomDuration = 300;

  late final AnimationController _animationControllerZoom;
  late Size viewPortSize;
  late EdgeInsets imageBoundaryMargin;

  final ValueNotifier<bool> _loadOriginal = ValueNotifier<bool>(false);
  double _scale = 1.0;
  bool _lockInMainAxis = false;
  bool _isZoomInteraction = false;
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

    final center = Offset(viewPortSize.width / 2, viewPortSize.height / 2);
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
        viewPortSize.height,
        center.dy,
        _doubleTapLocation!.dy,
      ),
      Delta.width => (
        imageSize.width,
        viewPortSize.width,
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
    if (widget.disableZoomGestures ?? false) {
      return;
    }
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
      _isZoomInteraction = true;
      _lockInMainAxis = false;
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _isZoomInteraction = false;
    _onTransformationChange();
  }

  void _onTransformationChange() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale != _scale) {
      // notify parent layout
      widget.onZoom(scale);
      setState(() {
        _scale = scale;
      });
    }
    _loadOriginal.value = _scale >= kOriginalScaleThreshold;

    // update boundary margin constraints
    if (!_isZoomInteraction) {
      final imageSize = _imageKey.currentContext!.size;
      if (imageSize != null) {
        final isFilled = imageSize.height * _scale >= viewPortSize.height;
        if (isFilled != _lockInMainAxis) {
          _lockInMainAxis = isFilled;
        }
      }
    }
  }

  void _setBoundaryMargin() {
    final imageSize = _imageKey.currentContext!.size;
    if (imageSize != null) {
      final yMargin = (viewPortSize.height - imageSize.height) / 2;
      final xMargin = (viewPortSize.width - imageSize.width) / 2;
      imageBoundaryMargin = EdgeInsets.fromLTRB(
        -xMargin,
        -yMargin,
        -xMargin,
        -yMargin,
      );
    }
  }

  bool get isZoomGestureDisabled => widget.disableZoomGestures ?? false;
  bool get _isZoomed => _scale != 1.0;

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
      (_) => widget.onPageBuild ?? (_imageKey.currentContext!.size!),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _setBoundaryMargin());
    return LayoutBuilder(
      builder: (context, constraints) {
        viewPortSize = Size(constraints.maxWidth, constraints.maxHeight);
        return PointersListener(
          builder: (_, moreThanOnePointer) {
            return InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 1.0,
              maxScale: 10,
              constrained: false,
              scaleEnabled: !isZoomGestureDisabled,
              panAxis: _lockInMainAxis ? PanAxis.free : PanAxis.horizontal,
              boundaryMargin: _lockInMainAxis
                  ? imageBoundaryMargin
                  : EdgeInsets.zero,
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
                onVerticalDragStart: !moreThanOnePointer && !_isZoomed
                    ? widget.onDragStart
                    : null,
                onVerticalDragUpdate: !moreThanOnePointer && !_isZoomed
                    ? widget.onDragUpdate
                    : null,
                onVerticalDragEnd: !moreThanOnePointer && !_isZoomed
                    ? widget.onDragEnd
                    : null,
                onVerticalDragCancel: !moreThanOnePointer && !_isZoomed
                    ? widget.onDragCancel
                    : null,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: ValueListenableBuilder(
                    valueListenable: _loadOriginal,
                    builder: (context, isOriginal, child) {
                      return Center(
                        child: _buildImage(isOriginal, constraints),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Image _buildImage(bool isOriginal, BoxConstraints constraints) {
    final double originalWidth = widget.asset.width?.toDouble() ?? 0.0;
    final double originalHeight = widget.asset.height?.toDouble() ?? 0.0;

    if (originalWidth == 0 || originalHeight == 0) {
      return Image.network(
        isOriginal ? widget.asset.originalUri : widget.asset.previewUri,
        headers: widget.asset.headers,
        fit: BoxFit.contain,
      );
    }

    final double aspectRatio = originalWidth / originalHeight;

    double targetWidth;
    double targetHeight;

    if (originalHeight >= originalWidth) {
      targetHeight = constraints.maxHeight.isInfinite
          ? originalHeight
          : constraints.maxHeight;
      targetWidth = targetHeight * aspectRatio;
    } else {
      targetWidth = constraints.maxWidth.isInfinite
          ? originalWidth
          : constraints.maxWidth;
      targetHeight = targetWidth / aspectRatio;
    }

    return Image.network(
      key: _imageKey,
      isOriginal ? widget.asset.originalUri : widget.asset.previewUri,
      headers: widget.asset.headers,
      fit: BoxFit.contain,
      width: targetWidth,
      height: targetHeight,
      gaplessPlayback: true,
      frameBuilder: (context, child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        final thumbhash = Image(
          image: widget.asset.thumbImageProvider!,
          width: targetWidth,
          height: targetHeight,
          fit: BoxFit.contain,
        );
        return thumbhash;
      },
    );
  }
}
