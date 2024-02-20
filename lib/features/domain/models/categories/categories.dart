import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tiflo_tv/features/domain/models/item/item.dart';

part 'categories.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class Categories {
  @HiveField(0)
  // ignore: non_constant_identifier_names
  final int category_id;
  @HiveField(1)
  // ignore: non_constant_identifier_names
  final String category_name;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final String audio;
  @HiveField(4)
  final List<Item> items;

  Categories(
      this.category_id, this.category_name, this.image, this.audio, this.items);
  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}
