import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invoc/pages/products_list_page.dart';
import 'package:invoc/pages/splash_screen.dart';
import 'package:invoc/providers/product_provider.dart';
import 'package:invoc/providers/products_provider.dart';
import 'package:invoc/providers/report_product_provider.dart';
import 'package:invoc/providers/splash_screen_provider.dart';
import 'package:invoc/providers/user_preference_notifier.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/src/language/languages.dart';
import 'package:invoc/src/language/locales.dart';
import 'package:invoc/v2/single_page.dart';
import 'package:invoc/v2/user_preference_view.dart';
import 'package:invoc/v3/auth/app/auth_widget.dart';
import 'package:invoc/v3/auth/constants/enums.dart';
import 'package:invoc/v3/auth/services/apple_sign_in_available.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:invoc/v3/auth/services/auth_service_adapter.dart';
import 'package:invoc/v3/auth/services/email_secure_store.dart';
import 'package:invoc/v3/auth/services/firebase_email_link_handler.dart';
import 'package:invoc/v3/notifier/filter_notifier.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class GlobalVariables {
  static final UserRole userRole = UserRole.user;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  final firebaseServiceForLogin = AuthServiceType.firebase;

  if (kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  /// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp(
      initialAuthServiceType: firebaseServiceForLogin,
      appleSignInAvailable: appleSignInAvailable)));
}

class MyApp extends StatelessWidget {
  final AuthServiceType? initialAuthServiceType;
  final AppleSignInAvailable? appleSignInAvailable;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({this.initialAuthServiceType, this.appleSignInAvailable});

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
    ));

    final deviceLocale = window.locale.languageCode;
    final supportedLocales = ['en', 'fr'];
    final appLocale =
        supportedLocales.contains(deviceLocale) ? deviceLocale : 'en'; //
    final appLocaleObj = Locale(appLocale);
    Get.updateLocale(appLocaleObj); // Update locale using Get

    var routes = <String, WidgetBuilder>{
      "/home": (BuildContext context) => SinglePage(),
      // "/intro": (BuildContext context) => OnBoard(),
      "/scanner": (BuildContext context) => ProductsListPage(),
      "/preference": (BuildContext context) => UserPreferencesView(),
      "/user": (BuildContext context) => AuthWidget()

    };

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider(),
            child: ProductsListPage(),
          ),
          ChangeNotifierProvider<ProductsProvider>(
              create: (_) => ProductsProvider()),
          ChangeNotifierProvider<SplashScreenProvider>(
              create: (_) => SplashScreenProvider()),
          ChangeNotifierProvider<FilterNotifier>(
              create: (_) => FilterNotifier()),
          ChangeNotifierProvider<UserPreferencesModel>(
            create: (_) => UserPreferencesModel(),
            child: SinglePage(),
          ),
          Provider<AppleSignInAvailable>.value(value: appleSignInAvailable!),
          Provider<AuthService>(
            create: (_) => AuthServiceAdapter(
              initialAuthServiceType: initialAuthServiceType!,
            ),
            dispose: (_, AuthService authService) => authService.dispose(),
          ),
          Provider<EmailSecureStore>(
            create: (_) => EmailSecureStore(
              flutterSecureStorage: FlutterSecureStorage(),
            ),
          ),
          ProxyProvider2<AuthService, EmailSecureStore,
              FirebaseEmailLinkHandler>(
            update:
                (_, AuthService authService, EmailSecureStore storage, __) =>
                    FirebaseEmailLinkHandler(
              auth: authService,
              emailStore: storage,
              firebaseDynamicLinks: FirebaseDynamicLinks.instance,
            )..init(),
            dispose: (_, linkHandler) => linkHandler.dispose(),
          ),
          ChangeNotifierProvider<ReportProductProvider>(
              create: (_) => ReportProductProvider())
        ],
        child: GetMaterialApp(
          title: appNameKey.tr,
          debugShowCheckedModeBanner: false,
          navigatorObservers: <NavigatorObserver>[observer],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Gilroy',
          ),
          translations: Languages(),
          //locale: engLocale,
          supportedLocales: const [engLocale, frLocale],
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: SplashScreen(),
          // home: SinglePage(),
          routes: routes,
        ));
  }
}
//splash.png

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
