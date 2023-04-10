class ScheduleItemModel {
  final int? totalItem;
  final int? availableItem;
  final bool? available;
  final String? state;
  final bool? readyForSell;

  ScheduleItemModel({
    this.totalItem,
    this.availableItem,
    this.available,
    this.state,
    this.readyForSell,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      totalItem: json['totalItem'],
      availableItem: json['availableItem'],
      available: json['available'],
      state: json['state'],
      readyForSell: json['readyForSell'],
    );
  }
}
