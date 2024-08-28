import 'package:aichat/model/language_model.dart';
import 'package:aichat/provider/Chatgpt.dart';
import 'package:aichat/utils/images.dart';

class AppConstants {
  //
  static String appName = 'Brain Wave';
  static String contactEmail = 'brainwave@qmail.com';
  static int watchAdApiCount = 3;
  static int appUserAdCount =
      20; // Do not actively display advertisements if the number of times exceeds (redemption page)

//TO DO: add the Apple API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
  static String appleApiKey = 'appl_api_key';

//TO DO: add the Google API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
  static String googleApiKey = 'goog_RPvzCnRfoamxLmupUzzXOkyYrnw';

//TO DO: add the Amazon API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
  static String amazonApiKey = 'amazon_api_key';

  static String entitlementKey = 'pro';

  static bool isInfiniteNumberVersion =
      true; // Unlimited frequency. Development and use. Set to false for production
  static const int balanceInputLen = 10;
  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String languageCode = 'language_code';
  static const String guestId = 'guest_id';
  static const String walletToken = 'wallet_token';
  static AppConstants _instance = AppConstants._();
  factory AppConstants() => _getInstance();
  static AppConstants get instance => _getInstance();
  AppConstants._();

  static AppConstants _getInstance() {
    _instance ??= AppConstants._();
    return _instance;
  }

  static bool get isDebug => !const bool.fromEnvironment('dart.vm.product');
  // static bool get isDebug => true;

  /// TODO VIP
  static bool isAdShow() {
    if (isInfiniteNumberVersion) {
      return false;
    }
    // If a custom key is set, no ads are displayed
    if (ChatGPT.getCacheOpenAIKey() != '') {
      return false;
    }
    return true;
  }
}
