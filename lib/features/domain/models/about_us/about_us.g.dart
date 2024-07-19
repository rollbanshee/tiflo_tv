// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutUs _$AboutUsFromJson(Map<String, dynamic> json) => AboutUs(
      json['first_section_text'] as String,
      json['second_section_text'] as String,
      (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$AboutUsToJson(AboutUs instance) => <String, dynamic>{
      'first_section_text': instance.firstText,
      'second_section_text': instance.secondText,
      'version': instance.version,
    };
