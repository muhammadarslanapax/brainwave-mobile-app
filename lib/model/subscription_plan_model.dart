// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubscriptionPlanModel {
  String? pId;
  String? subscriptionName;
  int? duration;
  String? description;
  double? subscriptionPrice;
  int? offerPrice;
  SubscriptionPlanModel({
    this.pId,
    this.subscriptionName,
    this.duration,
    this.description,
    this.subscriptionPrice,
    this.offerPrice,
  });

  SubscriptionPlanModel copyWith({
    String? pId,
    String? subscriptionName,
    int? duration,
    String? description,
    double? subscriptionPrice,
    int? offerPrice,
  }) {
    return SubscriptionPlanModel(
      pId: pId ?? this.pId,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      subscriptionPrice: subscriptionPrice ?? this.subscriptionPrice,
      offerPrice: offerPrice ?? this.offerPrice,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (pId != null) {
      result.addAll({'pId': pId});
    }
    if (subscriptionName != null) {
      result.addAll({'subscriptionName': subscriptionName});
    }
    if (duration != null) {
      result.addAll({'duration': duration});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (subscriptionPrice != null) {
      result.addAll({'subscriptionPrice': subscriptionPrice});
    }
    if (offerPrice != null) {
      result.addAll({'offerPrice': offerPrice});
    }

    return result;
  }

  factory SubscriptionPlanModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlanModel(
      pId: map['pId'],
      subscriptionName: map['subscriptionName'],
      duration: map['duration']?.toInt(),
      description: map['description'],
      subscriptionPrice: map['subscriptionPrice']?.toDouble(),
      offerPrice: map['offerPrice']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionPlanModel.fromJson(String source) =>
      SubscriptionPlanModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubscriptionPlanModel(pId: $pId, subscriptionName: $subscriptionName, duration: $duration, description: $description, subscriptionPrice: $subscriptionPrice, offerPrice: $offerPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionPlanModel &&
        other.pId == pId &&
        other.subscriptionName == subscriptionName &&
        other.duration == duration &&
        other.description == description &&
        other.subscriptionPrice == subscriptionPrice &&
        other.offerPrice == offerPrice;
  }

  @override
  int get hashCode {
    return pId.hashCode ^
        subscriptionName.hashCode ^
        duration.hashCode ^
        description.hashCode ^
        subscriptionPrice.hashCode ^
        offerPrice.hashCode;
  }
}
