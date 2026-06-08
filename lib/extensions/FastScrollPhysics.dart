// https://github.com/immich-app/immich/blob/e222b195767d6764e7aa0daa6bfec9fde74e8f0a/mobile/lib/extensions/scroll_extensions.dart#L4
// https://stackoverflow.com/a/74453792
import 'package:flutter/material.dart';

class FastScrollPhysics extends ScrollPhysics {
  const FastScrollPhysics({super.parent});

  @override
  FastScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 1, stiffness: 402.49984375, damping: 40);
}

class FastClampingScrollPhysics extends ClampingScrollPhysics {
  const FastClampingScrollPhysics({super.parent});

  @override
  FastClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastClampingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    // When swiping between videos on Android, the placeholder of the first opened video
    // can briefly be seen and cause a flicker effect if the video begins to initialize
    // before the animation finishes - probably a bug in PhotoViewGallery's animation handling
    // Making the animation faster is not just stylistic, but also helps to avoid this flicker
    mass: 1,
    stiffness: 1601.2499609375,
    damping: 80,
  );
}
