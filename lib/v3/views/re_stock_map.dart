import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../api/model/report_product_model.dart';
import '../../providers/report_product_provider.dart';

class ReStockMap extends StatefulWidget {
  const ReStockMap({Key? key}) : super(key: key);

  @override
  State<ReStockMap> createState() => _ReStockMapState();
}

class _ReStockMapState extends State<ReStockMap> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  static const LatLng showLocation = const LatLng(27.7089427, 85.3086209);
  LatLng? currentLatLng;
  bool isLoading = true;
  String? address;
  String? inStockBy;
  DateTime? inStockTime;
  double? latitude;
  double? longitude;
  DateTime? outStockTime;
  String productCode = '';
  String productName = '';
  String? id;
  int markerId = -1;
  int selectedIndex = -1;
  bool markerClicked = false;
  bool isInitialized = false;
  Marker? previousMarker;
  bool isDisplay = false;
  final ReportProductProvider reportProductProvider =
      Provider.of<ReportProductProvider>(Get.context!);

  @override
  void initState() {
    super.initState();
    if (markers.isEmpty) {
      displayOutOfStockLocation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (markers.isEmpty) {
      displayOutOfStockLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(

              height: height * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: showLocation,
                    zoom: 19.5,
                  ),
                  markers: Set<Marker>.of(markers),
                  mapType: MapType.normal,
                  onCameraMove: (position) {},
                  onTap: (position) {
                    reportProductProvider.isDisplay = false;
                    markerId = -1;
                    setState(() {});
                  },
                  onMapCreated: (controller) {
                    var listData = reportProductProvider.outOfStockProductList;
                    if (!markerClicked) {
                      setState(() {
                        mapController = controller;
                        CameraPosition cameraPosition = new CameraPosition(
                            target: LatLng(
                                listData[0].latitude!, listData[0].longitude!),
                            zoom: 19.5);
                        mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                        if (!isInitialized) {
                          isInitialized = true;
                          updateMarkerColor(0);
                        }
                      });
                    }
                  },
                ),
              ),
            ),
            if (reportProductProvider.outOfStockProductList.isNotEmpty)
              SizedBox(
                height: 10,
              ),
            if (reportProductProvider.outOfStockProductList.isNotEmpty)
              productDetailSlider(width, Get.context!)
          ],
        ),
      ),
    );
  }

  Widget productDetailSlider(double width, BuildContext context) {
    PageController pageController = PageController(viewportFraction: 0.95);

    return Container(
      color: Colors.transparent,
          height: 163,
          child: PageView.builder(

    itemCount: reportProductProvider.outOfStockProductList.length,
    scrollDirection: Axis.horizontal,
    controller: pageController,
    onPageChanged: (int index) {
      pageController.addListener(() {
        if ((pageController.page! - pageController.page!.floor()) == 0.0) {
          setState(() {
            if (markerClicked) {
              selectedIndex = markerId;
            } else {
              selectedIndex = index;
            }
          });
          if (markerClicked == false) {
            updateCameraPosition();
          }
          setState(() {
            markerClicked = false;
          });
        }
      });
    },
    itemBuilder: (context, index) {
      if (markerClicked) {
        pageController.animateToPage(markerId,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
      return Card(
        color: Colors.white,
        elevation: 5,
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Center(
                      child: Text(
                        productDetailKey.tr,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                      width: width,
                      //color: Colors.grey,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //width: width * 0.2,
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
                                  // color: Colors.red,
                                  //width: width * 0.2,
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
                                  reportProductProvider
                                      .outOfStockProductList[index]
                                      .productName!,
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
                                  //width: width * 0.53,
                                  child: Text(
                                    reportProductProvider
                                        .outOfStockProductList[index]
                                        .productCode!,
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
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 00),
                      width: 120,
                      height: 35,
                      // Report button at the bottom of the map
                      child: TextButton(
                        onPressed: () {
                          var listData =
                              reportProductProvider.outOfStockProductList;
                          DateTime currentDate = DateTime.now();
                          ReportProductModel reportProductModel =
                              ReportProductModel(
                                  inStockBy: 'admin',
                                  inStockTime: currentDate,
                                  id: listData[index].id,
                                  productName: listData[index].productName,
                                  productCode: listData[index].productCode,
                                  outStockTime: listData[index].outStockTime,
                                  longitude: listData[index].longitude,
                                  latitude: listData[index].latitude,
                                  address: listData[index].address);
                          reportProductProvider
                              .updateOutOfStockProduct(
                                  reportProductModel: reportProductModel)
                              .then((_) {
                            setState(() {
                              selectedIndex = index - 1;
                              updateCameraPosition();
                            });
                          });
                          reportProductProvider.isDisplay = false;
                        },
                        child: Text(
                          reStockKey.tr,
                          style: TextStyle(color: Colors.red, fontSize: 17),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
          ),
        );
  }

  void updateCameraPosition() {
    updateMarkerColor(selectedIndex);
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(
            reportProductProvider.outOfStockProductList[selectedIndex].latitude!,
            reportProductProvider
                .outOfStockProductList[selectedIndex].longitude!),
        zoom: 19.5);
    mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void displayOutOfStockLocation({GoogleMapController? controller}) {
    var listData = reportProductProvider.outOfStockProductList;
    markers.clear();
    for (int i = 0; i < listData.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId("$i"),
          position: LatLng(listData[i].latitude!, listData[i].longitude!),
          onTap: () {
            setState(() {
              markerId = i;
              markerClicked = true;
              updateMarkerColor(markerId);
              reportProductProvider.markerColor = i;
            });
          },
        ),
      );
    }
  }

  void updateMarkerColor(markerId) {
    setState(() {
      if (previousMarker != null) {
        markers.remove(previousMarker);
        markers.add(previousMarker!.copyWith(
          iconParam:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }

      Marker selectedMarker = markers.firstWhere(
        (marker) => marker.markerId.value == '$markerId',
      );

      if (selectedMarker != null) {
        markers.remove(selectedMarker);
        markers.add(selectedMarker.copyWith(
          iconParam:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
        previousMarker =
            selectedMarker; // Set the newly clicked marker as the previous marker
      }
    });
  }
}
