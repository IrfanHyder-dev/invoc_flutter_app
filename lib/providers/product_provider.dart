import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:invoc/api/InvocAPIClient.dart';
import 'package:invoc/api/model/Product.dart';
import 'package:invoc/api/model/firestore_cluster.dart';
import 'package:invoc/api/model/firestore_cluster_product.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/database/LocalData.dart';

import 'package:invoc/utils/PathUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  bool loading = false;
  bool isDataLoad = false;
  Product? _product;

  Product get product => _product!;
  FirestoreProduct? _firestoreProduct;

  FirestoreProduct get firestoreProduct => _firestoreProduct!;
  FirestoreClusterAndProduct? _firestoreClusterAndProduct;

  FirestoreClusterAndProduct? get clusterAndProduct {
    if (_firestoreClusterAndProduct != null) {
      return _firestoreClusterAndProduct!;
    }else{return null;}
  }

  bool error = false;
  bool isScroll = true;
  FullProductsDatabase productsDatabase = FullProductsDatabase();

  Future findProductFromBarcode(String barcode) async {
    error = false;
    loading = true;
    isDataLoad = false;
    notifyListeners();
    FirebaseAnalytics.instance
        .logEvent(name: 'scan', parameters: {'Value': barcode});
    FirebaseFirestore.instance
        .collection('product')
        .doc(barcode)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      ///make here the cluster string

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        FirestoreProduct tempProduct =
            FirestoreProduct.fromJson((documentSnapshot.data()));
        print('1111111111111111111111 ${tempProduct.activeEanNumber}    ${tempProduct.images}');
        if (tempProduct.activeEanNumber == false || tempProduct.images == null) {
          error = true;
          loading = false;
          isDataLoad = true;
          notifyListeners();
        } else {
          PathUtils pathUtils = PathUtils(tempProduct);
          FirebaseFirestore.instance
              .collection('clustered_prod')
              .doc(pathUtils.getPath())
              .get()
              .then((DocumentSnapshot clusterValue) {
            FirestoreProduct firestoreProduct =
                FirestoreProduct.fromJson(documentSnapshot.data());

              if (clusterValue.data() == null) {

                error = true;
                loading = false;
                isDataLoad = true;
                notifyListeners();
              } else {

                productsDatabase.saveFirestoreProduct(documentSnapshot.data());
                FirestoreCluster firestoreCluster =
                      FirestoreCluster.fromJson(clusterValue.data());
                FirestoreClusterAndProduct firestoreClusterAndProduct =
                FirestoreClusterAndProduct(
                    firestoreProduct, firestoreCluster);
                _firestoreClusterAndProduct = firestoreClusterAndProduct;
                loading = false;
                error = false;
                isDataLoad = true;
                notifyListeners();
                setUserScanProduct(firestoreClusterAndProduct.product!);
              }
          }).catchError((onError) {
            FirestoreProduct product =
                FirestoreProduct.fromJson(documentSnapshot.data());
            FirestoreClusterAndProduct firestoreClusterAndProduct =
                FirestoreClusterAndProduct(product, null);
            if (firestoreClusterAndProduct == null) {
              error = true;
              loading = false;
              isDataLoad = true;
              notifyListeners();
            } else {
              _firestoreClusterAndProduct = firestoreClusterAndProduct;
              loading = false;
              error = false;
              isDataLoad = true;
              notifyListeners();
              setUserScanProduct(firestoreClusterAndProduct.product!);
            }
          });
        }
      } else {
        FirebaseAnalytics.instance.logEvent(
            name: 'product_not_available', parameters: {'Value': barcode});
        error = true;
        loading = false;
        isDataLoad = true;
        notifyListeners();
      }
    }).catchError((onError) async {
      ///try to fetch from localDB
      await productsDatabase.getFirestoreProduct(barcode).then((value) {
        FirestoreProduct product = value!;
        FirestoreClusterAndProduct firestoreClusterAndProduct =
            FirestoreClusterAndProduct(product, null);
        if (firestoreClusterAndProduct == null) {
          error = true;
          loading = false;
          isDataLoad = true;
          notifyListeners();
        } else {
          _firestoreClusterAndProduct = firestoreClusterAndProduct;
          loading = false;
          error = false;
          isDataLoad = true;
          notifyListeners();
        }
      }).catchError((onError) {
        print('data from local $onError');
        error = true;
        loading = false;
        isDataLoad = true;
        notifyListeners();
      });
    });
  }

  void setUserScanProduct(FirestoreProduct product) {
    SharedPreferences.getInstance().then((value) async {
      bool? login = value.getBool('login');
      String? userId = value.getString('userId');
      double? _lat = value.getDouble('lat');
      double? _long = value.getDouble('long');

      if (login != null && login) {
        if (_lat != null && _long != null) {
          GeocodingPlatform.instance
              .placemarkFromCoordinates(_lat, _long)
              .then((placeMarks) {
            if (placeMarks != null && placeMarks.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection('scans')
                  .doc(userId)
                  .collection('products')
                  .add({
                'code': product.code,
                'category': product.mainCategory,
                'locationLat': _lat,
                'locationLong': _long,
                'timestamp': DateTime.now(),
                'address': placeMarks.first.toJson()
              }).then((value) => {print(value.id)});
            }
          }).catchError((onError) {
            FirebaseFirestore.instance
                .collection('scans')
                .doc(userId)
                .collection('products')
                .add({
              'code': product.code,
              'category': product.mainCategory,
              'locationLat': _lat,
              'locationLong': _long,
              'timestamp': DateTime.now(),
            }).then((value) => {print(value.id)});
          });
        } else {
          FirebaseFirestore.instance
              .collection('scans')
              .doc(userId)
              .collection('products')
              .add({
            'code': product.code == null ? null : product.code,
            'category': product.mainCategory,
            'timestamp': DateTime.now()
          }).then((value) => {print(value.id)});
        }
      }
    });
  }

  void reset() {
    _product = null;
    _firestoreProduct = null;
    _firestoreClusterAndProduct = null;
    loading = false;
    error = false;
    isDataLoad = false;
  }

  @override
  void dispose() {
    _product = null;
    _firestoreProduct = null;
    _firestoreClusterAndProduct = null;
    loading = false;
    error = false;
    super.dispose();
  }
}
