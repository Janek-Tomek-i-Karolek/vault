import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vector_math/vector_math_64.dart' as v_math;

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key, required this.asset});

  final Asset asset;

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _imageKey = GlobalKey();

  static const double kTargetScale = 3.0;
  static const int kZoomDuration = 100;
  late final AnimationController _animationControllerZoom;
  late Size size;
  late EdgeInsets imageBoundaryMargin;

  // At class level
  final ValueNotifier<bool> _isFull = ValueNotifier<bool>(false);
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
        final imageSize = _imageKey.currentContext!.size;
        final center = Offset(size.width / 2, size.height / 2);
        Offset tap = _doubleTapLocation ?? center;
        final tapOffset = (center.dy - tap.dy).abs();
        final margin = (size.height - imageSize!.height) / 2;
        if (tapOffset > margin) {
          tap = Offset(
            tap.dx,
            tap.dy > center.dy ? center.dy + margin : center.dy - margin,
          );
        }
        endMatrix = Matrix4.identity()
          ..translate(tap.dx, tap.dy)
          // ..translate(center.dx, center.dy)
          ..scale(kTargetScale)
          // ..translate(-center.dx, -center.dy); // zoom in the middle
          ..translate(-tap.dx, -tap.dy); // follow double tap (works mehh)
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
          print("is full: $isFull");
          _isFull.value = isFull;
        }
      }
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
  }

  @override
  void dispose() {
    _animationControllerZoom.dispose();
    _transformationController.dispose();
    super.dispose();
  }

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
      body: LayoutBuilder(
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
                      child: Image.network(
                        widget.asset.previewUri,
                        key: _imageKey,
                        headers: widget.asset.headers,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // void _onDoubleTapDownDebug(TapDownDetails details) {
  //   print("local coordinates ${details.localPosition}");
  //   // print(
  //   //   "transformed coordinates ${_transformationController.toScene(details.localPosition)}",
  //   // );
  //   _doubleTapLocation = details.localPosition;
  // }
}
