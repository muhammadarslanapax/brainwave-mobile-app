import 'dart:io';

import 'package:aichat/View/Screens/Category/CategoriesScreen.dart';
import 'package:aichat/View/Base_widgets/QuestionInput.dart';
import 'package:aichat/View/Screens/Chat/ChatPage.dart';
import 'package:aichat/View/Base_widgets/Txtfield_Round.dart';
import 'package:aichat/View/Screens/Chat/TextToSpeech.dart';
import 'package:aichat/provider/CategoryController.dart';
import 'package:aichat/provider/Chatgpt.dart';
import 'package:aichat/utils/Time.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aichat/View/Screens/stores/AIChatStore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../main.dart';
import '../../../model/BannersModel.dart';
import '../../../provider/ProfileProvider.dart';
import '../../Base_widgets/customsnackBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController questionController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _renderBottomInputWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        handleClickInput();
      },
      child: QuestionInput(
        chat: const {},
        autofocus: false,
        enabled: false,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // loadAd();
    // setBannerAdd();
  }

  // setBannerAdd() {
  //   bannerAd=BannerAd(size: , adUnitId: adUnitId, listener: listener, request: request)
  // }
  RewardedAd? _rewardedAd;
  loadAd() {
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

  @override
  void dispose() {
    super.dispose();
  }

  void _handleClickModel(Map chatModel) {
    final store = Provider.of<AIChatStore>(context, listen: false);
    store.fixChatList();
    Utils.jumpPage(
      context,
      ChatPage(
        tips: const [],
        chatId: const Uuid().v4(),
        autofocus: true,
        chatType: chatModel['type'],
      ),
    );
  }

  void handleClickInput() async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    store.fixChatList();
    Utils.jumpPage(
      context,
      ChatPage(
        tips: const [],
        chatType: 'chat',
        autofocus: true,
        chatId: const Uuid().v4(),
      ),
    );
  }

  TextEditingController searchcontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          //toolbarHeight: 60,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const SizedBox(width: 15),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.5,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField_Round(
                  controller: searchcontroler,
                  hintText: "Type your message...",
                  obscureText: false,
                  maxlines: 1,
                  sufixIcon: Icons.mic,
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Utils.jumpPage(
                            context,
                            TextToSpeechScreen(
                                chatId: const Uuid().v4(),
                                autofocus: false,
                                chatType: 'speechtotext',
                                tips: const []));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Start color
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2), // End color
                              // Add more colors for the gradient as needed.
                            ],
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              const Image(
                                width: 36,
                                height: 36,
                                image: AssetImage('images/speech-to-text.png'),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Speech to text",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Utils.jumpPage(
                            context,
                            TextToSpeechScreen(
                                chatId: const Uuid().v4(),
                                autofocus: false,
                                chatType: 'texttospeech',
                                tips: const []));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Start color
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              const Image(
                                width: 36,
                                height: 36,
                                image: AssetImage('images/text-to-speech.png'),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Text to speech",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // if (store.homeHistoryList.length > 0)
              //   _renderTitle(
              //     'History',
              //     rightContent: SizedBox(
              //       width: 45,
              //       child: GestureDetector(
              //         onTap: () {
              //           Utils.jumpPage(context, const ChatHistoryPage());
              //         },
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             const Text(
              //               'All',
              //               textAlign: TextAlign.start,
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 height: 18 / 16,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Container(
              //               padding:
              //                   const EdgeInsets.fromLTRB(0, 0, 8, 0),
              //               height: 16,
              //               child: const Image(
              //                 image: AssetImage('images/arrow_icon.png'),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),

              // if (store.homeHistoryList.length > 0)
              //   _renderChatListWidget(
              //     store.homeHistoryList,
              //   ),
              // _renderTitle('Your QuikAi Assistanct'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your QuikAi Assistanct',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesScreen(
                                canPop: true,
                              ),
                            ));
                        // CategoriesScreen(
                        //   canPop: true,
                        // ).launch(context);
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.56,
                child: CategoriesScreen(
                  isfromHome: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderTitle(
    String text, {
    Widget? rightContent,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color.fromRGBO(1, 2, 6, 1),
              fontSize: 22,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rightContent != null) rightContent,
        ],
      ),
    );
  }

  Widget _renderChatModelGridWidget() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1.2,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ChatGPT.chatModelList.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return _genChatModelItemWidget(ChatGPT.chatModelList[index]);
      },
    );
  }

  Widget _genChatModelItemWidget(Map chatModel) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _handleClickModel(chatModel);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,

        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        // clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 20, 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: const Image(
                  image: AssetImage('images/arrow_icon.png'),
                  width: 18,
                ),
              ),
            ),
            Text(
              chatModel['name'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderChatListWidget(List chatList) {
    List<Widget> list = [];
    for (var i = 0; i < chatList.length; i++) {
      list.add(
        _genChatItemWidget(chatList[i]),
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          ...list,
        ],
      ),
    );
  }

  Widget _genChatItemWidget(Map chat) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        final store = Provider.of<AIChatStore>(context, listen: false);
        store.fixChatList();
        Utils.jumpPage(
          context,
          ChatPage(
            tips: const [],
            chatId: chat['id'],
            autofocus: false,
            chatType: chat['ai']['type'],
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chat['updatedTime'] != null)
                      Text(
                        TimeUtils().formatTime(
                          chat['updatedTime'],
                          format: 'dd/MM/yyyy HH:mm',
                        ),
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      chat['messages'][0]['content'],
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 22,
                ),
                color: const Color.fromARGB(255, 145, 145, 145),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, chat['id']);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 2,
            color: Color.fromRGBO(166, 166, 166, 1.0),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String chatId,
  ) async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm deletion?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await store.deleteChatById(chatId);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
