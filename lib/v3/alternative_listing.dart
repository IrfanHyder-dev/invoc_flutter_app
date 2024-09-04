import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:invoc/providers/report_product_provider.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/v3/auth/constants/enums.dart';
import 'package:invoc/v3/views/maps_dialog_screen.dart';
import 'package:invoc/api/model/firestore_cluster_product.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/main.dart';
import 'package:invoc/models/meals_list_data.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v2/alternative/components/icon_card.dart';
import 'package:invoc/v3/clipedView.dart';
import 'package:invoc/v3/views/ingredients_chart.dart';
import 'package:provider/provider.dart';

class AlternativeListing extends StatefulWidget {
  final FirestoreClusterAndProduct clusterAndProduct;

  const AlternativeListing(this.clusterAndProduct);

  @override
  AlternativeListingState createState() => AlternativeListingState();
}

class AlternativeListingState extends State<AlternativeListing>
    with TickerProviderStateMixin {
  FirestoreProduct? firestoreProduct;
  List<FirestoreProduct> alternatives = <FirestoreProduct>[];

  int selectedIndex = 0;
  int buttonSelected = 0;
  LatLng? currentLatLng;
  bool isDataLoad = false;
  final ReportProductProvider reportProductProvider =
      Provider.of<ReportProductProvider>(Get.context!);

  @override
  void initState() {
    super.initState();
    if (GlobalVariables.userRole == UserRole.admin) {
      reportProductProvider.getOutOfStockProducts();
    }
    print(
        '====  AlternativeListing =========== ${alternatives.length}  ===== clusterProduct == ${widget.clusterAndProduct.cluster?.productReference?.length}');
    if (widget.clusterAndProduct.cluster != null) {
      if (widget.clusterAndProduct.cluster!.productReference != null) {
        if (widget.clusterAndProduct.cluster != null &&
            widget.clusterAndProduct.cluster!.productReference!.isNotEmpty) {
          setState(() {
            listSorting(widget.clusterAndProduct.cluster!.productReference!);
            firestoreProduct = widget.clusterAndProduct.product;
            String codeTocompare = firestoreProduct!.code!;
            selectedIndex = alternatives
                .indexWhere((element) => element.code == codeTocompare);
            isDataLoad = true;
          });
        } else {
          setState(() {
            firestoreProduct = widget.clusterAndProduct.product;
            isDataLoad = true;
          });
        }
      } else {
        setState(() {
          firestoreProduct = widget.clusterAndProduct.product;
          isDataLoad = true;
        });
      }
    } else {
      setState(() {
        firestoreProduct = widget.clusterAndProduct.product;
        isDataLoad = true;
      });
    }
  }

  listSorting(List<FirestoreProduct> products) {
    FirestoreProduct? tempProduct;
    List<String> selectedProductNutriments = [];
    List<FirestoreProduct> equalNutriProducts = [];
    products.removeWhere((element) =>
        element.b7 == null ||
        element.activeEanNumber == false ||
        element.images == null);
    final distinctIds = Set();
    products.retainWhere((element) => distinctIds.add(element.code));

    if (widget.clusterAndProduct.cluster != null &&
        widget.clusterAndProduct.cluster!.productReference!.isNotEmpty) {
      setState(() {
        final tempIndex = products.indexWhere((element) =>
            element.code == widget.clusterAndProduct.product!.code);
        if (tempIndex >= 0) {
          tempProduct = products[tempIndex];
        }
      });
    }

    if (tempProduct?.nutriments != null) {
      print('nutriments ${tempProduct!.nutriments}');
      final Nutriments productNutriments = tempProduct!.nutriments!;
      productNutriments.toJson().entries.forEach((nutriments) {
        if (nutriments.value != null) {
          selectedProductNutriments.add(nutriments.key);
        }
      });
    }

    products.forEach((element) {
      List<String> productNutriments = [];
      if (element.nutriments != null) {
        element.nutriments!.toJson().forEach((key, value) {
          if (value != null) {
            productNutriments.add(key);
          }
        });
      }
      var condition1 = selectedProductNutriments
          .toSet()
          .difference(productNutriments.toSet())
          .isEmpty;
      var condition2 =
          selectedProductNutriments.length == productNutriments.length;
      var isEqual = condition1 && condition2;
      if (isEqual) {
        equalNutriProducts.add(element);
      }
    });

    products.clear();
    products.addAll(equalNutriProducts);
    products.sort((a, b) {
      if (a.b7 == null && b.b7 == null) {
        return 0;
      } else if (a.b7 == null) {
        return 1;
      } else if (b.b7 == null) {
        return -1;
      } else {
        return a.b7!.compareTo(b.b7!);
      }
    });

    if (tempProduct != null) {
      products.remove(tempProduct);
      products.insert(0, tempProduct!);
    }

    if (products.length > 20) {
      setState(() {
        products = products.sublist(0, 20);
      });
    }
    products.sort((a, b) {
      return a.nutriscoreScore!.compareTo(b.nutriscoreScore!);
    });
    alternatives.addAll(products);
    setState(() {
      isDataLoad = true;
      print('data 3333 $isDataLoad');
    });
  }

  Widget _bar(FirestoreProduct firestoreProduct) {
    String index =
        getOrdinalNumber((selectedIndex == -1) ? 1 : selectedIndex + 1);
    Color? nutriColor = firestoreProduct.nutriscoreGrade != null
        ? InvocAppTheme.nutriColor[firestoreProduct.nutriscoreGrade]
        : const Color(0xfff1583c);
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: nutriColor!, width: 2)),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: firestoreProduct.nutriscoreScore != null
                              // ? firestoreProduct.nutriscoreScore.toString()
                              ? '${(selectedIndex == -1) ? 1 : selectedIndex + 1}'
                              : "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            fontFamily: 'GilroyBold',
                            fontSize: 16,
                            height: 1,
                            color: nutriColor,
                          ),
                        ),
                        TextSpan(
                          text: firestoreProduct.nutriscoreScore != null
                              // ? firestoreProduct.nutriscoreScore.toString()
                              ? index
                              : "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            fontFamily: 'GilroyBold',
                            fontSize: 12,
                            height: 1,
                            color: nutriColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ])),
    );
  }

  String getOrdinalNumber(int index) {
    if (index % 10 == 1 && index % 100 != 11) {
      return firstKey.tr;
    } else if (index % 10 == 2 && index % 100 != 12) {
      return secondKey.tr;
    } else if (index % 10 == 3 && index % 100 != 13) {
      return thirdKey.tr;
    } else {
      return thKey.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('data load load ${isDataLoad}');
    return Container(
      decoration: BoxDecoration(color: HexColor('#F2F6FC')),
      child: (isDataLoad)
          ? Column(
              children: <Widget>[
                _bar(firestoreProduct!),
                if (alternatives != null &&
                    alternatives.isNotEmpty &&
                    alternatives.length > 1)
                  _alternativeWidget(alternatives),
                if (alternatives == null || alternatives.isEmpty)
                  _triangleClip(),
                buildExpand(firestoreProduct!),
                _nameBrand(firestoreProduct!),
                _productBeautify(firestoreProduct!),
              ],
            )
          : Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
    );
  }

  Widget _triangleClip() {
    return CustomPaint(
        painter: BoxShadowPainter(),
        child: ClipPath(
            clipper: ClippedView(),
            child: Container(
              height: 30,
              color: Colors.white,
            )));
  }

  Widget _alternativeWidget(
    List<FirestoreProduct> products,
  ) {
    PageController controller =
        PageController(initialPage: selectedIndex, viewportFraction: 0.25);

    return CustomPaint(
      painter: BoxShadowPainter(),
      child: ClipPath(
        clipper: ClippedView(),
        child: Container(
          height: 120,
          color: Colors.white,
          child: Center(
            child: SizedBox(
              height: 100, // card height
              child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: PageView.builder(
                    itemCount: products.length,
                    controller: controller,
                    onPageChanged: (int index) => setState(() {
                      selectedIndex = index;
                      firestoreProduct = products[index];
                      print(firestoreProduct!.code);
                    }),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = i;
                              firestoreProduct = products[i];
                            });
                            controller.animateToPage(i,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);
                          },
                          child: Center(
                            child: Container(
                              height: 80,
                              width: 67,
                              decoration: BoxDecoration(
                                  border: i == selectedIndex
                                      ? Border.all(
                                          color: Colors.indigo, width: 1)
                                      : Border.all(
                                          color: Colors.transparent,
                                        ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  image: DecorationImage(
                                    image: products[i].images == null
                                        ? Image.asset(
                                                'assets/images/bunny_small.png')
                                            .image
                                        : Image.network(
                                                products[i].images!.thumb!)
                                            .image,
                                    fit: BoxFit.contain,
                                  )),
                            ),
                          ));
                    },
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExpand(FirestoreProduct firestoreProduct) {
    return ExpandableNotifier(
        initialExpanded: false,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ScrollOnExpand(
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToExpand: false,
                      tapBodyToCollapse: false,
                      tapHeaderToExpand: false,
                      hasIcon: false,
                    ),
                    header: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            Container(
                              height: 30,
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Color(0x123C285C),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(nutrients100gKey.tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'GilroyBold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xff3C285C),
                                  )),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Builder(
                                  builder: (BuildContext context) {
                                    var controller =
                                        ExpandableController.of(context);
                                    return InkWell(
                                      onTap: () {
                                        controller!.toggle();
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 4,
                                          child: ExpandableIcon(
                                            theme: const ExpandableThemeData(
                                              expandIcon: Icons.expand_more,
                                              collapseIcon: Icons.expand_less,
                                              iconColor: Color(0XFF283FF0),
                                              iconSize: 22,
                                              iconPadding: EdgeInsets.only(
                                                right: 0,
                                              ),
                                              hasIcon: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        )),
                    expanded: IngredientChart(firestoreProduct),
                    collapsed: Container(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<Future> loader(BuildContext context) async {
    return Get.dialog(Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _productBeautify(FirestoreProduct firestoreProduct) {
    Size size = MediaQuery.of(Get.context!).size;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16, top: 4),
      child: SizedBox(
        height: size.height * 0.45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: size.height * 0.45,
              width: size.width * 0.60,
              margin: EdgeInsets.only(left: 8),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    image: firestoreProduct.images == null
                        ? Image.asset('assets/images/bunny_v3.png').image
                        : Image.network(firestoreProduct.images!.large!).image,
                  )),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: TagsData.getTagsList().length,
                    itemBuilder: (BuildContext context, int index) {
                      TagsData tag = TagsData.getTagsList()[index];
                      return InkWell(
                          onTap: () async {
                            loader(Get.context!);

                            var location = Geolocator.requestPermission()
                                .then((value) => null)
                                .onError((error, stackTrace) {
                              Navigator.pop(Get.context!);
                            });
                            if (index == 0) {
                              if (GlobalVariables.userRole == UserRole.user) {
                                setState(() {
                                  Geolocator.getCurrentPosition().then((value) {
                                    currentLatLng =
                                        LatLng(value.latitude, value.longitude);
                                    // reportProductProvider
                                    //     .fetchOSAProductForUser(
                                    //         productCode: firestoreProduct.code!,
                                    //         currentLng: value.longitude,
                                    //         currentLat: value.latitude);
                                  });
                                });
                              }
                            }
                            Navigator.pop(Get.context!);
                            var permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.whileInUse ||
                                permission == LocationPermission.always) {
                              Get.dialog(
                                barrierDismissible: true,
                                MapsDialog(
                                    firestoreProduct: firestoreProduct,
                                    buttonSelected: index,
                                    reportProductProvider:
                                        reportProductProvider,
                                    currentLatLng: currentLatLng),
                              );
                            }
                          },
                          child: IconCard(
                              icon: tag.imagePath, name: tag.titleTxt));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    print('string string alternative $input');
    if (input.isNotEmpty && input != null) {
      String data = input[0].toUpperCase() + input.substring(1);
      return data.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    } else {
      return input.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }
  }

  String replaceCommaWithDash(String input) {
    String data = input[0].toUpperCase() + input.substring(1);
    return data.replaceAll(',', ' - ');
  }

  Widget _nameBrand(FirestoreProduct product) {
    String name =
        '${product.calculatedName!.isNotEmpty ? product.calculatedName! + "," : ""}${product.productName!}';

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product.calculatedName!.capitalizeFirst!
                Text(
                  // '${product.calculatedName!.isNotEmpty ? capitalizeFirstLetter(product.calculatedName!) + "," : ""}${capitalizeFirstLetter(product.productName!)}\n',
                  '${capitalizeFirstLetter(name)}\n',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      color: const Color(0xff2e2e2e),
                      fontWeight: FontWeight.w500,
                      height: 1),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  product.calculatedBrand!.isNotEmpty
                      ? capitalizeFirstLetter(product.calculatedBrand!)
                      : capitalizeFirstLetter(product.brands!),
                  style: TextStyle(
                      fontFamily: 'GillroySemiBold',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1),
                ),
              ],
            )));
  }

  Widget timeChart() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Weekly amount chart',
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                color: const Color(0xff2e2e2e),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF2633C5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Report",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}