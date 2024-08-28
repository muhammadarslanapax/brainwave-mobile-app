import 'dart:convert';

import 'package:flutter/foundation.dart';

class CategoryModel {
  String title;
  Function()? onPress;
  String? type;
  String? desc;
  bool? isContinuous;
  String? content;
  String image;
  List<String> tips = [];
  CategoryModel({
    required this.title,
    this.onPress,
    this.type,
    this.desc,
    this.isContinuous,
    this.content,
    required this.tips,
    required this.image,
  });

  CategoryModel copyWith({
    String? title,
    Function()? onPress,
    String? type,
    String? desc,
    bool? isContinuous,
    String? content,
    List<String>? tips,
    String? image,
  }) {
    return CategoryModel(
      title: title ?? this.title,
      onPress: onPress ?? this.onPress,
      type: type ?? this.type,
      desc: desc ?? this.desc,
      isContinuous: isContinuous ?? this.isContinuous,
      content: content ?? this.content,
      tips: tips ?? this.tips,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    // if (onPress != null) {
    //   result.addAll({'onPress': onPress!.toMap()});
    // }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (desc != null) {
      result.addAll({'desc': desc});
    }
    if (isContinuous != null) {
      result.addAll({'isContinuous': isContinuous});
    }
    if (content != null) {
      result.addAll({'content': content});
    }
    result.addAll({'image': image});
    result.addAll({'tips': tips});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      title: map['title'] ?? '',
      // onPress:
      //     map['onPress'] != null ? Function().fromMap(map['onPress']) : null,
      type: map['type'],
      desc: map['desc'],
      isContinuous: map['isContinuous'],
      content: map['content'],
      image: map['image'],
      tips: List<String>.from(map['tips']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(title: $title, onPress: $onPress, image:$image,type: $type, desc: $desc, isContinuous: $isContinuous, content: $content, tips: $tips)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.title == title &&
        other.onPress == onPress &&
        other.type == type &&
        other.desc == desc &&
        other.isContinuous == isContinuous &&
        other.content == content &&
        other.image == image &&
        listEquals(other.tips, tips);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        onPress.hashCode ^
        type.hashCode ^
        desc.hashCode ^
        isContinuous.hashCode ^
        content.hashCode ^
        image.hashCode ^
        tips.hashCode;
  }
}
