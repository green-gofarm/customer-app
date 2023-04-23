import 'package:customer_app/main.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/models/notification_model.dart';
import 'package:customer_app/screens/BookingDetailScreen.dart';
import 'package:customer_app/store/notification_paging/notification_paging_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/notification_status.dart';
import 'package:customer_app/utils/enum/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tuple/tuple.dart';

class NotificationFragment extends StatefulWidget {
  @override
  NotificationFragmentState createState() => NotificationFragmentState();
}

class NotificationFragmentState extends State<NotificationFragment> {
  static const String APPBAR_NAME = "Thông báo";

  final NotificationPagingStore store = NotificationPagingStore();
  ScrollController _scrollController = ScrollController();

  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    init();
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
        store.pagination.totalItem! > store.notifications.length) {
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

  void init() async {
    setState(() => loadingInit = true);
    await _refresh();
    setState(() => loadingInit = false);
  }

  Future<void> _refresh() async {
    await store.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: _buildAppbar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      APPBAR_NAME,
      center: true,
      showBack: false,
      color: rf_primaryColor,
      textColor: Colors.white,
      textSize: 18,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color:
          appStore.isDarkModeOn ? context.scaffoldBackgroundColor : mainBgColor,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: store.notifications.isEmpty
                ? _buildEmpty(context, MediaQuery.of(context).size.width)
                : Column(
                    children: [
                      SizedBox(height: 8),
                      Expanded(child: _buildListView()),
                      SizedBox(height: 8),
                    ],
                  ),
          ),
          if (loadingInit)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
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
              Icon(Icons.notifications_off_outlined, size: width * 0.5),
              Text('Không có thông báo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ]),
      ),
    ));
  }

  Widget _buildListView() {
    logger.i("List here: ${store.notifications}");
    return ListView.separated(
      controller: _scrollController,
      itemCount: store.notifications.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (_, i) {
        NotificationModel notification = store.notifications[i];
        return _buildItem(notification);
      },
      separatorBuilder: (_, __) => SizedBox(height: 8),
    );
  }

  Widget _buildItem(NotificationModel notification) {
    final iconAndColor = _getIconAndColor(notification);
    final icon = iconAndColor.item1;
    final color = iconAndColor.item2;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: notification.status == NotificationStatuses.unread
            ? Color(0xFFF5F5F5)
            : context.cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5)
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.header,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: notification.status == NotificationStatuses.unread
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: notification.status == NotificationStatuses.unread
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).onTap(() {
      _handleNavigation(notification);
    });
  }

  Tuple2<IconData, Color> _getIconAndColor(NotificationModel notification) {
    IconData icon;
    Color color;

    switch (notification.extras["type"]) {
      case NotificationType.PAYMENT_SUCCESS_CUSTOMER:
        icon = Icons.payment;
        color = Colors.green;
        break;
      case NotificationType.CANCEL_BOOKING_CUSTOMER:
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case NotificationType.BOOKING_APPROVED_CUSTOMER:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case NotificationType.BOOKING_REJECTED_CUSTOMER:
        icon = Icons.error;
        color = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return Tuple2(icon, color);
  }

  void _handleNavigation(NotificationModel notification) {
    switch (notification.extras["type"]) {
      case NotificationType.PAYMENT_SUCCESS_CUSTOMER:
      case NotificationType.CANCEL_BOOKING_CUSTOMER:
      case NotificationType.BOOKING_APPROVED_CUSTOMER:
      case NotificationType.BOOKING_REJECTED_CUSTOMER:
        BookingDetailScreen(
          bookingId: notification.id,
          onBack: () => _refresh(),
        ).launch(context);
        break;
      // Add more cases for other notification types if needed.
    }
  }
}
