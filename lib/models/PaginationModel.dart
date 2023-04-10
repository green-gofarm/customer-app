

class PaginationModel {
  static final int DEFAULT_PAGE = 1;
  static final int DEFAULT_PAGE_SIZE = 6;
  static final String DEFAULT_ORDER_BY = "createdDate";
  static final String DEFAULT_ORDER_DIRECTION = "desc";

  int _page;
  int _pageSize;
  String? orderBy;
  String? orderDirection;
  int? totalPage;
  int? totalItem;

  PaginationModel({
    int? page,
    int? pageSize,
    this.orderBy,
    this.orderDirection,
    this.totalPage,
    this.totalItem,
  }) : _page = page == null || page < 1 ? DEFAULT_PAGE : page,
        _pageSize = pageSize == null || pageSize < 0 ? DEFAULT_PAGE_SIZE : pageSize;

  int get page => _page;
  set page(int page) {
    _page = page < 1 ? 1 : page;
  }

  int get pageSize => _pageSize;
  set pageSize(int pageSize) {
    _pageSize = pageSize;
  }
}