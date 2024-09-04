import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:invoc/pages/scanner_page.dart';
import 'package:invoc/providers/product_provider.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v2/single_page.dart';
import 'package:invoc/v3/ProductOverViewV3.dart';
import 'package:invoc/v3/product_details.dart';
import 'package:invoc/v3/product_details_v3.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../ui_view/InvocSearchPageRoute.dart';

class ProductsListPage extends StatefulWidget {
  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage>
    with SingleTickerProviderStateMixin {
  GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  final ScrollController _scrollController = ScrollController();

  AnimationController? _animationController;
  PanelController slidingPanelController = PanelController();

  /// The offset applied on the Products list widget when presenting the scanner
  /// behind.
  Animation<Offset>? _transitionProductsListOffset;
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  bool initial = false;
  bool isDragable = true;
  bool showUI = false;
  ScannerPage? _scannerPage;
  Position? _currentLocation;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData(){
    initial = true;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _transitionProductsListOffset =
        Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.85)).animate(
            CurvedAnimation(
                curve: Curves.easeInOut, parent: _animationController!));
    _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
    _scannerPage = ScannerPage(
      closeCall: _popIt,
    );
    _getCurrentLocation();
    setState(() {
      showUI = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController!.dispose();

    super.dispose();
  }

  Widget _buildEmptyProductsPlaceholder() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(32.0),
            topRight: const Radius.circular(32.0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text(
                      benchmarkScopeKey.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: InvocAppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.1,
                        color: InvocAppTheme.darkText,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      invocLaterKey.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: InvocAppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.1,
                        color: Colors.black.withOpacity(0.6),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              showInvocSearch(
                  context: Get.context!,
                  delegate: ProductSearchDelegate(_animationController!));
            },
            child: Container(
              height: 35,
              //width: 110,
              padding: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    searchKey.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: InvocAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: -0.1,
                      height: 1,
                      color: InvocAppTheme.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: InvocAppTheme.nearlyBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDragView() {
    print('4444444444444444444444444444444444444444  ${DateTime.now()}');
    ProductProvider provider = Provider.of<ProductProvider>(Get.context!);
    if (initial) {
      provider.reset();
      initial = false;
    }
    // if(provider.isDataLoad == true)
    // {
    if(true == true){
      print(
          'data data data ${provider.loading} ');

      BorderRadiusGeometry radius = BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0));
      Widget pageContent;
      Widget completeDetails;
      bool visibilty = false;
      bool draggable = false;

      if (provider.loading) {
        visibilty = true;
        draggable = false;
        pageContent = Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(32.0),
                topRight: const Radius.circular(32.0),
              )),
          child: Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  'assets/images/bunny.gif',
                  height: 125.0,
                  width: 125.0,
                )),
          ),
        );
        completeDetails = Container();
      } else if (provider.error) {
        pageContent = _buildEmptyProductsPlaceholder();
        completeDetails = Container();
        visibilty = true;
        draggable = false;
      } else if (provider.clusterAndProduct != null) {

        {
          closeCamera();
          // print('cluster products ${provider.clusterAndProduct.cluster!.productReference}');
          print('================== cluster products ${provider.clusterAndProduct!.product!.code} ${provider.clusterAndProduct!.product!.images} ${provider.clusterAndProduct!.product!.productName}  ${provider.clusterAndProduct!.product!.code}');
          visibilty = true;
          draggable = true;
          pageContent = ProductOverViewV3(provider.clusterAndProduct!.product!);
          completeDetails =
              ProductDetails(clusterAndProduct: provider.clusterAndProduct);
          // DialogTestScreen();
          // ProductDetailPageV3(product: provider.clusterAndProduct,);
        }
      } else {
        return Container();
      }

      return
         // Align(alignment: Alignment.bottomCenter,child: DialogTestScreen());
        Visibility(
          visible: visibilty,
          child: SlidingUpPanel(
            color: Colors.transparent,
            backdropEnabled: true,
            backdropColor: Colors.transparent,
            backdropOpacity: 1.0,
            controller: slidingPanelController,
            onPanelClosed: openCamera,
            onPanelOpened: closeCamera,
            panel: completeDetails,
            boxShadow: null,
            body: null,
            minHeight: 280,
            maxHeight: MediaQuery.of(Get.context!).size.height,
            collapsed: pageContent,
            borderRadius: radius,
            isDraggable: draggable,
            header: Container(
              color: Colors.transparent,
            ),
            onPanelSlide: (val) {
              setState(() {});
            },
          ));
    }else{
      return Container();
    }
  }

  void _popIt() {
    Navigator.of(Get.context!).pop();
  }

  void closeCamera() {
    isDragable = false;
    if (_scannerPage != null) {
      _scannerPage!.scannerPageState.controller.pauseCamera();
    }
  }

  void openCamera() {
    isDragable = true;
    if (_scannerPage != null) {
      _scannerPage!.scannerPageState.controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (showUI)? AnimatedBuilder(
      animation: _animationController!,
      // child is not used since transition widgets are nested deeper
      builder: (BuildContext context, _) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Stack(
            children: <Widget>[_scannerPage!, _buildProductDragView()],
          ),
        );
      },
    ) : Container(child: CircularProgressIndicator(),);
  }

  Future<bool> _onWillPop() async {
    if (slidingPanelController.isAttached &&
        slidingPanelController.isPanelOpen) {
      slidingPanelController.close();
      return false;
    } else {
      return true;
    }
  }

  Future<bool> _dialogOnWillPop(BuildContext context) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    return true;
  }

  _getCurrentLocation() async {
    geolocator.checkPermission().asStream().listen((event) async {
      if (event == LocationPermission.denied) {
        //show popup to enable it
        _showDialogForLocation(
            locationPermissionKey.tr, provideLocationKey.tr, 0);
      } else if (event == LocationPermission.deniedForever) {
        _showDialogForLocation(
            locationPermissionKey.tr, provideLocationKey.tr, 1);
      } else {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          fetchLocation();
        } else {
          Navigator.pop(Get.context!);
        }
      }
    });
  }

  Future<void> fetchLocation() async {
    bool permission = await Geolocator.isLocationServiceEnabled();
    if (permission) {
      return;
    }
    await geolocator
        .getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
        .then((position) {
      SharedPreferences.getInstance().then((value) {
        value.setDouble('lat', position.latitude);
        value.setDouble('long', position.longitude);
      });
      setState(() {
        _currentLocation = position;
      });
    }).onError((error, stackTrace) {
      Navigator.pop(Get.context!);
      MotionToast.error(
              description: Text(provideLocationKey.tr), height: 60, width: 300)
          .show(Get.context!);
    });
  }

  void _showDialogForLocation(String title, String message, int type) {
    // flutter defined function
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop:()=> _dialogOnWillPop(context),
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              // TextButton(
              //   child: Text(closeKey.tr),
              //   onPressed: () {
              //     Navigator.of(Get.context!).pop();
              //   },
              // ),
              TextButton(
                  onPressed: () async {
                    if (type == 1) {
                      //open settings
                      Navigator.of(Get.context!).pop();
                      await geolocator.openAppSettings();
                    } else {
                      Navigator.of(Get.context!).pop();
                      await geolocator.requestPermission().then((value) {
                        if (value == LocationPermission.always ||
                            value == LocationPermission.whileInUse) {
                          fetchLocation();
                        }
                      });
                    }
                  },
                  child: type == 0 ? Text(okKey.tr) : Text(openSettingKey.tr))
            ],
          ),
        );
      },
    );
  }
}
