import 'package:json_annotation/json_annotation.dart';

part 'about_us.g.dart';

@JsonSerializable()
class AboutUs {
  @JsonKey(name: 'first_section_text')
  final String firstText;
  @JsonKey(name: 'second_section_text')
  final String secondText;

  factory AboutUs.fromJson(Map<String, dynamic> json) =>
      _$AboutUsFromJson(json);

  AboutUs(this.firstText, this.secondText);
  Map<String, dynamic> toJson() => _$AboutUsToJson(this);
}
