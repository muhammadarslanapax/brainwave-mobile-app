import 'package:aichat/View/Base_widgets/customsnackBar.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:aichat/View/Screens/Category/CategoryWidget.dart';
import 'package:aichat/model/BannersModel.dart';
import 'package:aichat/provider/CategoryController.dart';

class CategoriesScreen extends StatefulWidget {
  bool? isfromHome;
  bool? canPop;
  CategoriesScreen({
    super.key,
    this.isfromHome = false,
    this.canPop = false,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late CategoryController categoryController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadAdd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_nativeAd != null) {
      _nativeAd!.dispose();
    }
    super.dispose();
  }

  NativeAd? _nativeAd;
  loadAdd() {
    if (Provider.of<ProfileProvider>(context, listen: false).keysModel ==
        null) {
      snackBar(context, title: 'Check Add ids in admin!');
      return;
    }
    _nativeAd = NativeAd(
        adUnitId: Platform.isAndroid
            ? Provider.of<ProfileProvider>(context, listen: false)
                    .keysModel!
                    .nativeAddUnitId ??
                ''
            : Provider.of<ProfileProvider>(context, listen: false)
                    .keysModel!
                    .iosNativeAddUnitId ??
                '',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text(ad.adUnitId)));

            // print('$NativeAd loaded.');
            setState(() {
              // _nativeAd = ad as NativeAd;
              // _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            // print('$NativeAd failedToLoad: $error');
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.message)));
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load().then((value) => null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    categoryController =
        Provider.of<CategoryController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: widget.isfromHome!
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).cardColor,
                title: SizedBox(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      widget.canPop!
                          ? GestureDetector(
                              onTap: () {
                                // loadAdd();
                                Navigator.pop(context);
                              },
                              child: Image(
                                width: 18,
                                image: const AssetImage('images/back_icon.png'),
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(width: widget.canPop! ? 15 : 0),
                      Text(
                        "Categories",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // if (_nativeAd != null) ...{
              //   ConstrainedBox(
              //     constraints: const BoxConstraints(
              //       minWidth: 320,
              //       minHeight: 90,
              //       maxWidth: 400,
              //       maxHeight: 200,
              //     ),
              //     child: AdWidget(ad: _nativeAd!),
              //   )
              // },
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 1, crossAxisCount: 3),
                itemCount: widget.isfromHome!
                    ? 9
                    : categoryController.categories.length,
                itemBuilder: (context, index) {
                  if (index == 6) {}
                  return CategoryWidget(
                    categoryModel: categoryController.categories[index],
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
