// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      json['id'] as int,
      json['name'] as String,
      json['image'] as String?,
      json['sound_file'] as List<dynamic>?,
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'id': instance.category_id,
      'name': instance.category_name,
      'image': instance.image,
      'sound_file': instance.audio,
    };
