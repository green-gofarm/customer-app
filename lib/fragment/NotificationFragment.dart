import 'package:customer_app/components/NotificationSkeleton.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/models/notification_model.dart';
import 'package:customer_app/screens/BookingDetailScreen.dart';
import 'package:customer_app/store/notification_paging/notification_paging_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/StorageUtil.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/notification_status.dart';
import 'package:customer_app/utils/enum/notification_type.dart';
import 'package:flutter/cupertino.dart';
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
  bool isUnreadOnly = false;

  @override
  void initState() {
    super.initState();
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
      await _loadMore();
    }
  }

  Future<void> _loadMore() async {
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
    _scrollController.addListener(_onScroll);
    isUnreadOnly = await StorageUtil.isOnlyUnread();
    setState(() => loadingInit = true);
    await _refresh();
    setState(() => loadingInit = false);
  }

  Future<void> _refresh() async {
    store.reset();
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
    return appBarWidget(APPBAR_NAME,
        showBack: false,
        color: Colors.white,
        // textColor: Colors.white,
        textSize: 18,
        actions: [
          Row(
            children: [
              Text(
                "Hiển thị chưa đọc",
                style: secondaryTextStyle(size: 12),
              ),
              Transform.scale(
                scale: 0.5,
                child: CupertinoSwitch(
                  value: isUnreadOnly,
                  activeColor: rf_primaryColor,
                  onChanged: (bool val) async {
                    await StorageUtil.storeOnlyUnread(val);
                    setState(() {
                      isUnreadOnly = val;
                    });
                    await _refresh();
                  },
                ),
              )
            ],
          ),
        ]);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color:
          appStore.isDarkModeOn ? context.scaffoldBackgroundColor : mainBgColor,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: store.notifications.isEmpty && !store.isLoading
                ? _buildEmpty(context, MediaQuery.of(context).size.width)
                : Column(
                    children: [
                      Expanded(child: _buildListView()),
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
              8.height,
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
    return ListView.builder(
      controller: _scrollController,
      itemCount: store.isLoading
          ? store.notifications.length + 10
          : store.notifications.length,
      shrinkWrap: true,
      itemBuilder: (_, i) {
        if (i < store.notifications.length) {
          NotificationModel notification = store.notifications[i];
          return _buildItem(notification);
        }
        return NotificationSkeleton();
      },
    );
  }

  Widget _buildItem(NotificationModel notification) {
    final iconAndColor = _getIconAndColor(notification);
    final icon = iconAndColor.item1;
    final color = iconAndColor.item2;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: notification.status == NotificationStatuses.unread
            ? rf_primaryColor.withOpacity(0.05)
            : context.cardColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade400, // Change the border color as needed
            width: 1.0, // Change the border width as needed
          ),
        ),
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
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.content,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateTimeUtil.timeAgoString(notification.createdDate),
                  style: secondaryTextStyle(size: 13),
                )
              ],
            ),
          ),
        ],
      ),
    ).onTap(() {
      store.makeNotificationAsRead(notification.id);
      _handleNavigation(notification);
    });
  }

  Tuple2<IconData, Color> _getIconAndColor(NotificationModel notification) {
        NotificationType type =
        NotificationTypeExtension.fromValue(notification.extras["type"]);
    return NotificationTypeExtension.getIconAndColor(type);
  }

  void _handleNavigation(NotificationModel notification) {
    NotificationType type =
        NotificationTypeExtension.fromValue(notification.extras["type"]);

    switch (type) {
      case NotificationType.PAYMENT_SUCCESS_CUSTOMER:
      case NotificationType.CANCEL_BOOKING_CUSTOMER:
      case NotificationType.BOOKING_APPROVED_CUSTOMER:
      case NotificationType.BOOKING_REJECTED_CUSTOMER:
      case NotificationType.REFUND_SUCCESS_CUSTOMER:
        if (notification.extras["orderId"] != null) {
          BookingDetailScreen(
            bookingId: notification.extras["orderId"],
            onBack: () => _refresh(),
          ).launch(context);
        }
        break;
      // Add more cases for other notification types if needed.
    }
  }
}
