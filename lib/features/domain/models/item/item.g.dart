// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 1;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      fields[1] as int?,
      fields[2] as int?,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as String?,
      fields[6] as String?,
      fields[7] as String?,
      fields[8] as int?,
      fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.category_id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.link)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.audio)
      ..writeByte(8)
      ..write(obj.views)
      ..writeByte(9)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['id'] as int?,
      json['category_id'] as int?,
      json['name'] as String?,
      json['link'] as String?,
      json['description'] as String?,
      json['image'] as String?,
      json['audio'] as String?,
      json['views'] as int?,
      json['date'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'category_id': instance.category_id,
      'name': instance.name,
      'link': instance.link,
      'description': instance.description,
      'image': instance.image,
      'audio': instance.audio,
      'views': instance.views,
      'date': instance.date,
    };
