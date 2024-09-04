import 'package:json_annotation/json_annotation.dart';
import 'package:invoc/api/interface/JsonObject.dart';
import 'Product.dart';

part 'SearchResult.g.dart';

@JsonSerializable()
class SearchResult extends JsonObject {
  @JsonKey(name: "current_page", nullable: false, fromJson: JsonObject.parseInt)
  final int? currentPage;


  @JsonKey(name: "total_page", nullable: false)
  final int? totalPageCount;



  @JsonKey(includeIfNull: false)
  final List<Product>? products;

  const SearchResult(
      {this.currentPage,  this.totalPageCount, this.products});

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}