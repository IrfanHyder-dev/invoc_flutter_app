import 'package:invoc/api/model/firestore_cluster.dart';
import 'package:invoc/api/model/firestore_product.dart';

class FirestoreClusterAndProduct{
  FirestoreProduct? product;
  FirestoreCluster? cluster;

  FirestoreClusterAndProduct(this.product, this.cluster);

}