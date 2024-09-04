
import 'package:invoc/api/model/firestore_product.dart';

class FirestoreCluster{
  List<FirestoreProduct>? productReference;

  FirestoreCluster.fromJson(dynamic json){

    if (json['products'] != null) {
     productReference =  <FirestoreProduct>[];
     json['products'].forEach((v) {
       productReference!.add(FirestoreProduct.fromJson(v));
     });
   }
  }


}