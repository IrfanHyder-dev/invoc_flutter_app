// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryNutriScore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryNutriScore _$CategoryNutriScoreFromJson(Map<String, dynamic> json) {
  return CategoryNutriScore(
    category: json['category:'] as String,
    scores: (json['score'] as List)
        .map((e) => (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, e as int),
            ))
        .toList(),
  );
}

Map<String, dynamic> _$CategoryNutriScoreToJson(CategoryNutriScore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('category:', instance.category);
  writeNotNull('score', instance.scores);
  return val;
}
