// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';

class UserModel {
  String? name;

  int? Plandays;
  String? email;
  String? phone_number;
  String? password;
  String? image;
  String? startDate;
  bool? status;
  String? endDate;
  String? user_id;
  String? pId;
  UserModel({
    this.name,
    this.Plandays,
    this.email,
    this.phone_number,
    this.password,
    this.image,
    this.startDate,
    this.status,
    this.endDate,
    this.user_id,
    this.pId,
  });

  UserModel copyWith({
    String? name,
    int? Plandays,
    String? email,
    String? phone_number,
    String? password,
    String? image,
    String? startDate,
    bool? status,
    String? endDate,
    String? user_id,
    String? pId,
  }) {
    return UserModel(
      name: name ?? this.name,
      Plandays: Plandays ?? this.Plandays,
      email: email ?? this.email,
      phone_number: phone_number ?? this.phone_number,
      password: password ?? this.password,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      endDate: endDate ?? this.endDate,
      user_id: user_id ?? this.user_id,
      pId: pId ?? this.pId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (Plandays != null) {
      result.addAll({'Plandays': Plandays});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone_number != null) {
      result.addAll({'phone_number': phone_number});
    }
    if (password != null) {
      result.addAll({'password': password});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (startDate != null) {
      result.addAll({'startDate': startDate});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (endDate != null) {
      result.addAll({'endDate': endDate});
    }
    if (user_id != null) {
      result.addAll({'user_id': user_id});
    }
    if (pId != null) {
      result.addAll({'pId': pId});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      Plandays: map['Plandays']?.toInt(),
      email: map['email'],
      phone_number: map['phone_number'],
      password: map['password'],
      image: map['image'],
      startDate: map['startDate'],
      status: map['status'],
      endDate: map['endDate'],
      user_id: map['user_id'],
      pId: map['pId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, Plandays: $Plandays, email: $email, phone_number: $phone_number, password: $password, image: $image, startDate: $startDate, status: $status, endDate: $endDate, user_id: $user_id, pId: $pId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.Plandays == Plandays &&
        other.email == email &&
        other.phone_number == phone_number &&
        other.password == password &&
        other.image == image &&
        other.startDate == startDate &&
        other.status == status &&
        other.endDate == endDate &&
        other.user_id == user_id &&
        other.pId == pId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        Plandays.hashCode ^
        email.hashCode ^
        phone_number.hashCode ^
        password.hashCode ^
        image.hashCode ^
        startDate.hashCode ^
        status.hashCode ^
        endDate.hashCode ^
        user_id.hashCode ^
        pId.hashCode;
  }
}
