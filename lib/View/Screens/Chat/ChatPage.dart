import 'dart:io';

import 'package:aichat/View/Base_widgets/QuestionInput.dart';
import 'package:aichat/provider/Chatgpt.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aichat/View/Screens/stores/AIChatStore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../main.dart';
import '../../../model/BannersModel.dart';
import '../../../provider/ProfileProvider.dart';
import '../../Base_widgets/AppBarCustom.dart';
import '../../Base_widgets/customsnackBar.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final bool autofocus;
  final String chatType;
  List<String> tips;

  ChatPage({
    super.key,
    required this.chatId,
    required this.autofocus,
    required this.chatType,
    required this.tips,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

enum TtsState { playing, stopped, paused, continued }

loadInterstitialAd() async {
  if (Provider.of<ProfileProvider>(Get.context!, listen: false).keysModel ==
      null) {
    snackBar(Get.context!, title: 'Check Add ids in admin!');
    return;
  }
  await InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? Provider.of<ProfileProvider>(Get.context!, listen: false)
                  .keysModel!
                  .adIntersialUnitId ??
              ''
          : Provider.of<ProfileProvider>(Get.context!, listen: false)
                  .keysModel!
                  .iosAdIntersialUnitId ??
              '',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
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
          // _interstitialAd = ad;
          // ad.show();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ));
}

showAdd(InterstitialAd add) async {
  await add.show();
}

class _ChatPageState extends State<ChatPage> {
  static final LottieBuilder _generatingLottie =
      Lottie.asset("images/loading2.json");

  final ScrollController _listController = ScrollController();

  late FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;
  String _speakText = '';

  bool _isCopying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> initTts() async {
    _flutterTts = FlutterTts();

    _setAwaitOptions();

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        _ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        _ttsState = TtsState.paused;
      });
    });

    _flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        _ttsState = TtsState.continued;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        _ttsState = TtsState.stopped;
      });
    });
  }

  Future _setAwaitOptions() async {
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text) async {
    // 如果正在播放，则先停止
    if (_ttsState == TtsState.playing) {
      await _flutterTts.stop();
    }
    if (_speakText == text) {
      _speakText = '';
      return;
    }
    _speakText = text;
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();

    initTts();

    // WidgetsBinding.instance.addPostFrameCallback((mag) {
    // print("页面渲染完毕");
    // scrollToBottom();
    // });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void scrollToBottom() {
    // _listController.animateTo(
    //   _listController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
    if (_listController.hasClients) {
      _listController.jumpTo(_listController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);
    final chat = store.getChatById(widget.chatType, widget.chatId);

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: AppBarCustom(
            title: AppConstants.appName,
          ),
          elevation: 0.5,
          actions: const [
            SizedBox(width: 20),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _renderMessageListWidget(
                  chat['messages'],
                ),
              ),
              widget.chatType == "texttospeech"
                  ? QuestionInput(
                      key: globalQuestionInputKey,
                      chat: chat,
                      loadAdd: loadInterstitialAd,
                      autofocus: widget.autofocus,
                      enabled: true,
                      scrollToBottom: () {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          scrollToBottom();
                        });
                      },
                    )
                  : QuestionInput(
                      key: globalQuestionInputKey,
                      chat: chat,
                      loadAdd: loadInterstitialAd,
                      autofocus: widget.autofocus,
                      icon: widget.chatType == "speechtotext"
                          ? "images/mic.png"
                          : widget.chatType == "texttospeech"
                              ? "images/speaker.png"
                              : 'images/submit_icon.png',
                      enabled: true,
                      scrollToBottom: () {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          scrollToBottom();
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderMessageListWidget(List messages) {
    if (messages.isEmpty) {
      // Map? aiData = ChatGPT.getAiInfoByType(widget.chatType);

      // if (widget.tips == null) {
      //   return const SizedBox.shrink();
      // }
      List<Widget> tipsWidget = [];
      for (int i = 0; i < widget.tips.length; i++) {
        String tip = widget.tips[i];
        tipsWidget.add(
          Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: const Color.fromRGBO(192, 238, 221, 1.0),
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                if (globalQuestionInputKey.currentState != null) {
                  final currentState = globalQuestionInputKey.currentState;
                  if (currentState != null) {
                    currentState.myQuestion = tip;
                    currentState.questionController.clear();
                    currentState.questionController.text = tip;
                    currentState.focusNode.requestFocus();
                    currentState.questionController.selection =
                        TextSelection.fromPosition(
                            TextPosition(offset: tip.length));
                    setState(() {});
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tip,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        );
        tipsWidget.add(
          const SizedBox(height: 10),
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Image(
              width: 18,
              height: 18,
              image: const AssetImage('images/tip_icon.png'),
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Tip',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Column(
              children: tipsWidget,
            ),
            const SizedBox(height: 60),
          ],
        ),
      );
    }

    return _genMessageListWidget(messages);
  }

  /// TODO Performance optimization?
  Widget _genMessageListWidget(List messages) {
    // List<Widget> list = [];
    // for (var i = 0; i < messages.length; i++) {
    //   list.add(
    //     _genMessageItemWidget(messages[i], i),
    //   );
    // }
    // list.add(
    //   const SizedBox(height: 10),
    // );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: list,
    //   ),
    // );

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      controller: _listController,
      reverse: false,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return _genMessageItemWidget(messages[index], index);
      },
    );
  }

  Widget _genMessageItemWidget(Map message, int index) {
    // String role = message['role'];
    // if (role == 'generating') {
    //   return SizedBox(
    //     height: 160,
    //     child: _generatingLottie,
    //   );
    // }

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: _renderMessageItem(message, index),
    );
  }

  Widget _renderMessageItem(Map message, int index) {
    String role = message['role'];
    String defaultAvatar = 'images/logo.png';
    String defaultRoleName = AppConstants.appName;
    Color defaultColor = Theme.of(context).colorScheme.primary.withOpacity(0.8);
    Color defaultTextColor = Colors.black;
    String defaultTextPrefix = '';
    List<Widget> defaultIcons = [
      _renderVoiceWidget(message),
      const SizedBox(width: 6),
      _renderShareWidget(message),
      const SizedBox(width: 8),
      _renderCopyWidget(message),
    ];
    Widget? customContent;

    if (role == 'user') {
      defaultAvatar = 'images/user_icon.png';
      defaultRoleName = 'You';
      defaultColor = Theme.of(context).colorScheme.primary.withOpacity(0.8);
      defaultIcons = [];
    } else if (role == 'error') {
      defaultTextColor = const Color.fromRGBO(238, 56, 56, 1.0);
      defaultTextPrefix = 'Error:  ';
      defaultIcons = [
        _renderRegenerateWidget(index),
      ];
    } else if (role == 'generating') {
      defaultIcons = [];
      customContent = Row(
        children: [
          SizedBox(
            height: 60,
            child: _generatingLottie,
          )
        ],
      );
    }
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      decoration: BoxDecoration(
        color: defaultColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        width: 36,
                        height: 36,
                        image: AssetImage(defaultAvatar),
                        // color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      defaultRoleName,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Row(
                children: defaultIcons,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            height: 2,
            color: Color.fromRGBO(124, 119, 119, 1.0),
          ),
          const SizedBox(height: 10),
          customContent ??
              MarkdownBody(
                data: '$defaultTextPrefix${message['content']}',
                // data: 'This is a line\nThis is another line'.replaceAll('\n', '<br>'),
                shrinkWrap: true,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  textScaler: const TextScaler.linear(1.1),
                  textAlign: WrapAlignment.start,
                  p: Theme.of(context).textTheme.bodySmall,
                ),
              ),
        ],
      ),
    );
  }

  Widget _renderShareWidget(Map message) {
    return GestureDetector(
      onTap: () async {
        Share.share(message['content']);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: const Image(
          image: AssetImage('images/share_message_icon.png'),
          width: 22,
        ),
      ),
    );
  }

  Widget _renderVoiceWidget(Map message) {
    return GestureDetector(
      onTap: () async {
        _speak(message['content']);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: const Image(
          image: AssetImage('images/voice_icon.png'),
          width: 26,
        ),
      ),
    );
  }

  Widget _renderCopyWidget(Map message) {
    return GestureDetector(
      onTap: () async {
        if (_isCopying) {
          return;
        }
        _isCopying = true;
        await Clipboard.setData(
          ClipboardData(
            text: message['content'],
          ),
        );
        EasyLoading.showToast(
          'Copy successfully!',
          dismissOnTap: true,
        );
        _isCopying = false;
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: const Image(
          image: AssetImage('images/chat_copy_icon.png'),
          width: 26,
        ),
      ),
    );
  }

  Widget _renderRegenerateWidget(int index) {
    return GestureDetector(
      onTap: () {
        globalQuestionInputKey.currentState?.reGenerate(index);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: const Image(
          image: AssetImage('images/refresh_icon.png'),
          width: 26,
        ),
      ),
    );
  }
}
