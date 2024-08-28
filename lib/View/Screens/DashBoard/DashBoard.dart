import 'dart:io';

import 'package:aichat/View/Screens/Category/CategoriesScreen.dart';
import 'package:aichat/View/Screens/ImageGerenrate/ImageSearch.dart';
import 'package:aichat/View/Screens/HomePage/HomePage.dart';
import 'package:aichat/View/Screens/Setting/SettingPage.dart';
import 'package:aichat/model/BannersModel.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../provider/ProfileProvider.dart';
import '../../Base_widgets/customsnackBar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Widget> screens = [
    const HomePage(),
    CategoriesScreen(),
    const ImageSearch(),
    // const SettingPage(),
    const Profile_Screen(),
  ];
  loadAd() {
    if (Provider.of<ProfileProvider>(Get.context!, listen: false).keysModel ==
        null) {
      snackBar(Get.context!, title: 'Check Add ids in admin!');
      return;
    }
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? Provider.of<ProfileProvider>(Get.context!, listen: false)
                  .keysModel!
                  .bannerAddID_android ??
              ''
          : Provider.of<ProfileProvider>(Get.context!, listen: false)
                  .keysModel!
                  .iosBannerAddId ??
              '',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {});
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          print('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load().then((value) {});
    setState(() {});
  }

  BannerAd? bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).colorScheme.outline,
        unselectedItemColor: Theme.of(context).hintColor,
        // selectedItemColor: Theme.of(context).colorScheme.outline,
        // unselectedLabelStyle: const TextStyle(color: Colors.black),
        currentIndex: _selectedIndex,
        onTap: (v) {
          setState(() {
            _selectedIndex = v;
          });
          loadAd();
        },
        backgroundColor: Theme.of(context).cardColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
            backgroundColor: Theme.of(context).canvasColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.category,
              size: 30,
            ),
            label: 'Categories',
            backgroundColor: Theme.of(context).canvasColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.image_search,
              size: 30,
            ),
            label: 'Image',
            backgroundColor: Theme.of(context).canvasColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
            label: 'Setting',
            backgroundColor: Theme.of(context).canvasColor,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: bannerAd != null
                  ? MediaQuery.of(context).size.height * 0.86
                  : null,
              child: screens[_selectedIndex],
            ),
            if (bannerAd != null) ...{
              SizedBox(
                height: bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: bannerAd!),
              )
            },
          ],
        ),
      ),
    );
  }
}
