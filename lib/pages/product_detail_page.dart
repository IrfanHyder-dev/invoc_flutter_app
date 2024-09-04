import 'package:invoc/api/model/parameter/SearchEnum.dart';
import 'package:invoc/my_diary/product_list.dart';
import 'package:invoc/ui_view/product_normal_header.dart';
import 'package:invoc/ui_view/title_view.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:flutter/material.dart';
import '../api/model/Product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final VoidCallback? slideDown;

  ProductDetailPage({ this.product, this.slideDown});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;

  void _backOrClose(BuildContext context) {
    if (widget.slideDown != null) {
      print("i am here");
      widget.slideDown!();
    } else {
      Navigator.of(context).pop();
      print("i am there");
    }
  }

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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(TitleView(
      titleTxt: '',
      subTxt: '',
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController!,
          curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: _animationController!,
    ));

    listViews.add(ProductNormalHeader(
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController!,
          curve: Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: _animationController!,
      product: widget.product!,
    ));

    if (widget.product!.categoryNutriScore != null) {
      if (widget.product!.categoryNutriScore!.scores.elementAt(0).entries.length >
          1) {
        listViews.add(TitleView(
          titleTxt: 'Benchmark',
          subTxt: '',
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: _animationController!,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: _animationController!,
        ));
      }
    }
    listViews.add(TitleView(
      titleTxt: 'Alternatives',
      subTxt: '',
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController!,
          curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: _animationController!,
    ));
    listViews.add(ProductList(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: _animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        productCode: widget.product!.barcode,
        searchType: SearchType.ALTERNATIVE));
  }

  Widget getProductUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              _animationController!.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: InvocAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 32 + 6 - 6 * topBarOpacity,
                                    height: 32 + 6 - 6 * topBarOpacity,
                                    child: InkWell(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: InvocAppTheme.nearlyBlack,
                                        ),
                                        onPressed: () {
                                          _backOrClose(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.product!.productName!,
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
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getProductUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}
