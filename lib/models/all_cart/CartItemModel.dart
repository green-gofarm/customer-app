import 'dart:convert';

import 'package:customer_app/models/image_model.dart';
import 'package:customer_app/utils/enum/farmstay_status.dart';

class CartItemModel {
  final int id;
  final int farmstayId;
  final String farmstayName;
  final ImagesModel farmstayImages;
  final FarmstayStatus farmstayStatus;
  final int totalCartItem;

  CartItemModel({
    required this.id,
    required this.farmstayId,
    required this.farmstayName,
    required this.farmstayImages,
    required this.farmstayStatus,
    required this.totalCartItem,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      farmstayName: json['farmstayName'],
      farmstayImages: ImagesModel.fromJson(json['farmstayImages']),
      farmstayStatus: farmstayStatusFromValue(json['farmstayStatus']),
      totalCartItem: json['totalCartItem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmstayId': farmstayId,
      'farmstayName': farmstayName,
      'farmstayImages': jsonEncode(farmstayImages.toJson()),
      'farmstayStatus': farmstayStatus.value,
      'totalCartItem': totalCartItem,
    };
  }
}
