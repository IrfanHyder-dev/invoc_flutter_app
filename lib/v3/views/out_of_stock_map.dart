import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/model/report_product_model.dart';
import '../../providers/report_product_provider.dart';

class OutOfStockMap extends StatefulWidget {
  final String? productName;
  final String? productCode;

  OutOfStockMap({this.productName, this.productCode});

  @override
  State<OutOfStockMap> createState() => _OutOfStockMapState();
}

class _OutOfStockMapState extends State<OutOfStockMap> {
  GoogleMapController? mapController; //contrller for Google map
  final Set<Marker> markers = new Set();
  LatLng? showLocation;
  bool btnDisplay = false;
  LatLng? currentLatLng;
  bool isLoading = true;
  String productName = '';
  String productBarCode = '';
  String productId = '';

  final ReportProductProvider reportProductProvider =
      Provider.of<ReportProductProvider>(Get.context!);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Geolocator.getCurrentPosition().then((value) async {
        currentLatLng = LatLng(value.latitude, value.longitude);
        showLocation = LatLng(value.latitude, value.longitude);
        var mark = markers.add(
          Marker(
            markerId: MarkerId('2'),
            position: LatLng(value.latitude, value.longitude),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        fetchCurrentLocation().then(
          (value) => setState(() {
            btnDisplay = true;
          }),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: Consumer<ReportProductProvider>(
          builder: (context, value, child) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.55,
                  child: (btnDisplay)
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GoogleMap(
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: showLocation!,
                              zoom: 21,
                            ),
                            markers: Set<Marker>.of(markers),
                            mapType: MapType.normal,
                            onTap: (LatLng latlng) {
                              markers.clear();
                              currentLatLng =
                                  LatLng(latlng.latitude, latlng.longitude);
                              markers.add(Marker(
                                  markerId: MarkerId('current location marker'),
                                  position:
                                      LatLng(latlng.latitude, latlng.longitude),
                                  icon: BitmapDescriptor.defaultMarker));
                              setState(() {});
                            },
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                if (btnDisplay)
                  SizedBox(
                    height: 8,
                  ),
                if (btnDisplay)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                        width: width,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      nameKey.tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    child: Text(
                                      barcodeKey.tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                    widget.productName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  )),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    child: Text(
                                      widget.productCode!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 00),
                  child: TextButton(
                    onPressed: reportBtnOnTap,
                    child: Text(
                      reportKey.tr,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                          side: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<Future> loader() async {
    return Get.dialog(Center(
      child: CircularProgressIndicator(),
    ));
  }

  Future<void> fetchCurrentLocation({GoogleMapController? cntlr}) async {
    if (markers.isNotEmpty) {
      markers.clear();
    }

    mapController = cntlr;
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    Geolocator.getCurrentPosition().then((value) async {
      currentLatLng = LatLng(value.latitude, value.longitude);
      markers.add(
        Marker(
          markerId: MarkerId('current location marker'),
          position: LatLng(value.latitude, value.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      setState(() {});
      CameraPosition cameraPosition = new CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 19.5);
      mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void reportBtnOnTap() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('email');
    String? userUid = pref.getString('userId');
    print('report button ${email}');
    if (email != null &&
        userUid != null &&
        email.isNotEmpty &&
        userUid.isNotEmpty) {
      DateTime currentDate = DateTime.now();
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      ReportProductModel reportProductModel = ReportProductModel(
        latitude: currentLatLng!.latitude,
        longitude: currentLatLng!.longitude,
        outStockTime: currentDate,
        productCode: widget.productCode,
        id: id,
        productName: widget.productName,
        email: email,
        userUid: userUid,
      );
      reportProductProvider.sendReportProduct(reportProductModel);
      Navigator.pop(context);
      loader();
    } else {
      Navigator.pop(Get.context!);
      showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            child: Wrap(
              children: [
                Container(
                  height: 125,
                  child: Material(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                loginForReportKey.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(okKey.tr)))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
