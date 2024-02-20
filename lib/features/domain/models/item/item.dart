import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class Item {
  @HiveField(1)
  final int? id;
  @HiveField(2)
  // ignore: non_constant_identifier_names
  final int? category_id;
  @HiveField(3)
  final String? name;
  @HiveField(4)
  final String? link;
  @HiveField(5)
  final String? description;
  @HiveField(6)
  final String? image;
  @HiveField(7)
  final String? audio;
  @HiveField(8)
  int? views;
  @HiveField(9)
  final String? date;

  Item(this.id, this.category_id, this.name, this.link, this.description,
      this.image, this.audio, this.views, this.date);
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
