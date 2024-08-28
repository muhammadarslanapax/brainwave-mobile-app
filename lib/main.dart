import 'dart:async';
import 'package:aichat/View/Base_widgets/HideKeyboard.dart';
import 'package:aichat/View/Screens/Splash/Splash_Screen.dart';
import 'package:aichat/Theme/dark_theme.dart';
import 'package:aichat/Theme/light_theme.dart';
import 'package:aichat/provider/CategoryController.dart';
import 'package:aichat/provider/SubscriptionProvider.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/provider/theme_provider.dart';
import 'package:aichat/View/Screens/stores/AIChatStore.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aichat/provider/Chatgpt.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'di_container.dart' as di;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'provider/ChatProvider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

setStripe(BuildContext context) async {
  try {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getCredentials();
    if (profileProvider.keysModel != null) {
      Stripe.publishableKey =
          profileProvider.keysModel!.Stripe_Publishable_Key ?? '';
      Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
      Stripe.urlScheme = 'flutterstripe';
      ChatGPT.chatGptToken =
          profileProvider.keysModel!.OPENAI_CHATGPT_TOKEN ?? '';
      await ChatGPT.initChatGPT();
      await Stripe.instance.applySettings();
    }
  } catch (e) {
    print(e);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await dotenv.load(fileName: ".env");
  di.init();
  await MobileAds.instance.initialize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  await GetStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AIChatStore>()),
        ChangeNotifierProvider(create: (context) => AudioGeneratorController()),
        ChangeNotifierProvider(
            create: (context) => di.sl<CategoryController>()),
        ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
        ChangeNotifierProvider(
            create: (context) => di.sl<SubscriptionPlanProvider>()),
      ],
      child: const MyApp(),
    ),
  );

  configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStripe(context);
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).darkTheme ? light : dark,
        home: const SplashPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

Future<void> configLoading() async {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.none
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..displayDuration = const Duration(milliseconds: 1000)
    ..userInteractions = false;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
