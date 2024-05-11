// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'categories.g.dart';

@JsonSerializable()
class Categories {
  @JsonKey(name: 'id')
  final int category_id;
  @JsonKey(name: 'name')
  final String category_name;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'sound_file')
  final List? audio;

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Categories(
    this.category_id,
    this.category_name,
    this.image,
    this.audio,
  );
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}
