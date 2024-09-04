import 'package:invoc/api/model/firestore_product.dart';

class PathUtils {
  final FirestoreProduct product;

  PathUtils(this.product);

  String getPath() {
    String? category =
        this.product.mainCategory == null ? '' : this.product.mainCategory;
    String? grade = this.product.nutriscoreGrade == null
        ? ''
        : this.product.nutriscoreGrade;
    String? count = this.product.additivesN == null
        ? ''
        : this.product.additivesN.toString();

    print('path utils data is $category    $grade    $count');

    return '$category||$grade||$count';
  }
}
