class FarmstayScheduleItemModel {
  final int? totalItem;
  final int? availableItem;
  final bool? available;
  final String? state;
  final bool? readyForSell;
  final String? itemName;
  final int? itemId;
  final String? itemType;

  FarmstayScheduleItemModel({
    this.totalItem,
    this.availableItem,
    this.available,
    this.state,
    this.readyForSell,
    this.itemName,
    this.itemId,
    this.itemType,
  });

  factory FarmstayScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return FarmstayScheduleItemModel(
      totalItem: json['totalItem'],
      availableItem: json['availableItem'],
      available: json['available'],
      state: json['state'],
      readyForSell: json['readyForSell'],
      itemName: json['itemName'],
      itemId: json['itemId'],
      itemType: json['itemType'],
    );
  }
}