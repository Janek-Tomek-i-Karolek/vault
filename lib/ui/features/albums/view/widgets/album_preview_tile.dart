import 'package:flutter/material.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/ui/features/albums/view/album_screen.dart';

class AlbumPreviewTile extends StatelessWidget {
  final AlbumPreview albumPreview;

  const AlbumPreviewTile({super.key, required this.albumPreview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String thumbnailUri;

    // TODO: handle missing thumbnail uri better
    if (albumPreview.thumbnail == null) {
      thumbnailUri =
          "https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg";
    } else {
      thumbnailUri = albumPreview.thumbnail!.thumbnailUri;
    }

    return GestureDetector(
      onTap: () => {
        if (albumPreview.albumId != null)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumScreen(
                  albumId: albumPreview.albumId!,
                  serverConnection: albumPreview.serverConnection,
                ),
              ),
            ),
          },
      },
      child: Card.outlined(
        margin: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    thumbnailUri,
                    fit: BoxFit.cover,
                    headers:
                        albumPreview.thumbnail?.serverConnection.jsonHeaders,
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
            ),
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(8, 4, 8, 12),
              child: Text(
                albumPreview.albumName,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
