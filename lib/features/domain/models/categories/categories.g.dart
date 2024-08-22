// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoriesAdapter extends TypeAdapter<Categories> {
  @override
  final int typeId = 1;

  @override
  Categories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categories(
      fields[1] as int,
      fields[2] as String,
      fields[3] as String?,
      (fields[4] as List?)?.cast<dynamic>(),
      (fields[5] as List?)?.cast<Items>(),
    );
  }

  @override
  void write(BinaryWriter writer, Categories obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.category_id)
      ..writeByte(2)
      ..write(obj.category_name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.audio)
      ..writeByte(5)
      ..write(obj.lessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['image'] as String?,
      json['sound_file'] as List<dynamic>?,
      (json['lessons'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'id': instance.category_id,
      'name': instance.category_name,
      'image': instance.image,
      'sound_file': instance.audio,
      'lessons': instance.lessons,
    };
