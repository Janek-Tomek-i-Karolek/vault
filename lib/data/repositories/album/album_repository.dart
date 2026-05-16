import "../../../domain/album/album.dart";
import "../../../domain/album/album_preview.dart";
import "../../../utils/result.dart";

abstract class AlbumRepository {
  Future<Result<List<AlbumPreview>>> getAlbumPreviews();
  Future<Result<List<Album>>> getAlbums();
  Future<Result<Album>> getAlbum(String id);
  Future<Result<void>> create(Album album);
  Future<Result<void>> delete(String id);
}
