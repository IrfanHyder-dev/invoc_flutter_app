import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:provider/provider.dart';
import '../../providers/report_product_provider.dart';

class OSAMapForUser extends StatefulWidget {
  final LatLng? coordinates;
  final String? productName;
  final String? productCode;


  OSAMapForUser(
      {this.coordinates,
      this.productName,
      this.productCode,
     });

  @override
  State<OSAMapForUser> createState() => _OSAMapForUserState();
}

class _OSAMapForUserState extends State<OSAMapForUser> {
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();
  final ReportProductProvider reportProductProvider =
  Provider.of<ReportProductProvider>(Get.context!);
  LatLng showLocation = const LatLng(27.7089427, 85.3086209);
  LatLng? currentLatLng;
  bool isDataLoad = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData()async{
    await reportProductProvider.fetchOSAProductForUser(
        productCode: widget.productCode ?? "");
  }
  @override
  void dispose() {
    super.dispose();
    reportProductProvider.onOsaMapDispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: Consumer<ReportProductProvider>(
        builder: (context, value, child) {
          print('build build build ${value.isDataLoad}  ${value.currentLatLng}');
          return
            (!value.isDataLoad)
              ? Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              :
            Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: height * 0.55,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GoogleMap(
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationEnabled: false,
                            mapToolbarEnabled: false,
                            compassEnabled: false,
                            buildingsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: (value.outOfStockProductForUser.isEmpty)
                                  ? LatLng(value.currentLatLng?.latitude ?? 0.0,
                                  value.currentLatLng?.longitude ?? 0.0)
                                  : LatLng(value.latLng?.latitude ?? 0.0,
                                      value.latLng?.longitude ?? 0.0),
                              //initial position
                              zoom: 21,
                            ),
                            markers: Set<Marker>.of(value.osaMarkers),
                            mapType: MapType.normal,
                            onCameraMove: (position) {},
                            onTap: (position) {
                              value.isDisplay = false;
                              value.markerId = -1;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      (value.outOfStockProductForUser.length > 0)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                      width: width,
                                      //color: Colors.grey,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  //width: width * 0.2,
                                                  child: Text(
                                                    nameKey.tr,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    //width:constraints.minWidth - 75,
                                                    //color: Colors.red,
                                                    child: Text(
                                                  value.productName ??
                                                      value
                                                          .outOfStockProductForUser[
                                                              0]
                                                          .productName ??
                                                      '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17),
                                                )),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Container(
                                                  //width: width * 0.53,
                                                  child: Text(
                                                    value.productCode ??
                                                        value
                                                            .outOfStockProductForUser[
                                                                0]
                                                            .productCode ??
                                                        '',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 00),
                                  width: 140,
                                  child: TextButton(
                                    //onPressed: reportBtnOnTap,
                                    child: Text(
                                      notAvailableKey.tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          side: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 1.5,
                                          )),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  productNotReportedKey.tr,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
