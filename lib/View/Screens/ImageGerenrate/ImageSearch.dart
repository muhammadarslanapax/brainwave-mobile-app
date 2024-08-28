import 'dart:io';

import 'package:aichat/View/Base_widgets/customsnackBar.dart';
import 'package:aichat/View/Screens/Chat/ChatPage.dart';
import 'package:aichat/View/Screens/subscription/Premium_plans_screen.dart';
import 'package:aichat/main.dart';
import 'package:aichat/model/BannersModel.dart';
import 'package:aichat/provider/CategoryController.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../Base_widgets/Txtfield_Round.dart';

class ImageSearch extends StatefulWidget {
  const ImageSearch({super.key});

  @override
  State<ImageSearch> createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  TextEditingController messageController = TextEditingController();
  void downloadFile(String url) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String? path = await FlutterDownloader.enqueue(
      fileName: '${DateTime.now()}.jpg',
      url: url,
      savedDir: directory.path,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
    snackBar(Get.context!, title: 'Image downloaded successfully!');
  }

  int selected = 0;
  List<OpenAIImageModel> images = [];
  getImage() async {
    if (messageController.text.isEmpty) {
      EasyLoading.showToast('Please enter something...');
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt: messageController.text.trim(),
        n: 4,
        size: selected == 0
            ? OpenAIImageSize.size256
            : selected == 1
                ? OpenAIImageSize.size512
                : OpenAIImageSize.size1024,
        responseFormat: OpenAIImageResponseFormat.url,
      );
      images.clear();
      images.add(image);
      Provider.of<CategoryController>(Get.context!, listen: false)
          .updateFreeImagesCount(update: false);

      _scrollToEnd();
    } catch (e) {
      snackBar(Get.context!, title: e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void _scrollToEnd() {
    scrollController!.animateTo(
      scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  RewardedAd? _rewardedAd;

  loadAd() async {
    if (Provider.of<ProfileProvider>(Get.context!, listen: false).keysModel ==
        null) {
      snackBar(Get.context!, title: 'Check Add ids in admin!');
      return;
    }
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? Provider.of<ProfileProvider>(Get.context!, listen: false)
                    .keysModel!
                    .adRewardedUnitId ??
                ''
            : Provider.of<ProfileProvider>(Get.context!, listen: false)
                    .keysModel!
                    .iosAdRewardedUnitId ??
                '',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            showAdd(ad);
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
    setState(() {});
  }

  showAdd(RewardedAd ad) {
    try {
      ad.show(
        onUserEarnedReward: (ad, reward) {
          context
              .read<CategoryController>()
              .updateFreeImagesCount(update: true);
        },
      );
    } catch (e) {}
  }

  bool isLoading = false;
  ScrollController? scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    Future.microtask(() =>
        Provider.of<CategoryController>(context, listen: false)
            .getFreeCounts());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            AppConstants.appName,
          ),
          actions: [
            Consumer<ProfileProvider>(
              builder: (context, profileprovider, child) {
                if (profileprovider.checkIfPlannotExists()) {
                  return GestureDetector(
                    onTap: () async {
                      loadAd();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/tip_icon.png",
                          height: 25,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        Text(
                          "Reward ads",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(width: 15),
          ],
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, bottom: 10, right: 3),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField_Round(
                        controller: messageController,
                        hintText: "Type your message...",
                        obscureText: false,
                        maxlines: 1,

                        // sufixIcon: Icons.send,
                        prefixIcon: const Icon(Icons.title),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!Provider.of<ProfileProvider>(context, listen: false)
                              .checkIfPlannotExists() ||
                          (!isLoading &&
                              Provider.of<CategoryController>(context,
                                          listen: false)
                                      .freeImagesCount >
                                  0)) {
                        getImage();
                        // loadInterstitialAd();
                      } else if (Provider.of<CategoryController>(context,
                                  listen: false)
                              .freeImagesCount <=
                          0) {
                        snackBar(context,
                            title: 'View add for free images or buy a plan.');
                      }
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            )
                          : Icon(
                              Icons.send,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getChip('256x256', 0),
                  getChip('512x512', 1),
                  getChip('1024x1024', 2)
                ],
              ),
              Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                if (profileProvider.checkIfPlannotExists()) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 10),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'You have remaining free images: ${context.watch<CategoryController>().freeImagesCount}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Utils.jumpPage(
                                context,
                                const PurchasePremiumPlanScreen(
                                    isCameBack: true),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_border_rounded,
                                  color: Colors.yellow,
                                ),
                                Text(
                                  'Subscribe now',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.61,
                child: images.isEmpty
                    ? const Center(
                        child: Text('Generated images will be shown here.'))
                    : ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: images.length,
                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: images[index].data.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder: (context, index2) {
                                      int count = index2 + 1;
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageUrl: images[index]
                                                        .data[index2]
                                                        .url ??
                                                    ''),
                                            Positioned(
                                              right: 3,
                                              top: 3,
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  radius: 15,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        downloadFile(images[
                                                                    index]
                                                                .data[index2]
                                                                .url ??
                                                            '');
                                                      },
                                                      icon: const Icon(
                                                          Icons.download))),
                                            ),
                                            Positioned(
                                              left: 3,
                                              top: 3,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                radius: 15,
                                                child: Text(
                                                  (count).toString(),
                                                  // style: Theme.of(context)
                                                  //     .textTheme
                                                  //     .bodySmall,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getChip(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = index;
        });
      },
      child: Chip(
          shape: const StadiumBorder(),
          backgroundColor: selected == index
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(.3),
          label: Text(
            title,
            style: TextStyle(
              color: selected == index ? Colors.white : null,
            ),
          )),
    );
  }
}
