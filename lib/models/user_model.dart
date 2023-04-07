class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final int? role;
  final int? gender;
  final int? status;
  final DateTime? createdDate;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.role,
    this.gender,
    this.status,
    this.createdDate,
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
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, avatar: $avatar, role: $role, gender: $gender, status: $status, createdDate: $createdDate}';
  }
}
