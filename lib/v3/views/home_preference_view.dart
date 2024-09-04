import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:invoc/models/user_preferences.dart';
import 'package:invoc/providers/user_preference_notifier.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/InvocNavigator.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePreferenceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserPreferencesModel>(
        builder: (context, UserPreferencesModel userPreferenceProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(helloKey.tr,
                textAlign: TextAlign.left, style: InvocAppTheme.display1),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                addPreferenceKey.tr,
                textAlign: TextAlign.left,
                style: InvocAppTheme.title,
              )),
          SizedBox(
            height: 10,
          ),
          if (userPreferenceProvider == null) getEmptyPreferenceClick(context),
          if (userPreferenceProvider.dataLoaded)
            (userPreferenceProvider.userPreferences !=null)?
            userPreferenceProvider.userPreferences!
                    .getActiveVariables()
                    .isNotEmpty
                ? getListOfPreference(
                    userPreferenceProvider.userPreferences!, context)
                : getEmptyPreferenceClick(context):getEmptyPreferenceClick(context),
          getTitleForScanProduct(),
        ],
      );
    });
  }

  Widget getListOfPreference(
      UserPreferences userPreferences, BuildContext context) {
    List<UserPreferencesVariable> userActivePreferences =
        userPreferences.getActiveVariables();
    if (userActivePreferences.isNotEmpty) {
      return Container(
        height: 90,
        child: ListView.builder(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, right: 8, left: 8),
            itemCount: userActivePreferences.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Container(
                  height: 80,
                  width: 70,
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    color: InvocAppTheme.background,
                    border: Border.all(color: InvocAppTheme.background),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: InkWell(
                      highlightColor: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(48.0)),
                      onTap: () {
                        InvocNavigator.goToPreference(context);
                      },
                      child: Center(
                          child: SizedBox(
                              height: 48,
                              width: 48,
                              child: SvgPicture.asset(userActivePreferences
                                  .elementAt(index)
                                  .icon))),
                    ),
                  ),
                ),
                onTap: () {
                  InvocNavigator.goToPreference(context);
                },
              );
            }),
      );
    } else {
      return getEmptyPreferenceClick(context);
    }
  }

  Widget getEmptyPreferenceClick(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 80,
          width: 70,
          decoration: BoxDecoration(
            color: InvocAppTheme.background,
            border: Border.all(color: InvocAppTheme.background),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: SizedBox(
            height: 48,
            width: 48,
            child: InkWell(
              highlightColor: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(48.0)),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                // user login
                final isUserLogin = prefs.getBool('login') ?? false;
                final isUserAnonymous = prefs.getBool('isAnonymous') ?? false;
                if (isUserLogin && !isUserAnonymous) {
                  InvocNavigator.goToPreference(context);
                } else {
                  InvocNavigator.goToUserProfile(context);
                }
              },
              child: Center(
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: InvocAppTheme.nearlyBlack,
                ),
              ),
            ),
          ),
        ));
  }
}

Widget getTitleForScanProduct() {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
    child: Text(scanProductsKey.tr,
        textAlign: TextAlign.justify, style: InvocAppTheme.subHeadline),
  );
}

Widget getTextForTopNonLogin() {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16),
    child: Text(helloKey.tr,
        textAlign: TextAlign.left, style: InvocAppTheme.display1),
  );
}
