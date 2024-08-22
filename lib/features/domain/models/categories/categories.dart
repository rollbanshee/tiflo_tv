// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';

part 'categories.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Categories {
  @HiveField(1)
  @JsonKey(name: 'id')
  final int category_id;
  @HiveField(2)
  @JsonKey(name: 'name')
  final String category_name;
  @HiveField(3)
  @JsonKey(name: 'image')
  final String? image;
  @HiveField(4)
  @JsonKey(name: 'sound_file')
  final List? audio;
  @HiveField(5)
  final List<Items>? lessons;
  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Categories(
    this.category_id,
    this.category_name,
    this.image,
    this.audio,
    this.lessons,
  );
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}
