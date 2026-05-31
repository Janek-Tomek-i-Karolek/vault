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

  static const double targetScale = 3.0;
  late final AnimationController _animationControllerZoom;
  late Size size;

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
        final center = Offset(size.width / 2, size.height / 2);
        final tap = _doubleTapLocation ?? center;

        endMatrix = Matrix4.identity()
          ..translate(center.dx, center.dy)
          ..scale(targetScale)
          ..translate(-center.dx, -center.dy); // zoom in the middle
        // ..translate(-tap.dx, -tap.dy); // follow double tap (works mehh)
      }
      _animationZoom = Matrix4Tween(
        begin: currentTransform,
        end: endMatrix,
      ).animate(_animationControllerZoom);

      _animationZoom!.addListener(_onAnimateZoom);
      _animationControllerZoom.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationControllerZoom = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
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
          return InteractiveViewer(
            // clipBehavior: Clip.none,
            // to ogranicza marginesy zdjęcia które jest zoomowane
            // boundaryMargin: EdgeInsets.fromLTRB(0, -90.9, 0, -90.9),
            constrained: false,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Center(
                  child: Image.network(
                    widget.asset.previewUri,
                    headers: widget.asset.headers,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              onDoubleTap: _animateZoomInitialize,
              // onDoubleTapDown: (details) =>
              //     _doubleTapLocation = details.localPosition,
              onDoubleTapDown: _onDoubleTapDownDebug,
              onDoubleTapCancel: () => _doubleTapLocation = null,
            ),
            transformationController: _transformationController,
            minScale: 1.0,
            maxScale: 10,
          );
        },
      ),
    );
  }

  void _onDoubleTapDownDebug(TapDownDetails details) {
    print(details.localPosition);
    _doubleTapLocation = details.localPosition;
  }
}
