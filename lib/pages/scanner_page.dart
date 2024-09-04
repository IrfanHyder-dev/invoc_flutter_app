import 'dart:io';
import 'package:get/get.dart';
import 'package:invoc/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/widgets/ShapeCorner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  final isShowButton;
  final VoidCallback? closeCall;

  ScannerPage({ this.closeCall, this.isShowButton = true});

  _ScannerPageState scannerPageState = _ScannerPageState();

  // @override
  // _ScannerPageState createState() => scannerPageState;

  QRViewController get qrController => scannerPageState.controller;

  @override
  State<StatefulWidget> createState() {
    return scannerPageState = _ScannerPageState();
  }
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? _qrViewController;
  bool startFetching = false;
  String _sameQR = "";
  bool isScanned = false;

  QRViewController get controller => _qrViewController!;
  bool flashOpen = false;

  @override
  void dispose() {
    _qrViewController!.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrViewController = controller;
    _qrViewController!.scannedDataStream.listen(_onCodeScanned);
    _qrViewController!.pauseCamera();
    _qrViewController!.resumeCamera();
  }

  Future _onCodeScanned(Barcode code) async {
    if (_sameQR == code.code) {
      return;
    } else {
      setState(() {
        isScanned = true;
      });
      _sameQR = code.code!;
    }
    if (!startFetching) {
      startFetching = true;
      await Provider.of<ProductProvider>(Get.context!, listen: false)
          .findProductFromBarcode(code.code!)
          .whenComplete(() {
        startFetching = false;
      }).catchError((Object error) {
        print(error);
      });
    }
  }

  Widget _buildContinuousScannerWidget() {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: ShapeCorner(
        cutOutSize: 300,
      ),
      overlayMargin: EdgeInsets.only(bottom: (isScanned) ? 200 : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildContinuousScannerWidget(),
          widget.isShowButton == true ? getAppBarUI() : SizedBox(),
          //_buildViewFinderOverlay()
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(children: <Widget>[
      Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(Get.context!).padding.top,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.grey[600],
                                shape: BoxShape.circle),
                            child: InkWell(
                              highlightColor: Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(36.0)),
                              onTap: () {
                                widget.closeCall!();
                              },
                              child: Center(
                                child: Icon(
                                    Platform.isAndroid
                                        ? Icons.arrow_back
                                        : Icons.arrow_back_ios,
                                    color: InvocAppTheme.white,
                                    size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.grey[600], shape: BoxShape.circle),
                      child: InkWell(
                        highlightColor: Colors.grey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(36.0)),
                        onTap: () {
                          controller.toggleFlash();
                          setState(() {
                            if (flashOpen) {
                              flashOpen = false;
                            } else {
                              flashOpen = true;
                            }
                          });
                        },
                        child: Center(
                          child: Icon(
                              flashOpen ? Icons.flash_on : Icons.flash_off,
                              color: InvocAppTheme.white,
                              size: 24),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
