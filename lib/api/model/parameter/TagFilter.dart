
import 'package:invoc/api/interface/Parameter.dart';

class TagFilter extends Parameter {
  @override
  String getName() {
    return "";
  }

  String getTagType() {
    return this.tagType;
  }

  String getContains() {
    return contains ? "contains" : "without";
  }

  String getTagName() {
    return this.tagName;
  }

  @override
  String getValue() {
    return "";
  }

  final String tagType;
  final bool contains;
  final String tagName;

  const TagFilter({required this.tagType, required this.contains, required this.tagName});
}
