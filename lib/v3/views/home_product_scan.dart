import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_cluster.dart';
import 'package:invoc/api/model/firestore_cluster_product.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/providers/product_provider.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/PathUtils.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v3/views/product_item_v3.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import '../product_details.dart';

class HomeProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
        builder: (context, ProductProvider productProvider,Widget? child) {
      return FutureBuilder(
        future: productProvider.productsDatabase.getFirestoreProductList(),
        builder: (context, AsyncSnapshot<List<FirestoreProduct>?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return redPotato();
              } else {
                return ListView.separated(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: ProductItem(
                            product: snapshot.data!.elementAt(index)),
                        onTap: () {
                          _loadProductDetailsFromFlutter(
                              snapshot.data!.elementAt(index), context);
                          //InvocNavigator.goToPreference(context);
                        },
                      );
                    });
              }
            } else {
              return redPotato();
            }
          } else if (snapshot.hasError) {
            return redPotato();
          } else {
            return redPotato();
          }
        },
      );
    });
  }

  Widget redPotato() {
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 200,
                child: Image.asset("assets/images/red_potato.png"),
              ),
              SizedBox(
                height: 20,
              ),
              //Spacer(),
              getTextForScan(),
              //Spacer(),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.subdirectory_arrow_right,
                      color: InvocAppTheme.nearlyDarkBlue, size: 50),
                ),
              ),
            ]));
  }

  Widget getTextForScan() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
      child: Center(
        child: Text(clickToScanKey.tr,
            textAlign: TextAlign.center, style: InvocAppTheme.textCaption),
      ),
    );
  }

  _loadProductDetailsFromFlutter(
      FirestoreProduct product, BuildContext context) {
    // ProgressDialog pr = ProgressDialog(context,
    //     type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    // pr.style(progressWidget: CircularProgressIndicator());
    // pr.show();

    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 70,
          width: 70,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              SizedBox(
                  height: 25, width: 25, child: CircularProgressIndicator()),
              SizedBox(
                width: 15,
              ),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ),
    );

    PathUtils pathUtils = PathUtils(product);
    FirebaseFirestore.instance
        .collection('clustered_prod')
        .doc(pathUtils.getPath())
        .get()
        .then((clusterValue) {
      // pr.hide();
      FirestoreCluster firestoreCluster =
          FirestoreCluster.fromJson(clusterValue.data()!);
      FirestoreClusterAndProduct firestoreClusterAndProduct =
          FirestoreClusterAndProduct(product, firestoreCluster);
      Navigator.of(Get.context!).pop();
      if (firestoreClusterAndProduct != null) {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
              builder: (context) => ProductDetailPageV3(
                    product: firestoreClusterAndProduct,
                  )),
        );
      }
    }).catchError((onError) {
      // pr.hide();
      Navigator.of(Get.context!).pop();
      FirestoreClusterAndProduct firestoreClusterAndProduct =
          FirestoreClusterAndProduct(product, null);
      if (firestoreClusterAndProduct != null) {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
              builder: (context) => ProductDetailPageV3(
                    product: firestoreClusterAndProduct,
                  )),
        );
      }
    });
  }
}
