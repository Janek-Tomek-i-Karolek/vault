import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  static final Random kRandom = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(alignment: .center, child: Text("Album XYZ")),
      ),
      body: MasonryGridView.builder(
        itemCount: 1000,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(1.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset('lib/assetImages/image${index % 12}.JPG'),
          ),
        ),
      ),
    );
  }
}

      // body: MasonryGridView.count(
      //   crossAxisCount: 3,
      //   mainAxisSpacing: 4,
      //   crossAxisSpacing: 4,
      //   itemBuilder: (context, index) {
      //     final aspectRatio =
      //         kAspectRatios[kRandom.nextInt(kAspectRatios.length)];
      //     return ImageTile(
      //       index: index,
      //       width: aspectRatio.$1,
      //       height: aspectRatio.$2,
      //     );
      //   },
      // ),
