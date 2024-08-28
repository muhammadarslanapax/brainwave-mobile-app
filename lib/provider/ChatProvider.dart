// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../model/AudioModel.dart';

class AudioGeneratorController extends ChangeNotifier {
  String? _selectedVoicer;
  String get selectedVoicer => _selectedVoicer ?? 'nova';
  List<AudioModel>? _generatedFiles;
  List<AudioModel> get generatedFiles => _generatedFiles ?? [];
  bool? _isLoading;

  bool get isLoading => _isLoading ?? false;
  updateVoicer({required String selectvoice}) {
    _selectedVoicer = selectvoice;
    notifyListeners();
  }

  generateAudio({required String text}) async {
    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      _isLoading = true;
      notifyListeners();
      AudioModel audioModel = AudioModel();
      audioModel.text = text;
      // The speech request.
      File speechFile = await OpenAI.instance.audio.createSpeech(
        model: "tts-1",
        input: text,
        voice: selectedVoicer,
        responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
        outputDirectory: await Directory(appDocDirectory.path +
                '/' +
                "speechOutput" +
                (generatedFiles.length.toString()))
            .create(),
        outputFileName: "anas",
      );
      audioModel.file = speechFile;
      _generatedFiles ??= [];
      _generatedFiles!.add(audioModel);
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  clearFiles() {
    _generatedFiles = [];
    notifyListeners();
  }

  generateText({required File audioFile, bool firstTime = false}) async {
    try {
      _isLoading = true;
      notifyListeners();
      OpenAIAudioModel transcription =
          await OpenAI.instance.audio.createTranscription(
        file: audioFile,
        model: "whisper-1",
        responseFormat: OpenAIAudioResponseFormat.json,
      );
      _generatedFiles ??= [];
      AudioModel audioModel = AudioModel(recorded: audioFile.readAsBytesSync());
      audioModel.text = transcription.text;
      _generatedFiles!.add(audioModel);
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }
}
