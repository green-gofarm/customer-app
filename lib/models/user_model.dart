import 'package:customer_app/utils/enum/gender.dart';
import 'package:customer_app/utils/map_utils.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final int? role;
  final Gender? gender;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  UserModel({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.dateOfBirth,
    this.phoneNumber,
    this.role,
    this.gender,
    this.status,
    this.createdDate,
    this.updatedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      avatar: json['avatar'],
      dateOfBirth: json['dateOfBirth'] != null && json['dateOfBirth'] is String
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      gender: json['gender'] != null
          ? GenderExtension.fromValue(json['gender'])
          : null,
      status: json['status'],
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    DateTime? dateOfBirth,
    String? phoneNumber,
    int? role,
    Gender? gender,
    int? status,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'role': role,
      'gender': gender?.value,
      'status': status,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return MapUtils.filterNullValues({
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'gender': gender?.value,
    });
  }
}
