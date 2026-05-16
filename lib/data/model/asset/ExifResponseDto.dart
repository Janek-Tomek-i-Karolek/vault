class ExifResponseDTO {
  final String? city;
  final String? country;
  final DateTime? dateTimeOriginal;
  final String? description;
  final int? exifImageHeight;
  final int? exifImageWidth;
  final String? exposureTime;
  final double? fNumber;
  final int? fileSizeInByte;
  final double? focalLength;
  final int? iso;
  final double? latitude;
  final String? lensModel;
  final double? longitude;
  final String? make;
  final String? model;
  final DateTime? modifyDate;
  final String? orientation;
  final String? projectionType;
  final int? rating;
  final String? state;
  final String? timeZone;

  ExifResponseDTO({
    this.city,
    this.country,
    this.dateTimeOriginal,
    this.description,
    this.exifImageHeight,
    this.exifImageWidth,
    this.exposureTime,
    this.fNumber,
    this.fileSizeInByte,
    this.focalLength,
    this.iso,
    this.latitude,
    this.lensModel,
    this.longitude,
    this.make,
    this.model,
    this.modifyDate,
    this.orientation,
    this.projectionType,
    this.rating,
    this.state,
    this.timeZone,
  });
}
