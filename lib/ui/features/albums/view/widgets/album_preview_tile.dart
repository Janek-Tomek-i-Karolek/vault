import 'package:flutter/material.dart';
import 'package:vault/domain/album/album_preview.dart';
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
      child: Card(
        child: SizedBox.square(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ImagePreview.create(
                    key: ValueKey(albumPreview.albumId),
                    albumPreview: albumPreview,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment(0, -0.5),
                        colors: <Color>[
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainerHighest.withAlpha(
                            0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        albumPreview.albumName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: theme.textTheme.titleLarge!.fontSize,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class _ImagePreview extends StatelessWidget {
  const _ImagePreview({super.key, required this.provider});

  static const kThumbnailPlaceholderPath =
      'lib/assetImages/thumbnail-placeholder.jpg';
  final ImageProvider provider;

  factory _ImagePreview.create({Key? key, required AlbumPreview albumPreview}) {
    if (albumPreview.thumbnail != null) {
      final asset = albumPreview.thumbnail!;
      return _InternetImagePreview(
        key: key,
        provider: NetworkImage(asset.thumbnailUri, headers: asset.headers),
        thumbHashProvider: asset.thumbImageProvider!,
      );
    } else {
      return _StaticImagePreview(
        key: key,
        provider: AssetImage(kThumbnailPlaceholderPath),
      );
    }
  }
}

class _StaticImagePreview extends _ImagePreview {
  const _StaticImagePreview({super.key, required super.provider});

  @override
  Widget build(BuildContext context) {
    return Image(image: provider, fit: BoxFit.cover);
  }
}

class _InternetImagePreview extends _ImagePreview {
  const _InternetImagePreview({
    super.key,
    required super.provider,
    required this.thumbHashProvider,
  });
  final ImageProvider thumbHashProvider;

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
