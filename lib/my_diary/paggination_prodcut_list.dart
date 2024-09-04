import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_cluster.dart';
import 'package:invoc/api/model/firestore_cluster_product.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/api/model/parameter/SearchEnum.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/ui_view/product_shimmer_view.dart';
import 'package:invoc/utils/PathUtils.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v3/product_details.dart';
import 'package:invoc/v3/views/product_item_v3.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class PaginationProductList extends StatefulWidget {
  final Animation<dynamic>? mainScreenAnimation;
  final String? productCode;
  final PaginationListingType? searchType;

  const PaginationProductList(
      {this.mainScreenAnimation, this.productCode, this.searchType});

  @override
  _PaginationProductList createState() => _PaginationProductList();
}

class _PaginationProductList extends State<PaginationProductList>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int? currentPage;
  int? totalPageCount;

  @override
  void initState() {
    currentPage = 0;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget buildShimmerList() {
    return ListView.builder(
        itemCount: 6,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (_, __) => ProductShimmerView());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getFirestoreFuture(),
      builder: (context, snapshot) {
        List<FirestoreProduct> products = <FirestoreProduct>[];

        if (snapshot.hasData) {
          try {
            if (snapshot.data != null) {
              snapshot.data!.docs.forEach((element) {
                // var data = FirestoreProduct.fromJson(element.data());

                FirestoreProduct? fireStoreData =
                    FirestoreProduct.fromJson(element.data());
                if (fireStoreData != null) {
                  FirestoreProduct data = fireStoreData;
                  if (data.nutriscoreScore != null &&
                      data.nutriments!.energyKcalValue != null
                      && data.images != null
                  ) {
                    products.add(data);
                  }
                }
              });
            }
            if (products.isEmpty) {
              return _buildErrorOrEmptyContainer();
            } else {
              return _buildFirestoreProductListView(products);
            }
          } catch (e) {
            return _buildErrorOrEmptyContainer();
          }
        } else if (snapshot.hasError) {
          return _buildErrorOrEmptyContainer();
        }
        return buildShimmerList();
      },
    );
  }

  String getErrorMessage() {
    var errorMessage;
    switch (widget.searchType) {
      case PaginationListingType.NAME:
        errorMessage = nameErrorMsgKey.tr;
        break;
      case PaginationListingType.CATEGORY:
        errorMessage = categoryErrorMsgKey.tr;
        break;
      case PaginationListingType.UNDEFINED:
        errorMessage = undefinedErrorMsgKey.tr;
        break;
    }

    return errorMessage;
  }

  Future<QuerySnapshot<Object>> getFirestoreFuture() {
    var result = FirebaseFirestore.instance
        .collection('product')
        .where('keywords', arrayContains: widget.productCode!.toLowerCase())
        .where('product_name', isNotEqualTo: '')
        .orderBy('product_name')
        .limit(20)
        .get();
    return result;
  }

  Widget _buildErrorOrEmptyContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Center(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              getErrorMessage(),
              style: TextStyle(
                fontFamily: InvocAppTheme.fontName,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.2,
                color: InvocAppTheme.dark_grey,
              ),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }

  Widget _buildFirestoreProductListView(List<FirestoreProduct> products) {
    return Container(
      child: ListView.separated(
        itemCount: products.length,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: ProductItem(
              product: products[index],
            ),
            onTap: () {
              print('barcodddddddddddddddde ${ products[index].code}  ${ products[index].activeEanNumber}');
              _loadProductDetailsFromFlutter(products[index]);
            },
          );
        },
      ),
    );
  }

  _loadProductDetailsFromFlutter(FirestoreProduct product) async {
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
    await FirebaseFirestore.instance
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

      Navigator.push(
        Get.context!,
        MaterialPageRoute(
            builder: (context) => ProductDetailPageV3(
                  product: firestoreClusterAndProduct,
                )),
      );
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
