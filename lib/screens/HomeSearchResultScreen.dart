import 'package:customer_app/components/FarmstayListComponent.dart';
import 'package:customer_app/components/SkeletonFarmstayListComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/store/farmstay_home_paging/farmstay_home_paging_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeSearchResultScreen extends StatefulWidget {
  @override
  HomeSearchResultScreenState createState() => HomeSearchResultScreenState();
}

class HomeSearchResultScreenState extends State<HomeSearchResultScreen> {
  FarmstayPagingHomeStore store = FarmstayPagingHomeStore();
  bool loading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    init();
  }

  void init() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    store.reset();
    await store.refresh();
    await Future.delayed(Duration(seconds: 2));
    setState(() => loading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await Future.delayed(Duration(seconds: 2));
      await _loadMore();
    }
  }

  Future<void> _loadMore() async {
    logger.i("trigger loadmore");
    if (store.isLoading) {
      return;
    }
    if (store.pagination.totalItem != null &&
        store.pagination.totalItem! > store.farmstays.length) {
      final newPageSize =
          store.pagination.pageSize + PaginationModel.DEFAULT_PAGE_SIZE;
      store.handleChangePageSize(newPageSize <= store.pagination.totalItem!
          ? newPageSize
          : store.pagination.totalItem!);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        color: mainBgColor,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _buildRefreshIndicator(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RefreshIndicator _buildRefreshIndicator(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh();
      },
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Expanded(child: _buildListFarmstay(context)),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildListFarmstay(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: store.farmstays.length + (store.isLoading ? 3 : 0),
      itemBuilder: (context, i) {
        if (i < store.farmstays.length) {
          return FarmstayListComponent(farmstay: store.farmstays[i]);
        } else {
          return SkeletonFarmstayListComponent();
        }
      },
      separatorBuilder: (_, __) => SizedBox(height: 8),
    );
  }
}
