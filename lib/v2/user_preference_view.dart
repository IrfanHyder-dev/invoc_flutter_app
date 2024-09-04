import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:invoc/models/user_preferences.dart';
import 'package:invoc/providers/user_preference_notifier.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/widgets/smooth_toggle.dart';
import 'package:provider/provider.dart';

class UserPreferencesView extends StatefulWidget {
  @override
  _UserPreferencesPageState createState() => _UserPreferencesPageState();
}

class _UserPreferencesPageState extends State<UserPreferencesView>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (_scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (_scrollController.offset <= 24 &&
          _scrollController.offset >= 0) {
        if (topBarOpacity != _scrollController.offset / 24) {
          setState(() {
            topBarOpacity = _scrollController.offset / 24;
          });
        }
      } else if (_scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
    Future.delayed(Duration.zero, () {
      addAllData();
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void addAllData() {
    listViews.add(SizedBox(
      height: kToolbarHeight,
    ));
    listViews.add(buildPreferenceList(context));
  }

  Widget buildPreferenceList(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          mandatoryKey.tr,
                          style: InvocAppTheme.title,
                        ),
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(
                              UserPreferencesVariableExtension
                                      .getMandatoryVariables()
                                  .length,
                              (int index) => _generateMandatoryRow(
                                  UserPreferencesVariableExtension
                                          .getMandatoryVariables()
                                      .elementAt(index)))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          importantKey.tr,
                          style: InvocAppTheme.title,
                        ),
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(
                              UserPreferencesVariableExtension
                                      .getAccountableVariables()
                                  .length,
                              (int index) => _generateMandatoryRow(
                                  UserPreferencesVariableExtension
                                          .getAccountableVariables()
                                      .elementAt(index)))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _generateMandatoryRow(UserPreferencesVariable variable) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: InvocAppTheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 48,
                width: 48,
                child: SvgPicture.asset(variable.icon),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                variable.name,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Consumer<UserPreferencesModel>(
            builder: (BuildContext context,
                UserPreferencesModel userPreferencesModel, Widget? child) {
              return SmoothToggle(
                value: userPreferencesModel.dataLoaded
                    ? userPreferencesModel.getVariable(variable)
                    : userPreferencesModel.dataLoaded,
                onChanged: (bool newValue) {
                  userPreferencesModel.setVariable(variable, newValue);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getPageUI() {
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
                                    width: 32,
                                    child: Center(
                                        child: InkWell(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: InvocAppTheme.nearlyBlack,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          preferenceKey.tr,
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
      color: InvocAppTheme.lightWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getPageUI(),
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
