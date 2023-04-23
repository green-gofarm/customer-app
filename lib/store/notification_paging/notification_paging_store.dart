import 'package:customer_app/data/notification/notification_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/models/notification_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/utils/map_utils.dart';
import 'package:mobx/mobx.dart';

part 'notification_paging_store.g.dart';

class NotificationPagingStore extends _NotificationPagingStore
    with _$NotificationPagingStore {}

abstract class _NotificationPagingStore with Store {
  final NotificationApi _api = NotificationApi();

  @observable
  List<NotificationModel> notifications = [];

  @observable
  PaginationModel pagination = PaginationModel(
      orderBy: PaginationModel.DEFAULT_ORDER_BY,
      orderDirection: PaginationModel.DEFAULT_ORDER_DIRECTION,
      pageSize: 10);

  @observable
  Map<String, dynamic> params = Map();

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @computed
  PaginationModel get Pagination => pagination;

  void clear() {
    message = null;
  }

  void reset() {
    pagination.pageSize = 6;
  }

  @action
  Future<void> refresh({
    PaginationModel? newPagination,
    Map<String, dynamic>? newParams,
  }) async {
    clear();
    isLoading = true;

    try {
      final _pagination = newPagination ?? Pagination;
      final _params = newParams ?? params;

      final Map<String, dynamic> totalParams = {
        'page': _pagination.page,
        'pageSize': _pagination.pageSize,
        'orderBy': _pagination.orderBy ?? PaginationModel.DEFAULT_ORDER_BY,
        'orderDirection': _pagination.orderDirection ??
            PaginationModel.DEFAULT_ORDER_DIRECTION,
        ..._params,
      };

      final preparedParams = MapUtils.filterNullValues(totalParams);
      final result = await _api.getNotifications(preparedParams);

      PagingModel<NotificationModel>? temp = null;

      await result.fold(
        (l) => {this.message = l},
        (r) {
          temp = r;
          this.message = null;
        },
      );

      if (temp == null) return;

      if (_pagination.page > temp!.totalPage! && _pagination.page != 1) {
        final _new = PaginationModel(
          page: 1,
          pageSize: _pagination.pageSize,
          orderBy: _pagination.orderBy,
          orderDirection: _pagination.orderDirection,
          totalPage: temp!.totalPage,
          totalItem: temp!.totalItem,
        );

        await refresh(newPagination: _new, newParams: newParams);
        return;
      }

      pagination = _pagination;
      pagination.totalItem = temp!.totalItem;
      pagination.totalPage = temp!.totalPage;

      if (temp!.data != null && temp!.data!.isNotEmpty) {
        notifications = List.of(temp!.data!);
        logger.i("DATA: ${temp!.data!.length}");
      }

      logger.i("Message");
    } catch (e) {
      logger.e("Get noti list error: #${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> handleChangePageSize(int newPageSize) async {
    await refresh(
        newPagination: PaginationModel(
      page: Pagination.page,
      pageSize: newPageSize,
      orderBy: Pagination.orderBy,
      orderDirection: Pagination.orderDirection,
    ));
  }

  @action
  Future<void> handleChangeParams(Map<String, dynamic> params) async {
    await refresh(newParams: params);
  }
}
