import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'items.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class Items {
  @HiveField(1)
  final int? id;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  @JsonKey(name: 'video_link')
  final String? link;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final String? image;
  @HiveField(6)
  @JsonKey(name: 'sound_file')
  final List<dynamic>? audio;
  @HiveField(7)
  @JsonKey(name: 'view_count')
  String? views;
  @HiveField(8)
  @JsonKey(name: 'created_at')
  final String? date;

  Items(this.id, this.name, this.link, this.description, this.image, this.audio,
      this.views, this.date);
  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}
