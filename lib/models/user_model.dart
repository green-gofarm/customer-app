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
  final int? gender;
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
      gender: json['gender'],
      status: json['status'],
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
