import 'package:json_annotation/json_annotation.dart';

part 'CategoryNutriScore.g.dart';

@JsonSerializable()
class CategoryNutriScore{

  @JsonKey(name:'category:',includeIfNull: false)
  String category;

  @JsonKey(name:'score',includeIfNull: false)
  List<Map<String, int>> scores ;


  CategoryNutriScore({required this.category, required this.scores});

  factory CategoryNutriScore.fromJson(Map<String, dynamic> json) =>
      _$CategoryNutriScoreFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryNutriScoreToJson(this);
}