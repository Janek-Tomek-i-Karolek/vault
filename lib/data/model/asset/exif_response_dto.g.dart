// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exif_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExifResponseDTO _$ExifResponseDTOFromJson(Map<String, dynamic> json) =>
    ExifResponseDTO(
      city: json['city'] as String?,
      country: json['country'] as String?,
      dateTimeOriginal: json['dateTimeOriginal'] == null
          ? null
          : DateTime.parse(json['dateTimeOriginal'] as String),
      description: json['description'] as String?,
      exifImageHeight: (json['exifImageHeight'] as num?)?.toInt(),
      exifImageWidth: (json['exifImageWidth'] as num?)?.toInt(),
      exposureTime: json['exposureTime'] as String?,
      fNumber: (json['fNumber'] as num?)?.toDouble(),
      fileSizeInByte: (json['fileSizeInByte'] as num?)?.toInt(),
      focalLength: (json['focalLength'] as num?)?.toDouble(),
      iso: (json['iso'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      lensModel: json['lensModel'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      make: json['make'] as String?,
      model: json['model'] as String?,
      modifyDate: json['modifyDate'] == null
          ? null
          : DateTime.parse(json['modifyDate'] as String),
      orientation: json['orientation'] as String?,
      projectionType: json['projectionType'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      state: json['state'] as String?,
      timeZone: json['timeZone'] as String?,
    );

Map<String, dynamic> _$ExifResponseDTOToJson(ExifResponseDTO instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'dateTimeOriginal': instance.dateTimeOriginal?.toIso8601String(),
      'description': instance.description,
      'exifImageHeight': instance.exifImageHeight,
      'exifImageWidth': instance.exifImageWidth,
      'exposureTime': instance.exposureTime,
      'fNumber': instance.fNumber,
      'fileSizeInByte': instance.fileSizeInByte,
      'focalLength': instance.focalLength,
      'iso': instance.iso,
      'latitude': instance.latitude,
      'lensModel': instance.lensModel,
      'longitude': instance.longitude,
      'make': instance.make,
      'model': instance.model,
      'modifyDate': instance.modifyDate?.toIso8601String(),
      'orientation': instance.orientation,
      'projectionType': instance.projectionType,
      'rating': instance.rating,
      'state': instance.state,
      'timeZone': instance.timeZone,
    };
