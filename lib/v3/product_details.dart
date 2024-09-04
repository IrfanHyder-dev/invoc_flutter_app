import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_cluster_product.dart';
import 'package:invoc/v3/alternative_listing.dart';
import 'package:invoc/v3/product_header_v3.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:invoc/v3/product_tags.dart';

class ProductDetailPageV3 extends StatefulWidget {
  final FirestoreClusterAndProduct? product;

  ProductDetailPageV3({ this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPageV3>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  String? dooo;
  String name = 'mounim Naeem iqbal';
  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  String capitalizeFirstLetter(String input) {
    // input = "mounim , naeem , iqbal";
    print('string string product detail $input');
    if(input.isNotEmpty && input != null){
      String data = input[0].toUpperCase() + input.substring(1);
      return data.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }else{
      return input.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void addAllListData() {
    listViews.add(SizedBox(
      height: kToolbarHeight / 2,
    ));
    listViews.add(ProductNormalHeader(
      product: widget.product!.product,
      hideName: true,
    ));
    listViews.add(ProductTags(widget.product!.product!));
    if (widget.product!.cluster != null &&
        widget.product!.cluster!.productReference!.isNotEmpty) {}
    listViews.add(AlternativeListing(widget.product!));
  }

  Widget getProductUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: listViews.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  _animationController!.forward();
                  return listViews[index];
                },
              ));
        }
      },
    );
  }

  Widget getAppBarUI(BuildContext cntx) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: InvocAppTheme.white.withOpacity(topBarOpacity),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0,
                            right: 16,
                            top: 8.0 * topBarOpacity,
                            bottom: 6 - 4.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 32,
                                    child: Center(
                                        child: InkWell(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: InvocAppTheme.nearlyBlack,
                                        ),
                                        onPressed: () {
                                          Navigator.of(cntx).pop();
                                        },
                                      ),
                                    )),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          (widget.product?.product
                                                          ?.calculatedName !=
                                                      null &&
                                                  widget
                                                      .product!
                                                      .product!
                                                      .calculatedName!
                                                      .isNotEmpty)
                                              ? '${capitalizeFirstLetter(widget.product!.product!.calculatedName!+","+widget.product!.product!.productName!)}'
                                          : capitalizeFirstLetter(widget
                                              .product!.product!.productName!),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: InvocAppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                16 + 6 - 6 * topBarOpacity,
                                            letterSpacing: 1.2,
                                            color: InvocAppTheme.darkerText,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          getProductUI(),
          getAppBarUI(context),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}
