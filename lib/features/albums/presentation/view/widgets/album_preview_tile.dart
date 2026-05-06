import 'package:flutter/material.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';

class AlbumPreviewTile extends StatelessWidget {
  final AlbumPreview albumPreview;
  final Uri Function(Asset asset) thumbnailUriBuilder;

  const AlbumPreviewTile({
    super.key,
    required this.albumPreview,
    required this.thumbnailUriBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbnailUri = thumbnailUriBuilder(albumPreview.thumbnail);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  thumbnailUri.toString(),
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              albumPreview.albumName,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
