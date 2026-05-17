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
    return Card.outlined(
      margin: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                      color: theme.disabledColor,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            albumPreview.albumName,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
