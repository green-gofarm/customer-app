class PagingModel<T> {
  final List<T>? data;
  final int? page;
  final int? pageSize;
  final int? totalPage;
  final int? totalItem;

  PagingModel({
    this.data,
    this.page,
    this.pageSize,
    this.totalPage,
    this.totalItem,
  });

  factory PagingModel.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return PagingModel<T>(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => fromJsonT(e))
          .toList()
          .cast<T>(),
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
      totalPage: json['totalPage'] as int?,
      totalItem: json['totalItem'] as int?,
    );
  }

  Map<String, dynamic> toJson(Function toJson) {
    return {
      'data': data?.map((e) => toJson(e)).toList(),
      'page': page,
      'pageSize': pageSize,
      'totalPage': totalPage,
      'totalItem': totalItem,
    };
  }
}
