import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:invoc/api/model/report_product_model.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

class ReportProductProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ReportProductModel> outOfStockProductList = [];
  List<ReportProductModel> dataForChart = [];
  List<ReportProductModel> outOfStockProductForUser = [];
  ReportProductModel? updateExistingReportProductModel;
  final Set<Marker> osaMarkers = new Set();
  int markerId = -1;
  String? productName;
  String? productCode;
  LatLng? currentLatLng;
  bool isDisplay = false;
  bool showToast = false;
  bool isDataLoad = false;
  var isLocationSame = false;
  int markerColor = -1;
  LatLng? latLng;

  Future<void> sendReportProduct(ReportProductModel reportProductModel) async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection("outOfStock");
      QuerySnapshot snapshot = await ref
          .where("productCode", isEqualTo: reportProductModel.productCode)
          .where("inStockTime", isNull: true)
          .get();
      List data = snapshot.docs.map((doc) => doc.data()).toList();
      if (snapshot.docs.length == 0) {
        isLocationSame = false;
      } else {
        for (int i = 0; i < data.length; i++) {
          ReportProductModel filterData = ReportProductModel.fromMap(data[i]);
          isLocationSame = await areCoordinatesInSameArea(
            existingLat: filterData.latitude!,
            existingLng: filterData.longitude!,
            currentLat: reportProductModel.latitude!,
            currentLng: reportProductModel.longitude!,
            currentEmail: reportProductModel.email!,
            existingEmail: filterData.email!,
            range: 100,
          );
          if (isLocationSame == true) {
            updateExistingReportProductModel = filterData;
            break;
          }
        }
      }
      if (isLocationSame == false) {
        await ref
            .doc(reportProductModel.id)
            .set(reportProductModel.toMap(),SetOptions(merge: true),)
            .then((value) {
          Navigator.of(Get.context!).pop();
          MotionToast.success(
            description: Text(reportSuccessfullyKey.tr),
            height: 60,
            width: 300,
          ).show(Get.context!);
          notifyListeners();
        }).onError((error, stackTrace) {
          Navigator.of(Get.context!).pop();
          MotionToast.success(
            description: Text('Please report product again'),
            height: 60,
            width: 300,
          ).show(Get.context!);
          notifyListeners();
        });
      } else {
        bool isWithIn4Hours =
        checkProductOutOfStockTimeDifference(updateExistingReportProductModel!.outStockTime!);
        if(!isWithIn4Hours){
          updateExistingReportProductModel?.outStockTime = DateTime.now();
          await _db
              .collection("outOfStock")
              .doc(updateExistingReportProductModel?.id)
              .update(updateExistingReportProductModel!.toMap())
              .then((value) {
            Navigator.of(Get.context!).pop();
            MotionToast.success(
                    description: Text(reportSuccessfullyKey.tr),
                    height: 60,
                    width: 300)
                .show(Get.context!);
            notifyListeners();
          }).onError((error, stackTrace) {
            Navigator.of(Get.context!).pop();
            MotionToast.success(
                    description: Text('$error'),
                    height: 60,
                    width: 300)
                .show(Get.context!);
            notifyListeners();
          });
        }else{
          Navigator.of(Get.context!).pop();
          MotionToast.success(
              description: Text(reportSuccessfullyKey.tr),
              height: 60,
              width: 300)
              .show(Get.context!);
          notifyListeners();
        }
      }
    } catch (e) {
      Navigator.of(Get.context!).pop();
      MotionToast.error(
        description: Text('$e'),
        height: 60,
        width: 300,
      ).show(Get.context!);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getOutOfStockProducts() async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection("outOfStock");
      QuerySnapshot snapshot =
          await ref.where("inStockTime", isNull: true).get();
      List allData = snapshot.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < allData.length; i++) {
        ReportProductModel reportProductModel =
            ReportProductModel.fromMap(allData[i]);
        outOfStockProductList.add(reportProductModel);
      }
    } catch (e) {
      MotionToast.error(description: Text('$e'), height: 60, width: 300)
          .show(Get.context!);
      notifyListeners();
    }
  }

  Future<void> updateOutOfStockProduct(
      {required ReportProductModel reportProductModel}) async {
    try {
      loader(Get.context!);
      await _db
          .collection("outOfStock")
          .doc(reportProductModel.id)
          .update(reportProductModel.toMap());
      outOfStockProductList
          .removeWhere((product) => product.id == reportProductModel.id);
      Navigator.of(Get.context!).pop();
      MotionToast.success(
              description: Text(reStockSuccessfullyKey.tr),
              height: 60,
              width: 300)
          .show(Get.context!);
      notifyListeners();
    } catch (e) {
      MotionToast.error(description: Text('$e'), height: 60, width: 300)
          .show(Get.context!);
      notifyListeners();
    }
  }

  Future<void> fetchChartData({required String productBarCode}) async {
    DateTime startDate = DateTime.now(); // Specify the start date of the week
    DateTime endDate = startDate.add(Duration(days: 6));
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection("outOfStock");
      QuerySnapshot snapshot = await ref
          .where("productCode", isEqualTo: productBarCode)
          .where("outStockTime", isGreaterThanOrEqualTo: startDate)
          .where("outStockTime", isLessThanOrEqualTo: endDate)
          .get();
      List allData = snapshot.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < allData.length; i++) {
        ReportProductModel reportProductModel =
            ReportProductModel.fromMap(allData[i]);
        dataForChart.add(reportProductModel);
      }
    } catch (e) {
      print('error found in chart data $e');
    }
  }

  Future<void> fetchOSAProductForUser({required String productCode}) async {
    await getCurrentLocation();
    isDataLoad = false;
    latLng = null;
    notifyListeners();
    try {
      outOfStockProductForUser.clear();
      CollectionReference ref =
          FirebaseFirestore.instance.collection("outOfStock");
      QuerySnapshot snapshot =
          await ref.where("inStockTime", isNull: true).get();
      List allData = snapshot.docs.map((doc) => doc.data()).toList();
      List<ReportProductModel>? list;
      for (int i = 0; i < allData.length; i++) {
        ReportProductModel filterData = ReportProductModel.fromMap(allData[i]);
        bool isWithIn4Hours =
            checkProductOutOfStockTimeDifference(filterData.outStockTime!);
        if (isWithIn4Hours) {
          isLocationSame = await areCoordinatesInSameArea(
            range: 500,
            currentLat: currentLatLng?.latitude ?? 0.0,
            currentLng: currentLatLng?.longitude ?? 0.0,
            existingLat: filterData.latitude!,
            existingLng: filterData.longitude!,
          );
          ///outOfStockProductForUser.add(filterData);
          if (isLocationSame) {
            outOfStockProductForUser.add(filterData);
          }
        }
      }
      if (outOfStockProductForUser.length > 0) {
        latLng = LatLng(outOfStockProductForUser[0].latitude!,
            outOfStockProductForUser[0].longitude!);
      }
      await osaProductMarkers();
      isDataLoad = true;
      notifyListeners();
    } catch (e) {
      print('error found in fetch out of stock for user $e');
    }
  }

  Future<void> osaProductMarkers() async {
    var listData = outOfStockProductForUser;
    var updatedMarkers = Set<Marker>();
    for (int i = 0; i < listData.length; i++) {
      updatedMarkers.add(
        Marker(
          markerId: MarkerId("$i"),
          onTap: () {
            productName = listData[i].productName;
            productCode = listData[i].productCode;
            notifyListeners();
          },
          position: LatLng(listData[i].latitude!, listData[i].longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerId == i
              ? BitmapDescriptor.hueBlue
              : BitmapDescriptor.hueRed),
        ),
      );
    }

    osaMarkers.clear();
    osaMarkers.addAll(updatedMarkers);
  }

  Future<bool> areCoordinatesInSameArea({
    required double existingLat,
    required double existingLng,
    required double currentLat,
    required double currentLng,
    required double range,
    String? currentEmail,
    String? existingEmail,
  }) async {
    /// Create two Location objects for the coordinates
    final LocationData existingLocation = LocationData.fromMap({
      "latitude": existingLat,
      "longitude": existingLng,
    });
    final LocationData currentLocation = LocationData.fromMap({
      "latitude": currentLat,
      "longitude": currentLng,
    });

    /// Calculate the distance between the two points in meters
    final double distance = await Geolocator.distanceBetween(
      existingLocation.latitude!,
      existingLocation.longitude!,
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    /// Define a threshold distance for considering the coordinates in the same area
    final double areaThreshold = range;

    /// Set your desired threshold distance in meters

    /// Compare the distance with the threshold and determine if the coordinates are in the same area
    if (distance <= areaThreshold && existingEmail == currentEmail) {
      return true;
    } else {
      return false;
    }
  }

  Future<Future> loader(BuildContext context1) async {
    return Get.dialog(Center(
      child: CircularProgressIndicator(),
    ));
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((value) {
      currentLatLng = LatLng(value.latitude, value.longitude);
    });
    notifyListeners();
  }

  bool checkProductOutOfStockTimeDifference(DateTime outOfStockTime) {
    DateTime currentDateTime = DateTime.now();
    Duration timeDifference = currentDateTime.difference(outOfStockTime);
    if (timeDifference.inMinutes < 240) {
      return true;
    } else {
      return false;
    }
  }

  void onOsaMapDispose() {
    isDataLoad = false;
  }
}
