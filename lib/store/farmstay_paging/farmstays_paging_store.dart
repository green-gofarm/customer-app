import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/utils/enum/farmstay_status.dart';
import 'package:customer_app/utils/map_utils.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';

part 'farmstays_paging_store.g.dart';

typedef StoreResult<T> = Tuple2<String?, T>;

class FarmstayPagingStore extends _FarmstayPagingStore
    with _$FarmstayPagingStore {}

abstract class _FarmstayPagingStore with Store {
  final FarmstayApi _farmstayApi = FarmstayApi();

  @observable
  List<FarmstayModel> farmstays = [];

  @observable
  PaginationModel pagination = PaginationModel(
    orderBy: PaginationModel.DEFAULT_ORDER_BY,
    orderDirection: PaginationModel.DEFAULT_ORDER_DIRECTION,
  );

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

      final totalParams = {
        // 'Status': FarmstayStatus.ACTIVE.value,
        // 'query': "Hồ Chí Minh",
        'page': _pagination.page,
        'pageSize': _pagination.pageSize,
        'orderBy': _pagination.orderBy ?? PaginationModel.DEFAULT_ORDER_BY,
        'orderDirection': _pagination.orderDirection ??
            PaginationModel.DEFAULT_ORDER_DIRECTION,
        ..._params,
      };

      final preparedParams =
          MapUtils.convertToStringMap(MapUtils.filterNullValues(totalParams));
      final result =
          await _farmstayApi.searchFarmstay(preparedParams);

      PagingModel<FarmstayModel>? temp = null;

      await result.fold(
        (l) => this.message = l,
        (r) => temp = r,
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
        farmstays = List.of(temp!.data!);
        logger.i("DATA: ${temp!.data!.length}");
      }

      logger.i("Message");
    } catch (e) {
      logger.e("Search farmstay error: #${e.toString()}");
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
      ),
    );
  }

  @action
  Future<void> handleChangeParams(Map<String, dynamic> params) async {
    await refresh(newParams: params);
  }
}
