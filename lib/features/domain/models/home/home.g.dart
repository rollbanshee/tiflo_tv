// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Home _$HomeFromJson(Map<String, dynamic> json) => Home(
      (json['sliders'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['lessons'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['version'] as int,
    );

Map<String, dynamic> _$HomeToJson(Home instance) => <String, dynamic>{
      'sliders': instance.sliders?.map((e) => e.toJson()).toList(),
      'lessons': instance.lessons?.map((e) => e.toJson()).toList(),
      'version': instance.version,
    };
