import 'dart:convert';

class KeysModel {
  String? id;
  String? OPENAI_CHATGPT_TOKEN;
  String? bannerAddID_android;
  String? iosBannerAddId;
  String? adRewardedUnitId;
  String? iosAdRewardedUnitId;

  String? nativeAddUnitId;
  String? iosNativeAddUnitId;
  String? adIntersialUnitId;
  String? iosAdIntersialUnitId;
  String? PAYPAL_CLIENT_ID;
  String? PAYPAL_SECRET_ID;
  String? Stripe_Publishable_Key;
  String? Stripe_SECRET_Key;
  KeysModel({
    this.id,
    this.OPENAI_CHATGPT_TOKEN,
    this.bannerAddID_android,
    this.iosBannerAddId,
    this.adRewardedUnitId,
    this.iosAdRewardedUnitId,
    this.nativeAddUnitId,
    this.iosNativeAddUnitId,
    this.adIntersialUnitId,
    this.iosAdIntersialUnitId,
    this.PAYPAL_CLIENT_ID,
    this.PAYPAL_SECRET_ID,
    this.Stripe_Publishable_Key,
    this.Stripe_SECRET_Key,
  });

  KeysModel copyWith({
    String? id,
    String? OPENAI_CHATGPT_TOKEN,
    String? bannerAddID_android,
    String? iosBannerAddId,
    String? adRewardedUnitId,
    String? iosAdRewardedUnitId,
    String? nativeAddUnitId,
    String? iosNativeAddUnitId,
    String? adIntersialUnitId,
    String? iosAdIntersialUnitId,
    String? PAYPAL_CLIENT_ID,
    String? PAYPAL_SECRET_ID,
    String? Stripe_Publishable_Key,
    String? Stripe_SECRET_Key,
  }) {
    return KeysModel(
      id: id ?? this.id,
      OPENAI_CHATGPT_TOKEN: OPENAI_CHATGPT_TOKEN ?? this.OPENAI_CHATGPT_TOKEN,
      bannerAddID_android: bannerAddID_android ?? this.bannerAddID_android,
      iosBannerAddId: iosBannerAddId ?? this.iosBannerAddId,
      adRewardedUnitId: adRewardedUnitId ?? this.adRewardedUnitId,
      iosAdRewardedUnitId: iosAdRewardedUnitId ?? this.iosAdRewardedUnitId,
      nativeAddUnitId: nativeAddUnitId ?? this.nativeAddUnitId,
      iosNativeAddUnitId: iosNativeAddUnitId ?? this.iosNativeAddUnitId,
      adIntersialUnitId: adIntersialUnitId ?? this.adIntersialUnitId,
      iosAdIntersialUnitId: iosAdIntersialUnitId ?? this.iosAdIntersialUnitId,
      PAYPAL_CLIENT_ID: PAYPAL_CLIENT_ID ?? this.PAYPAL_CLIENT_ID,
      PAYPAL_SECRET_ID: PAYPAL_SECRET_ID ?? this.PAYPAL_SECRET_ID,
      Stripe_Publishable_Key:
          Stripe_Publishable_Key ?? this.Stripe_Publishable_Key,
      Stripe_SECRET_Key: Stripe_SECRET_Key ?? this.Stripe_SECRET_Key,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (OPENAI_CHATGPT_TOKEN != null) {
      result.addAll({'OPENAI_CHATGPT_TOKEN': OPENAI_CHATGPT_TOKEN});
    }
    if (bannerAddID_android != null) {
      result.addAll({'bannerAddID_android': bannerAddID_android});
    }
    if (iosBannerAddId != null) {
      result.addAll({'iosBannerAddId': iosBannerAddId});
    }
    if (adRewardedUnitId != null) {
      result.addAll({'adRewardedUnitId': adRewardedUnitId});
    }
    if (iosAdRewardedUnitId != null) {
      result.addAll({'iosAdRewardedUnitId': iosAdRewardedUnitId});
    }
    if (nativeAddUnitId != null) {
      result.addAll({'nativeAddUnitId': nativeAddUnitId});
    }
    if (iosNativeAddUnitId != null) {
      result.addAll({'iosNativeAddUnitId': iosNativeAddUnitId});
    }
    if (adIntersialUnitId != null) {
      result.addAll({'adIntersialUnitId': adIntersialUnitId});
    }
    if (iosAdIntersialUnitId != null) {
      result.addAll({'iosAdIntersialUnitId': iosAdIntersialUnitId});
    }
    if (PAYPAL_CLIENT_ID != null) {
      result.addAll({'PAYPAL_CLIENT_ID': PAYPAL_CLIENT_ID});
    }
    if (PAYPAL_SECRET_ID != null) {
      result.addAll({'PAYPAL_SECRET_ID': PAYPAL_SECRET_ID});
    }
    if (Stripe_Publishable_Key != null) {
      result.addAll({'Stripe_Publishable_Key': Stripe_Publishable_Key});
    }
    if (Stripe_SECRET_Key != null) {
      result.addAll({'Stripe_SECRET_Key': Stripe_SECRET_Key});
    }

    return result;
  }

  factory KeysModel.fromMap(Map<String, dynamic> map) {
    return KeysModel(
      id: map['id'],
      OPENAI_CHATGPT_TOKEN: map['OPENAI_CHATGPT_TOKEN'],
      bannerAddID_android: map['bannerAddID_android'],
      iosBannerAddId: map['iosBannerAddId'],
      adRewardedUnitId: map['adRewardedUnitId'],
      iosAdRewardedUnitId: map['iosAdRewardedUnitId'],
      nativeAddUnitId: map['nativeAddUnitId'],
      iosNativeAddUnitId: map['iosNativeAddUnitId'],
      adIntersialUnitId: map['adIntersialUnitId'],
      iosAdIntersialUnitId: map['iosAdIntersialUnitId'],
      PAYPAL_CLIENT_ID: map['PAYPAL_CLIENT_ID'],
      PAYPAL_SECRET_ID: map['PAYPAL_SECRET_ID'],
      Stripe_Publishable_Key: map['Stripe_Publishable_Key'],
      Stripe_SECRET_Key: map['Stripe_SECRET_Key'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KeysModel.fromJson(String source) =>
      KeysModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KeysModel(id: $id, OPENAI_CHATGPT_TOKEN: $OPENAI_CHATGPT_TOKEN, bannerAddID_android: $bannerAddID_android, iosBannerAddId: $iosBannerAddId, adRewardedUnitId: $adRewardedUnitId, iosAdRewardedUnitId: $iosAdRewardedUnitId, nativeAddUnitId: $nativeAddUnitId, iosNativeAddUnitId: $iosNativeAddUnitId, adIntersialUnitId: $adIntersialUnitId, iosAdIntersialUnitId: $iosAdIntersialUnitId, PAYPAL_CLIENT_ID: $PAYPAL_CLIENT_ID, PAYPAL_SECRET_ID: $PAYPAL_SECRET_ID, Stripe_Publishable_Key: $Stripe_Publishable_Key, Stripe_SECRET_Key: $Stripe_SECRET_Key)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeysModel &&
        other.id == id &&
        other.OPENAI_CHATGPT_TOKEN == OPENAI_CHATGPT_TOKEN &&
        other.bannerAddID_android == bannerAddID_android &&
        other.iosBannerAddId == iosBannerAddId &&
        other.adRewardedUnitId == adRewardedUnitId &&
        other.iosAdRewardedUnitId == iosAdRewardedUnitId &&
        other.nativeAddUnitId == nativeAddUnitId &&
        other.iosNativeAddUnitId == iosNativeAddUnitId &&
        other.adIntersialUnitId == adIntersialUnitId &&
        other.iosAdIntersialUnitId == iosAdIntersialUnitId &&
        other.PAYPAL_CLIENT_ID == PAYPAL_CLIENT_ID &&
        other.PAYPAL_SECRET_ID == PAYPAL_SECRET_ID &&
        other.Stripe_Publishable_Key == Stripe_Publishable_Key &&
        other.Stripe_SECRET_Key == Stripe_SECRET_Key;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        OPENAI_CHATGPT_TOKEN.hashCode ^
        bannerAddID_android.hashCode ^
        iosBannerAddId.hashCode ^
        adRewardedUnitId.hashCode ^
        iosAdRewardedUnitId.hashCode ^
        nativeAddUnitId.hashCode ^
        iosNativeAddUnitId.hashCode ^
        adIntersialUnitId.hashCode ^
        iosAdIntersialUnitId.hashCode ^
        PAYPAL_CLIENT_ID.hashCode ^
        PAYPAL_SECRET_ID.hashCode ^
        Stripe_Publishable_Key.hashCode ^
        Stripe_SECRET_Key.hashCode;
  }
}
