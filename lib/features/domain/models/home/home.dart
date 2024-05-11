import 'package:json_annotation/json_annotation.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';

part 'home.g.dart';

@JsonSerializable(explicitToJson: true)
class Home {
  final List<Items>? sliders;
  final List<Items>? lessons;
  final int version;
  Home(this.sliders, this.lessons, this.version);
  factory Home.fromJson(Map<String, dynamic> json) => _$HomeFromJson(json);
  Map<String, dynamic> toJson() => _$HomeToJson(this);
}
