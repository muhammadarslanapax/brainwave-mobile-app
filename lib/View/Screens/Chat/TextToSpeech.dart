import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:aichat/View/Base_widgets/customsnackBar.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/widgets.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import '../../../model/AudioModel.dart';
import '../../../provider/ChatProvider.dart';
import '../../Base_widgets/AppBarCustom.dart';
import '../../Base_widgets/QuestionInput.dart';
import '../stores/AIChatStore.dart';

class TextToSpeechScreen extends StatefulWidget {
  final String chatId;
  final bool autofocus;
  final String chatType;
  List<String> tips;
  TextToSpeechScreen({
    super.key,
    required this.chatId,
    required this.autofocus,
    required this.chatType,
    required this.tips,
  });

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final record = AudioRecorder();
  final player = AudioPlayer();
  playAudio(Source source) async {
    await player.play(source).then((value) => setState(() {
          playingIndex = -1;
        }));
  }

  recordAudio() async {
    if (await record.hasPermission()) {
      // Start recording to file
      await record.start(const RecordConfig(),
          path:
              '${(await getApplicationDocumentsDirectory()).path}/myFile.m4a');
    }
  }

  pausePlayer() async {
    await player.pause();
  }

  GlobalKey selectVoice = GlobalKey();
  GlobalKey textinput = GlobalKey();
  List<TargetFocus> targets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AudioGeneratorController>(context, listen: false).clearFiles();
    checkTutorialIf();
  }

  checkTutorialIf() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if ((sharedPreferences.getBool('isTutorialShown') ?? false)) {
      return;
    }

    if (widget.chatType == 'texttospeech') {
      targets.add(
        TargetFocus(identify: "Target 1", keyTarget: selectVoice, contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "You can select voice here for the audio to be generated from the text you enter.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                  ],
                ),
              ))
        ]),
      );
    }
    if (widget.chatType != 'texttospeech') {
      targets.add(
        TargetFocus(identify: "Target 2", keyTarget: textinput, contents: [
          TargetContent(
              align: ContentAlign.left,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Enter your text and press this to generate voice.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10.0),
                  //   child: Text(
                  //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // )
                ],
              ))
        ]),
      );
    }

    showTutorial();
    await sharedPreferences.setBool('isTutorialShown', true);
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: targets, // List<TargetFocus>
      colorShadow: Colors.grey, // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        return true;
      },
      onFinish: () {
        print("finish");
      },
    ).show(context: context);
  }

  bool isPlaying = false;
  // List<File> audios = [];
  File? recordedFile;
  Uint8List? recordedPath;
  int playingIndex = -1;
  List<AudioModel> files = [];
  TextEditingController textEditingController = TextEditingController();
  bool isRecording = false;
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);
    final chat = store.getChatById(widget.chatType, widget.chatId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: AppBarCustom(
          title: AppConstants.appName,
        ),
        elevation: 0.5,
        actions: [
          if (widget.chatType == 'texttospeech')
            Consumer<AudioGeneratorController>(
                builder: (context, controller, child) {
              return PopupMenuButton(
                key: selectVoice,
                tooltip: 'Select voice',
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: controller.selectedVoicer != 'nova',
                    child: const Text('Nova'),
                    onTap: () {
                      controller.updateVoicer(selectvoice: 'nova');
                    },
                  ),
                  PopupMenuItem(
                      enabled: controller.selectedVoicer != 'alloy',
                      onTap: () {
                        controller.updateVoicer(selectvoice: 'alloy');
                      },
                      child: const Text('Alloy')),
                  PopupMenuItem(
                      enabled: controller.selectedVoicer != 'echo',
                      onTap: () {
                        controller.updateVoicer(selectvoice: 'echo');
                      },
                      child: const Text('Echo')),
                  PopupMenuItem(
                      enabled: controller.selectedVoicer != 'fable',
                      onTap: () {
                        controller.updateVoicer(selectvoice: 'fable');
                      },
                      child: const Text('Fable')),
                  PopupMenuItem(
                      enabled: controller.selectedVoicer != 'onyx',
                      onTap: () {
                        controller.updateVoicer(selectvoice: 'onyx');
                      },
                      child: const Text('Onyx')),
                  PopupMenuItem(
                      enabled: controller.selectedVoicer != 'shimmer',
                      onTap: () {
                        controller.updateVoicer(selectvoice: 'shimmer');
                      },
                      child: const Text('Shimmer'))
                ],
              );
            }),
          const SizedBox(width: 20),
        ],
      ),
      // backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Consumer<AudioGeneratorController>(
          builder: (context, audiogeneratorController, child) {
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.78,
              child: audiogeneratorController.generatedFiles.isEmpty
                  ? Center(
                      child: Text(
                          "Generated ${widget.chatType == 'speechtotext' ? "text" : 'audio'} will be shown here"),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: audiogeneratorController.generatedFiles.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(audiogeneratorController
                                  .generatedFiles[index].text ??
                              ''),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                if (playingIndex == index) {
                                  playingIndex = -1;
                                  pausePlayer();
                                } else {
                                  playingIndex = index;
                                  playAudio(widget.chatType == 'speechtotext'
                                      ? BytesSource(audiogeneratorController
                                          .generatedFiles[index].recorded!)
                                      : UrlSource(audiogeneratorController
                                          .generatedFiles[index].file!.path));
                                }
                              });
                            },
                            icon: Icon(playingIndex == index
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: audiogeneratorController.isLoading
                  ? const CircularProgressIndicator()
                  : widget.chatType == 'speechtotext'
                      ? Card(
                          // key: textinput,
                          child: ListTile(
                            leading: IconButton(
                                onPressed: () async {
                                  if (isRecording) {
                                    var path = await record.stop();
                                    if (path != null) {
                                      recordedPath =
                                          File(path).readAsBytesSync();
                                      recordedFile = File(path);
                                    }
                                    setState(() {
                                      isRecording = false;
                                    });
                                  } else {
                                    if (recordedPath != null) {
                                      await pausePlayer();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                      await playAudio(
                                          BytesSource(recordedPath!));
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    } else {
                                      snackBar(context,
                                          title: 'Nothing was recorded.');
                                    }
                                  }
                                },
                                icon: Icon(isRecording || isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow)),
                            // titleAlignment: ListTileTitleAlignment.ce,
                            title: recordedPath != null
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        recordedPath = null;
                                      });
                                    },
                                    icon: const Icon(Icons.clear))
                                : Text(isRecording ? 'Recording...' : ''),
                            onTap: () {
                              if (recordedPath != null) {
                                audiogeneratorController.generateText(
                                    audioFile: recordedFile!);
                                setState(() {
                                  recordedPath = null;
                                });
                              }
                            },
                            trailing: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    isRecording = true;
                                  });
                                  recordAudio();
                                },
                                child: Icon(recordedPath == null
                                    ? Icons.mic
                                    : Icons.send)),
                          ),
                        )
                      : QuestionInput(
                          Keytoshow: textinput,
                          key: globalQuestionInputKey,
                          chat: chat,
                          controller: textEditingController,
                          loadAdd: () {},
                          autofocus: widget.autofocus,
                          icon: widget.chatType == "speechtotext"
                              ? "images/submit_icon.png"
                              : widget.chatType == "texttospeech"
                                  ? "images/speaker.png"
                                  : 'images/submit_icon.png',
                          enabled: true,
                          ontap: () {
                            if (textEditingController.text.isEmpty) {
                              snackBar(context,
                                  title: 'Enter something to generate');
                            }

                            Provider.of<AudioGeneratorController>(context,
                                    listen: false)
                                .generateAudio(
                                    text: textEditingController.text);
                            textEditingController.text = '';
                          },
                          scrollToBottom: () {
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              // scrollToBottom();
                            });
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }
}
