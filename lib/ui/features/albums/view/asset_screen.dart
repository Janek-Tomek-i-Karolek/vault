import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';

class AssetScreen extends StatelessWidget {
  const AssetScreen({super.key, required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(color: Colors.transparent),
      body: AssetViewer(asset: asset),
    );
  }
}

class AssetViewer extends StatefulWidget {
  const AssetViewer({super.key, required this.asset});
  final Asset asset;

  @override
  State<AssetViewer> createState() => _AssetViewerState();
}

class _AssetViewerState extends State<AssetViewer>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _imageKey = GlobalKey();

  static const double kTargetScale = 3.0;
  static const double kOriginalScaleThreshold = 3.0;
  static const int kZoomDuration = 300;

  late final AnimationController _animationControllerZoom;
  late Size size;
  late EdgeInsets imageBoundaryMargin;

  // At class level
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

  void _animateZoomInitialize() {
    if (!_animationControllerZoom.isAnimating) {
      final currentTransform = _transformationController.value;
      late final Matrix4 endMatrix;
      if (currentTransform != Matrix4.identity()) {
        endMatrix = Matrix4.identity();
      } else {
        final imageSize = _imageKey.currentContext!.size!;
        final center = Offset(size.width / 2, size.height / 2);

        // Constrain the tap vertical value so the zoom-in
        // does not zoom into black void weirdly.
        final dy = min(
          (size.height - imageSize.height) / 2,
          (imageSize.height * kTargetScale) - size.height,
        );

        // clamped Y is based on tap-position, relative to center
        final double targetY = _doubleTapLocation!.dy > center.dy
            ? center.dy + dy
            : center.dy - dy;

        final tap = Offset(_doubleTapLocation!.dx, targetY);

        endMatrix = Matrix4.identity()
          ..translateByDouble(tap.dx, tap.dy, 1, 1)
          ..scaleByDouble(kTargetScale, kTargetScale, kTargetScale, 1)
          ..translateByDouble(-tap.dx, -tap.dy, 1, 1);
      }
      _animationZoom = Matrix4Tween(
        begin: currentTransform,
        end: endMatrix,
      ).animate(_animationControllerZoom);

      _animationZoom!.addListener(_onAnimateZoom);
      _animationControllerZoom.forward();
    }
  }

  void _updateLock() {
    if (!_isScaleInteraction) {
      final scale = _transformationController.value.getMaxScaleOnAxis();
      final imageSize = _imageKey.currentContext!.size;
      if (imageSize != null) {
        final isFull = imageSize.height * scale >= size.height;
        if (isFull != _isFull.value) {
          final margin = (size.height - imageSize.height) / 2;
          imageBoundaryMargin = EdgeInsets.fromLTRB(0, -margin, 0, -margin);
          _isFull.value = isFull;
        }
      }
    }
  }

  void _updateOriginal() {
    // print(_transformationController.value.transposed());
    _isOriginal.value =
        _transformationController.value.getMaxScaleOnAxis() >=
        kOriginalScaleThreshold;
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (details.pointerCount > 1) {
      // this means that the user is using two fingers
      // i want to listen to scaling only
      _isScaleInteraction = true;
      _isFull.value = false;
    }
  }

  void _onInteractionEnd() {
    _isScaleInteraction = false;
    _updateLock();
  }

  @override
  void initState() {
    super.initState();
    _animationControllerZoom = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: kZoomDuration),
    );
    _transformationController.addListener(_updateLock);
    _transformationController.addListener(_updateOriginal);
  }

  @override
  void dispose() {
    _animationControllerZoom.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onInteractionEnd: (_) => _onInteractionEnd(),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: _animateZoomInitialize,
                onDoubleTapDown: (details) =>
                    _doubleTapLocation = details.localPosition,
                onDoubleTapCancel: () => _doubleTapLocation = null,
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
