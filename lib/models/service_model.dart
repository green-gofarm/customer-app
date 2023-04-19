class ServiceModel {
  final int id;
  final String name;
  final String? description;
  final int? status;
  final int? farmstayId;
  final int? categoryId;
  final String image;
  final int price;
  final DateTime createdDate;
  final DateTime? updatedDate;

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
    this.status,
    this.farmstayId,
    this.categoryId,
    required this.image,
    required this.price,
    required this.createdDate,
    this.updatedDate,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      farmstayId: json['farmstayId'],
      categoryId: json['categoryId'],
      image: json['image'],
      price: json['price'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'farmstayId': farmstayId,
      'categoryId': categoryId,
      'image': image,
      'price': price,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }
}
