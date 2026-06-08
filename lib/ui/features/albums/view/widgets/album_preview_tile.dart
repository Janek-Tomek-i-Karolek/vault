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
                  child: _ImagePreview.create(albumPreview: albumPreview),
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

abstract class _ImagePreview extends StatelessWidget {
  static const kThumbnailPlaceholderPath =
      'lib/assetImages/thumbnail-placeholder.jpg';
  final ImageProvider provider;

  factory _ImagePreview.create({required AlbumPreview albumPreview}) {
    if (albumPreview.thumbnail != null) {
      final asset = albumPreview.thumbnail!;
      return _InternetImagePreview(
        provider: NetworkImage(asset.thumbnailUri, headers: asset.headers),
        thumbHashProvider: asset.thumbImageProvider!,
      );
    } else {
      return _StaticImagePreview(
        provider: AssetImage(kThumbnailPlaceholderPath),
      );
    }
  }

  const _ImagePreview({super.key, required this.provider});
}

class _StaticImagePreview extends _ImagePreview {
  _StaticImagePreview({required super.provider});

  @override
  Widget build(BuildContext context) {
    return Image(image: provider);
  }
}

class _InternetImagePreview extends _ImagePreview {
  _InternetImagePreview({
    required super.provider,
    required this.thumbHashProvider,
  });
  ImageProvider thumbHashProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Image(
      image: super.provider,
      fit: BoxFit.cover,
      frameBuilder: (context, child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        final widget = Image(image: thumbHashProvider, fit: BoxFit.cover);
        return widget;
        return child;
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(Icons.broken_image, color: theme.disabledColor, size: 32),
        );
      },
    );
  }
}
