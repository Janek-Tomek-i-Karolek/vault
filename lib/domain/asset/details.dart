import 'package:vault/data/model/asset/exif_response_dto.dart';

class Details {
  // date and localization
  final DateTime? dateTimeOriginala;
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
  final String? exposure;
  final double? focalLength;
  final double? fStop;

  Details({
    required this.dateTimeOriginala,
    required this.timeZone,
    required this.city,
    required this.country,
    required this.fileSizeInByte,
    required this.height,
    required this.width,
    required this.cameraModel,
    required this.lensModel,
    required this.iso,
    required this.exposure,
    required this.focalLength,
    required this.fStop,
  });

  static Details fromDTO(ExifResponseDTO? dto) => Details(
    dateTimeOriginala: dto?.dateTimeOriginal,
    timeZone: dto?.timeZone,
    city: dto?.city,
    country: dto?.country,
    fileSizeInByte: dto?.fileSizeInByte,
    height: dto?.exifImageHeight,
    width: dto?.exifImageWidth,
    cameraModel: dto?.model,
    lensModel: dto?.lensModel,
    iso: dto?.iso,
    exposure: dto?.exposureTime,
    focalLength: dto?.focalLength,
    fStop: dto?.fNumber,
  );
}
