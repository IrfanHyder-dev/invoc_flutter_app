import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/api/model/parameter/SearchEnum.dart';
import 'package:invoc/main.dart';
import 'package:invoc/my_diary/paggination_prodcut_list.dart';
import 'package:invoc/providers/product_provider.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/ui_view/InvocSearchPageRoute.dart';
import 'package:invoc/utils/InvocNavigator.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v3/auth/constants/enums.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:invoc/v3/views/home_preference_view.dart';
import 'package:invoc/v3/views/home_product_scan.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SinglePage extends StatefulWidget {
  @override
  _SinglePageState createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> with TickerProviderStateMixin {
  AnimationController?_animationController;
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  int selectedTab = 0;
  bool isUserLogin = false;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          if (mounted)
            setState(() {
              topBarOpacity = 1.0;
            });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          if (mounted)
            setState(() {
              topBarOpacity = scrollController.offset / 24;
            });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          if (mounted)
            setState(() {
              topBarOpacity = 0.0;
            });
        }
      }
    });
    super.initState();
  }

  void changeBody(int selection) {
    print(selection);
    if (selection == 0) {
      listViews.clear();
      addAllListData();
    } else {
//      listViews.clear();
//      addAllListDataForScan();
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!);
    return Container(
      color: InvocAppTheme.white,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              getMainUI(productProvider: productProvider, context: Get.context!),
              getAppBarUI(),
            ],
          ),
          floatingActionButton: Transform.scale(
            scale: 1.1,
            child: FloatingActionButton(
              child: SvgPicture.asset('assets/icons/scan_icon.svg',
                  allowDrawingOutsideViewBox: true, fit: BoxFit.fill),
              backgroundColor: InvocAppTheme.nearlyDarkBlue,
              onPressed: () {
                _presentScannerPage();
              },
            ),
          )),
    );
  }

  void addAllListData() async {
    listViews.add(emptyScanPage());
    SharedPreferences.getInstance().then((value) async {
      bool? login = value.getBool('login');
      if (login == null || !login) {
        final AuthService auth =
            Provider.of<AuthService>(Get.context!, listen: false);
        UserFromFirebase user = await auth.signInAnonymously();
        print(user.toString());
      }
    });
  }

  void _presentScannerPage() {
    InvocNavigator.goToScanner(Get.context!);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget getMainUI({required ProductProvider productProvider, required BuildContext context}) {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                // disallowGlow();
                return false;
              },
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(Get.context!).padding.top +
                        24,
                    bottom: 62 + MediaQuery.of(Get.context!).padding.bottom,
                  ),
                  itemCount: listViews.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    print("List View Length " + listViews.length.toString());
                    _animationController!.forward();
                    return listViews[index];
                  },
                ),
              ));
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
                        height: MediaQuery.of(Get.context!).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
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
                                    width: 32 + 6 - 6 * topBarOpacity,
                                    height: 32 + 6 - 6 * topBarOpacity,
                                    child: (GlobalVariables.userRole == UserRole.admin)
                                        ? Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image.asset(
                                              'assets/images/admin_launcer_icon.jpg',
                                              height: 10,
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/images/apple_smile_small_appbar.png"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 0.0,
                                        bottom: 0,
                                        right: 8.0),
                                    child: Text(
                                      appNameKey.tr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: InvocAppTheme.fontName,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18 + 6 - 6 * topBarOpacity,
                                        letterSpacing: 1.2,
                                        color: InvocAppTheme.darkerText,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: InkWell(
                                highlightColor: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(48.0)),
                                onTap: () {
                                  showInvocSearch(
                                      context: Get.context!,
                                      delegate: ProductSearchDelegate(
                                          _animationController!));
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.search,
                                    color: InvocAppTheme.nearlyBlack,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: InkWell(
                                highlightColor: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(48.0)),
                                onTap: () {
                                  InvocNavigator.goToUserProfile(Get.context!);
                                },
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.solidUserCircle,
                                    color: InvocAppTheme.nearlyBlack,
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
              ),
            );
          },
        )
      ],
    );
  }

  Widget appBarNew() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(Get.context!).padding.top,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 16,
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
                      width: 32 + 6 - 6 * topBarOpacity,
                      height: 32 + 6 - 6 * topBarOpacity,
                      child: (GlobalVariables.userRole == UserRole.admin)
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/images/admin_launcer_icon.jpg',
                                height: 10,
                              ),
                            )
                          : Image.asset(
                              "assets/images/apple_smile_small_appbar.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, top: 8.0, bottom: 0, right: 8.0),
                      child: Text(
                        appNameKey.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: InvocAppTheme.fontName,
                          fontWeight: FontWeight.w300,
                          fontSize: 18 + 6 - 6 * topBarOpacity,
                          letterSpacing: 1.2,
                          color: InvocAppTheme.darkerText,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 32,
                width: 32,
                child: InkWell(
                  highlightColor: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(48.0)),
                  onTap: () {
                    showInvocSearch(
                        context: Get.context!,
                        delegate: ProductSearchDelegate(_animationController!));
                  },
                  child: Center(
                    child: Icon(
                      Icons.search,
                      color: InvocAppTheme.nearlyBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
                width: 32,
                child: InkWell(
                  highlightColor: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(48.0)),
                  onTap: () {
                    InvocNavigator.goToUserProfile(Get.context!);
                  },
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.solidUserCircle,
                      color: InvocAppTheme.nearlyBlack,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getTextForTopNonLogin() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Text(helloKey.tr,
          textAlign: TextAlign.left, style: InvocAppTheme.display1),
    );
  }

  Widget getTextForScan() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
      child: Center(
        child: Text(clickToScanKey.tr,
            textAlign: TextAlign.center, style: InvocAppTheme.textCaption),
      ),
    );
  }
  Widget emptyScanPage() {
    return Stack(
      children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          SizedBox(
            height: 20,
          ),
          HomePreferenceView(),
          HomeProducts(),
        ]),
      ],
    );
  }
}

class ProductSearchDelegate
    extends InvocSearchDelegate<List<FirestoreProduct>> {
  AnimationController? animationController;

  ProductSearchDelegate(AnimationController animationController) {
    this.animationController = animationController;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: InvocAppTheme.nearlyBlack),
        onPressed: () {
          close(Get.context!, null);
          //query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: InvocAppTheme.nearlyBlack),
      onPressed: () {
        // close(Get.context!, null);
        Navigator.of(Get.context!).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return PaginationProductList(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController!,
                curve:
                    Interval((1 / 5) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        productCode: query,
        searchType: PaginationListingType.NAME);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return PaginationProductList(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController!,
                curve:
                    Interval((1 / 5) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        productCode: query,
        searchType: PaginationListingType.NAME);
  }
}
