class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final int? role;
  final int? gender;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.role,
    this.gender,
    this.status,
    this.createdDate,
    this.updatedDate
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
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

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, avatar: $avatar, role: $role, gender: $gender, status: $status, createdDate: $createdDate}';
  }
}
