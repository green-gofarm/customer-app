import 'dart:convert';

class ImagesModel {
  final String? avatar;
  final List<String> others;

  ImagesModel({required this.avatar, required this.others});

  factory ImagesModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> others = json['others'];
    return ImagesModel(
      avatar: json['avatar'],
      others: List<String>.from(others.map((x) => x as String)),
    );
  }
}
