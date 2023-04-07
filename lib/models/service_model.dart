class ServiceModel {
  final int? id;
  final String? name;
  final String? description;
  final int? status;
  final int? farmstayId;
  final int? categoryId;
  final String? image;
  final double? price;
  final String? createdDate;
  final String? updatedDate;

  ServiceModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.farmstayId,
    this.categoryId,
    this.image,
    this.price,
    this.createdDate,
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
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
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
