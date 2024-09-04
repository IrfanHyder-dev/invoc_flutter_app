import 'package:json_annotation/json_annotation.dart';
import '../interface/JsonObject.dart';
import 'Insight.dart';

part 'RobotoffQuestion.g.dart';

@JsonSerializable()
class RobotoffQuestionResult extends JsonObject {
  final String? status;
  final List<RobotoffQuestion>? questions;

  const RobotoffQuestionResult({this.status, this.questions});

  factory RobotoffQuestionResult.fromJson(Map<String, dynamic> json) =>
      _$RobotoffQuestionResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RobotoffQuestionResultToJson(this);
}

@JsonSerializable()
class RobotoffQuestion extends JsonObject {
  final String? barcode;
  final String? type;
  final String? value;
  final String? question;
  @JsonKey(name: "insight_id")
  final String? insightId;
  @JsonKey(name: "insight_type")
  final InsightType? insightType;
  @JsonKey(name: "source_image_url")
  final String? imageUrl;

  const RobotoffQuestion(
      {this.barcode,
      this.type,
      this.value,
      this.question,
      this.insightId,
      this.insightType,
      this.imageUrl});

  factory RobotoffQuestion.fromJson(Map<String, dynamic> json) {
    InsightType insightType =
        InsightTypesExtension.getType(json["insight_type"]);

    return RobotoffQuestion(
        barcode: json["barcode"],
        type: json["type"],
        value: json["value"],
        question: json["question"],
        insightId: json["insight_id"],
        insightType: insightType,
        imageUrl: json["source_image_url"]);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, String> result = Map<String, String>();

    result["barcode"] = this.barcode!;
    result["type"] = this.type!;
    result["value"] = this.value!;
    result["question"] = this.question!;
    result["insight_id"] = this.insightId!;
    result["insight_type"] = this.insightType!.value!;
    result["insight_url"] = this.imageUrl!;

    return result;
  }
}
