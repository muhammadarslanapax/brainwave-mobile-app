import 'dart:io';
import 'dart:typed_data';

class AudioModel {
  bool isTextToSpeech;
  Uint8List? recorded;
  String? text;
  File? file;

  AudioModel({this.text, this.recorded, this.file, this.isTextToSpeech = true});
}
