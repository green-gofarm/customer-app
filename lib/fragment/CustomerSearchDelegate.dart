import 'package:customer_app/components/FarmstayListComponent.dart';
import 'package:customer_app/components/SkeletonFarmstayListComponent.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/store/farmstay_elastic_paging/farmstay_elastic_paging_store.dart';
import 'package:customer_app/store/farmstay_query_autocomplete/farmstay_query_autocomplete_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerSearchDelegate extends SearchDelegate {
  FarmstayElasticPagingStore farmstayStore = FarmstayElasticPagingStore();
  FarmstayQueryAutocompleteStore suggestStore =
      FarmstayQueryAutocompleteStore();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: context.iconColor, size: 20),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (query.isNotEmpty) {
      farmstayStore.reset();
      farmstayStore.refresh(query: query);
    }

    return Observer(
      builder: (_) {
        if (query.isEmpty) {
          return _buildEmpty(context, width);
        }

        if (farmstayStore.message != null) {
          return Center(child: Text(farmstayStore.message!));
        } else {
          return _SearchResults(query: query, farmstayStore: farmstayStore);
        }
      },
    );
  }

  Widget _buildEmpty(BuildContext context, double width) {
    return SingleChildScrollView(
        child: Container(
      color: context.scaffoldBackgroundColor,
      height: context.height(),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: width * 0.15),
              Image(
                  height: width * 0.65,
                  width: width * 0.65,
                  fit: BoxFit.fitHeight,
                  image: AssetImage(wrongkeyword)),
              Text('Không Tìm Thấy',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: width * 0.07),
              Text(
                textAlign: TextAlign.center,
                "Xin lỗi, từ khóa bạn nhập không tìm thấy. \nVui lòng kiểm tra lại hoặc tìm kiếm với \ntừ khóa khác",
                style: TextStyle(fontSize: 14),
              )
            ]),
      ),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    suggestStore.getAutocompletes(query);

    return Observer(
      builder: (_) {
        if (query.isEmpty) {
          return _buildEmpty(context, width);
        }

        if (suggestStore.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (suggestStore.message != null) {
          return Center(child: Text(suggestStore.message!));
        } else {
          return ListView.separated(
            itemCount: suggestStore.suggests.length,
            itemBuilder: (context, index) {
              final suggestion = suggestStore.suggests[index];
              return _buildSuggestionItem(context, suggestion);
            },
            separatorBuilder: (_, __) => SizedBox(child: 8.height),
          );
        }
      },
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String suggestion) {
    return ListTile(
      leading: Icon(Icons.search, color: context.iconColor),
      title: RichText(
        text: TextSpan(
          text: suggestion.substring(0, query.length),
          style: TextStyle(color: rf_primaryColor, fontSize: 18),
          children: [
            TextSpan(
              text: suggestion.substring(query.length),
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
      onTap: () {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }
}

class _SearchResults extends StatefulWidget {
  final String query;
  final FarmstayElasticPagingStore farmstayStore;

  _SearchResults({required this.query, required this.farmstayStore});

  @override
  __SearchResultsState createState() => __SearchResultsState();
}

class __SearchResultsState extends State<_SearchResults> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (widget.farmstayStore.isLoading) {
      return;
    }
    if (widget.farmstayStore.pagination.totalItem != null &&
        widget.farmstayStore.pagination.totalItem! >
            widget.farmstayStore.farmstays.length) {
      final newPageSize = widget.farmstayStore.pagination.pageSize +
          PaginationModel.DEFAULT_PAGE_SIZE;
      widget.farmstayStore.handleChangePageSize(
          newPageSize <= widget.farmstayStore.pagination.totalItem!
              ? newPageSize
              : widget.farmstayStore.pagination.totalItem!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      List<Widget> skeletonList = [
        for (var i = 0; i < 3; i++)
          Container(
            child: SkeletonFarmstayListComponent(),
          ),
      ];

      return RefreshIndicator(
        onRefresh: () async {
          await widget.farmstayStore.refresh(query: widget.query);
        },
        child: Container(
          color: mainBgColor,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: context.width(),
                child: Text(
                  'Kết quả tìm kiếm (${widget.farmstayStore.pagination.totalItem})',
                  style: boldTextStyle(),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: widget.farmstayStore.farmstays.length +
                      (widget.farmstayStore.isLoading ? 3 : 0),
                  itemBuilder: (context, index) {
                    if (index < widget.farmstayStore.farmstays.length) {
                      final farmstay = widget.farmstayStore.farmstays[index];
                      return Container(
                        child: FarmstayListComponent(farmstay: farmstay),
                      );
                    } else {
                      return skeletonList[
                          index - widget.farmstayStore.farmstays.length];
                    }
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
