import 'package:customer_app/models/image_model.dart';
import 'package:customer_app/utils/enum/cart_item_type.dart';

class ActivityTicketModel {
  final int id;
  final String? name;
  final int itemId;
  final String? description;
  final CartItemType type;
  final int status;
  final DateTime date;
  final int price;
  final ImagesModel images;

  ActivityTicketModel({
    required this.id,
    this.name,
    required this.itemId,
    this.description,
    required this.type,
    required this.status,
    required this.date,
    required this.price,
    required this.images,
  });

  factory ActivityTicketModel.fromJson(Map<String, dynamic> json) {
    return ActivityTicketModel(
      id: json['id'],
      name: json['name'],
      itemId: json['itemId'],
      description: json['description'],
      type: CartItemTypeExtension.fromValue(json['type'])!,
      status: json['status'],
      date: DateTime.parse(json['date']),
      price: json['price'] ?? 0,
      images: ImagesModel.fromJson(json['images']),
    );
  }
}
