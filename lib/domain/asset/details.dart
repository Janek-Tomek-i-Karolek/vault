import 'package:vault/data/model/asset/exif_response_dto.dart';
import 'package:vault/domain/server/server_connection.dart';

class Details {
  // date and localization
  final DateTime? dateTimeOriginal;
  final String? timeZone;
  final String? city;
  final String? country;

  // file specific
  final int? fileSizeInByte;
  final int? height;
  final int? width;

  // camera specific
  final String? cameraModel;
  final String? lensModel;
  final int? iso;
  final String? exposureTime;
  final double? focalLength;
  final double? fStop;

  // server
  final String server;

  Details({
    required this.dateTimeOriginal,
    required this.timeZone,
    required this.city,
    required this.country,
    required this.fileSizeInByte,
    required this.height,
    required this.width,
    required this.cameraModel,
    required this.lensModel,
    required this.iso,
    required this.exposureTime,
    required this.focalLength,
    required this.fStop,
    required this.server,
  });

  static Details fromDTO(ExifResponseDTO? dto, ServerConnection server) =>
      Details(
        dateTimeOriginal: dto?.dateTimeOriginal,
        timeZone: dto?.timeZone,
        city: dto?.city,
        country: dto?.country,
        fileSizeInByte: dto?.fileSizeInByte,
        height: dto?.exifImageHeight,
        width: dto?.exifImageWidth,
        cameraModel: dto?.model,
        lensModel: dto?.lensModel,
        iso: dto?.iso,
        exposureTime: dto?.exposureTime,
        focalLength: dto?.focalLength,
        fStop: dto?.fNumber,
        server: server.serverUrl,
      );

  bool hasDimensions() {
    return width != null && height != null;
  }
}
