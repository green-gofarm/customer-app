import 'package:customer_app/components/CountDownButton.dart';
import 'package:customer_app/models/booking_activity_item.dart';
import 'package:customer_app/models/booking_detail/booking_detail_model.dart';
import 'package:customer_app/models/booking_room_item.dart';
import 'package:customer_app/models/combine_cart_item.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/models/feedback_model.dart';
import 'package:customer_app/models/refund_model.dart';
import 'package:customer_app/screens/BookingFeedbackScreen.dart';
import 'package:customer_app/screens/BookingPaymentScreen.dart';
import 'package:customer_app/screens/HomeScreen.dart';

import 'package:customer_app/store/booking/booking_store.dart';
import 'package:customer_app/store/farmstay_detail/farmstay_detail_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/booking_status_util.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/order_status.dart';
import 'package:customer_app/utils/flutter_rating_bar.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

class BookingDetailArguments {
  final int bookingId;
  final VoidCallback? onBack;

  BookingDetailArguments({required this.bookingId, this.onBack});
}

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;
  final VoidCallback? onBack;

  BookingDetailScreen({required this.bookingId, this.onBack});

  @override
  BookingDetailScreenState createState() => BookingDetailScreenState();
}

class BookingDetailScreenState extends State<BookingDetailScreen> {
  final BookingStore store = BookingStore();
  final FarmstayDetailStore farmstayStore = FarmstayDetailStore();

  List<dynamic> items = [];
  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() => loadingInit = true);
    await _refresh();
    setState(() => loadingInit = false);
  }

  Future<void> _refresh() async {
    await store.getBookingById(widget.bookingId);

    final orderStatus =
        OrderStatusExtension.fromValue(store.bookingDetail!.status);
    if (orderStatus == OrderStatus.PENDING_APPROVE ||
        orderStatus == OrderStatus.APPROVED) {
      await store.getBookingRefundDetail(widget.bookingId);
    }

    if (store.bookingDetail != null) {
      await farmstayStore.getFarmstayDetail(store.bookingDetail!.farmstayId);
    }

    combine();
  }

  void combine() {
    if (store.bookingDetail != null) {
      final Map<int, List<BookingActivityItem>> activityData = {};
      final Map<int, List<BookingRoomItem>> roomData = {};

      // Process activity items
      for (var activity in store.bookingDetail!.activities) {
        int activityId = activity.activityId;
        if (activityData[activityId] == null) {
          activityData[activityId] = [];
        }
        activityData[activityId]!.add(activity);
      }

      // Process room items
      for (var room in store.bookingDetail!.rooms) {
        int roomId = room.roomId;
        if (roomData[roomId] == null) {
          roomData[roomId] = [];
        }
        roomData[roomId]!.add(room);
      }

      setState(() {
        items.clear();
        activityData.forEach((activityId, activityList) {
          items.add({
            "itemId": activityId,
            "count": activityList.length,
            "data": activityList,
            "type": "activity",
          });
        });
        roomData.forEach((roomId, roomList) {
          items.add({
            "itemId": roomId,
            "count": roomList.length,
            "data": roomList,
            "type": "room",
          });
        });
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            HomeScreen(selectedIndex: 3).launch(context);
          }
          return true;
        },
        child: Observer(
            builder: (_) => Scaffold(
                  appBar: _buildAppbar(context),
                  body: _buildBody(),
                  bottomNavigationBar: _buildBottom(),
                )));
  }

  static const String APPBAR_NAME = "Chi tiết đơn hàng";

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      APPBAR_NAME,
      showBack: true,
      textSize: 18,
    );
  }

  Widget _buildBody() {
    return Container(
      color: mainBgColor,
      child: Stack(
        children: [
          Builder(
            builder: (BuildContext context) {
              return RefreshIndicator(
                onRefresh: () async {
                  await _refresh();
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Column(
                        children: [
                          _buildFarmstayInfo(context),
                          SizedBox(height: 8),
                          if (hasFeedback())
                            Column(
                              children: [
                                _buildFeedback(
                                    store.bookingDetail!.feedbacks.first),
                                SizedBox(height: 8),
                              ],
                            ),
                          if (store.bookingDetail != null)
                            Column(
                              children: [
                                _buildTimeline(store.bookingDetail!),
                                // Add the timeline here
                                SizedBox(height: 8),
                              ],
                            ),
                          _buildList(context),
                          SizedBox(height: 8),
                          _buildBodyBottom(),
                          SizedBox(height: 8),
                        ],
                      ),
                    )),
              );
            },
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

  Widget _buildFeedback(FeedbackModel feedback) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Icon(Icons.person_outline, color: white),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: rf_primaryColor),
            padding: EdgeInsets.all(4),
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feedback.customerName ?? "No_name", style: boldTextStyle()),
              Row(
                children: [
                  IgnorePointer(
                    child: RatingBar(
                      onRatingUpdate: (r) {},
                      itemSize: 14.0,
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      initialRating: feedback.rating.toDouble(),
                    ),
                  ),
                  8.width,
                  Text("(${feedback.rating.toString()})",
                      style: secondaryTextStyle()),
                ],
              ),
              Text(feedback.comment, style: secondaryTextStyle()),
            ],
          ).expand(),
        ],
      ),
    );
  }

  Widget _buildFarmstayInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDetail(),
        ],
      ),
    );
  }

  Widget _buildDetail() {
    if (store.bookingDetail == null || farmstayStore.farmstayDetail == null) {
      return Container(
        child: Container(
          color: Colors.white,
          height: 300,
        ),
      );
    }

    final BookingDetailModel booking = store.bookingDetail!;
    final FarmstayDetailModel farmstay = farmstayStore.farmstayDetail!;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Text("Farmstay", style: boldTextStyle()),
              Text(farmstay.name,
                  style: boldTextStyle(size: 18),
                  overflow: TextOverflow.ellipsis),
              12.height,
              Row(
                children: [
                  Icon(
                    Icons.receipt_rounded,
                    size: 16,
                  ),
                  8.width,
                  Row(
                    children: [
                      Text('Mã đơn - OD', style: secondaryTextStyle()),
                      Text(booking.id.toString(), style: secondaryTextStyle()),
                      8.width,
                      if (store.bookingDetail != null)
                        buildStatusContainer(OrderStatusExtension.fromValue(
                            store.bookingDetail!.status)),
                    ],
                  ),
                ],
              ),
              12.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Entypo.location, size: 16),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(farmstay.address.province!.name,
                          style: secondaryTextStyle()),
                      6.height,
                      Text(farmstay.address.toString(),
                          style: secondaryTextStyle()),
                    ],
                  ).expand(),
                ],
              ),
              12.height,
              Row(
                children: [
                  Icon(Icons.local_activity_outlined, size: 20),
                  8.width,
                  if (booking.rooms.length > 0)
                    Text("${booking.rooms.length} ngày"),
                  if (booking.activities.length > 0)
                    Row(
                      children: [
                        if (booking.rooms.length > 0) Text(" - "),
                        Text("${booking.activities.length} vé hoạt động"),
                      ],
                    )
                ],
              ),
              12.height,
              Divider(color: Colors.grey.withOpacity(0.5), height: 1),
              12.height,
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Tổng tiền', style: secondaryTextStyle()),
                        ),
                        Text(
                            '${NumberUtil.formatIntPriceToVnd(booking.totalPrice)}',
                            style: boldTextStyle()),
                      ],
                    ),
                    if (booking.payment != null)
                      Column(
                        children: [
                          SizedBox(height: 12),
                          ...booking.payment!.feeExtras.map(
                            (fee) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(fee.type, style: secondaryTextStyle()),
                                Text(NumberUtil.formatIntPriceToVnd(fee.amount),
                                    style: boldTextStyle()),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Divider(color: Colors.grey, height: 1),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phải thanh toán',
                                  style: primaryTextStyle()),
                              Text(
                                  NumberUtil.formatIntPriceToVnd(
                                      booking.payment!.amount),
                                  style: boldTextStyle()),
                            ],
                          ),
                          8.height,
                        ],
                      )
                  ],
                ),
              )
            ],
          ).paddingAll(12),
        ],
      ),
    );
  }

  int getItemId(CombinedCartItem item) {
    if (item.type == 'activity') {
      return (item.item as BookingActivityItem).activityId;
    } else {
      return (item.item as BookingRoomItem).roomId;
    }
  }

  Widget _buildList(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Text("Tóm tắt đơn hàng", style: boldTextStyle()),
          ),
          Container(
            color: Colors.grey.shade100,
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => Column(
                children: [
                  4.height,
                ],
              ),
              itemBuilder: (_, index) {
                final item = items[index];
                final data = item['data'];

                if (item['type'] == 'activity') {
                  return _buildActivityItem(data, item["count"]);
                } else if (item['type'] == 'room') {
                  return _buildRoomItem(data, item["count"]);
                }

                return SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      List<BookingActivityItem> activityList, int quantity) {
    final item = activityList.first;
    final groupedActivities = groupBy<BookingActivityItem, DateTime>(
      activityList,
      (activity) => activity.date,
    );

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.activity.name,
                              style: boldTextStyle(),
                              softWrap: true,
                            ),
                          ),
                          Text(
                            NumberUtil.formatIntPriceToVnd(
                                item.price * quantity),
                            style: boldTextStyle(size: 14),
                          )
                        ],
                      ),
                      SizedBox(height: 4),
                      Text("x${quantity} vé",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ],
            ),
            8.height,
            Divider(color: Colors.grey.withOpacity(0.5), height: 1),
            8.height,
            // List here
            Column(
              children: groupedActivities.entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateTimeUtil.getFormattedDateInVietnamese(
                                entry.key),
                            style: secondaryTextStyle(),
                          ),
                          if (entry.value.length > 1)
                            Text(
                              " x${entry.value.length}",
                              style: secondaryTextStyle(),
                            ),
                          Text(
                            NumberUtil.formatIntPriceToVnd(
                                entry.value.first.price * entry.value.length),
                            style: secondaryTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomItem(List<BookingRoomItem> roomList, int quantity) {
    final item = roomList.first;
    final groupedRooms = groupBy<BookingRoomItem, DateTime>(
      roomList,
      (activity) => activity.date,
    );

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(4), // Set the desired borderRadius value here
      ),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.room.name,
                              style: boldTextStyle(),
                              softWrap: true,
                            ),
                          ),
                          Text(
                            NumberUtil.formatIntPriceToVnd(
                                item.price * quantity),
                            style: boldTextStyle(size: 14),
                          )
                        ],
                      ),
                      SizedBox(height: 4),
                      Text("x${quantity} ngày & đêm",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ],
            ),
            8.height,
            Divider(color: Colors.grey.withOpacity(0.5), height: 1),
            8.height,
            // List here
            Column(
              children: groupedRooms.entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateTimeUtil.getFormattedDateInVietnamese(
                                entry.key),
                            style: secondaryTextStyle(),
                          ),
                          if (entry.value.length > 1)
                            Text(
                              " x${entry.value.length}",
                              style: secondaryTextStyle(),
                            ),
                          Text(
                            NumberUtil.formatIntPriceToVnd(
                                entry.value.first.price * entry.value.length),
                            style: secondaryTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _generateUniqueKey(String type, int id, DateTime date) {
    return '$type-$id-${date.toIso8601String()}';
  }

  Widget _buildTimeline(BookingDetailModel bookingDetail) {
    List<dynamic> timelineItemsWithDate = [
      {
        "icon": Icons.shopping_cart,
        "title": "Tạo đơn & thanh toán",
        "date": bookingDetail.createdDate
      },
      {
        "icon": Icons.login,
        "title": "Check-in",
        "date": bookingDetail.checkInDate
      },
    ];

    final groupedRooms = groupBy<BookingRoomItem, DateTime>(
      bookingDetail.rooms,
      (room) => room.date,
    );

    final groupedActivities = groupBy<BookingActivityItem, DateTime>(
      bookingDetail.activities,
      (activity) => activity.date,
    );

    Set<String> uniqueKeys = {};

    groupedRooms.forEach((date, rooms) {
      rooms.forEach((room) {
        String key = _generateUniqueKey('room', room.roomId, date);
        if (!uniqueKeys.contains(key)) {
          uniqueKeys.add(key);
          timelineItemsWithDate.add(
              {"icon": Icons.hotel, "title": room.room.name, "date": date});
        }
      });
    });

    groupedActivities.forEach((date, activities) {
      activities.forEach((activity) {
        String key = _generateUniqueKey('activity', activity.activityId, date);
        if (!uniqueKeys.contains(key)) {
          uniqueKeys.add(key);
          timelineItemsWithDate.add({
            "icon": Icons.local_activity,
            "title": activity.activity.name,
            "date": date
          });
        }
      });
    });

    if (bookingDetail.checkoutDate != null) {
      timelineItemsWithDate.add({
        "icon": Icons.login,
        "title": "Check-out",
        "date": bookingDetail.checkoutDate
      });
    }

    // Sort the items by date
    timelineItemsWithDate.sort((a, b) => a["date"].compareTo(b["date"]));

    final Map<DateTime, List<dynamic>> groupedResult = {};

    timelineItemsWithDate.forEach((item) {
      if (groupedResult[item["date"]] == null) {
        groupedResult[item["date"]] = [];
      }
      groupedResult[item["date"]]!.add(item);
    });

    // Create the final list of widgets using _buildTimelineItem
    List<Widget> timelineItems = [];
    groupedResult.forEach((date, items) {
      timelineItems.add(_buildTimelineItem(date: date, items: items));
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lịch trình", style: boldTextStyle()),
          16.height,
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: timelineItems,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      {required DateTime date, required List<dynamic> items}) {
    return Container(
      key: ValueKey<DateTime>(date),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          left: BorderSide(width: 4, color: rf_primaryColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTimeUtil.getFormattedDateInVietnamese(date),
            style: boldTextStyle(size: 16, color: rf_primaryColor),
          ),
          for (final item in items)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item['icon']!,
                    color: rf_primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['title']!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    if (store.bookingDetail == null) {
      return SizedBox(
        height: 0,
      );
    }

    final orderStatus =
        OrderStatusExtension.fromValue(store.bookingDetail!.status);

    if (orderStatus == OrderStatus.PENDING_PAYMENT) {
      return _buildPendingPayment(store.bookingDetail!);
    }

    if (feedbackable(store.bookingDetail!.feedbackDate, orderStatus)) {
      if (!hasFeedback()) {
        return _buildComplete(store.bookingDetail!);
      }
    }

    return SizedBox(
      height: 0,
    );
  }

  bool hasFeedback() {
    if (store.bookingDetail == null) return false;
    return store.bookingDetail!.feedbacks.length > 0;
  }

  bool feedbackable(DateTime feedbackDate, OrderStatus status) {
    DateTime currentDate = DateTime.now();

    bool validStatus =
        status == OrderStatus.APPROVED || status == OrderStatus.DISBURSE;

    int daysDifference = currentDate.difference(feedbackDate).inDays;
    bool isSameOrAfterFeedbackDate = daysDifference >= 0;

    return validStatus && isSameOrAfterFeedbackDate;
  }

  Widget _buildPendingPayment(BookingDetailModel booking) {
    return Container(
      padding: EdgeInsets.all(12),
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              12.width,
              Text(
                "Thời hạn thanh toán:",
                style: primaryTextStyle(color: deletedTextColor),
              ),
              4.width,
              CountdownText(
                  expiredTime: booking.expiredTime,
                  style: boldTextStyle(color: deletedTextColor)),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: Colors.grey, height: 1),
          SizedBox(height: 16),
          sSAppButton(
              context: context,
              title: 'Đến trang thanh toán',
              onPressed: () {
                BookingPaymentScreen(
                  referenceId: booking.referenceId,
                ).launch(context);
              }),
        ],
      ),
    );
  }

  Widget _buildBodyBottom() {
    if (store.bookingDetail == null) {
      return SizedBox(height: 0);
    }

    final orderStatus =
        OrderStatusExtension.fromValue(store.bookingDetail!.status);
    if (orderStatus == OrderStatus.PENDING_APPROVE ||
        orderStatus == OrderStatus.APPROVED) {
      if (store.refundDetail != null && store.refundDetail!.cancelAvailable) {
        return _buildPendingApprove(store.bookingDetail!, store.refundDetail!);
      }
    }

    return SizedBox(height: 0);
  }

  Widget _buildPendingApprove(
      BookingDetailModel booking, RefundDetail refundDetail) {
    final cancelAction = CustomTheme(
      child: CupertinoActionSheet(
        title: Text(
          'Hủy đơn hàng',
          style: boldTextStyle(size: 18),
        ),
        message: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Đã thanh toán', style: secondaryTextStyle()),
                  Text(
                      '${NumberUtil.formatIntPriceToVnd(booking.payment!.amount)}',
                      style: primaryTextStyle()),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phí hủy', style: secondaryTextStyle()),
                  Text('${NumberUtil.formatIntPriceToVnd(refundDetail.fee!)}',
                      style: boldTextStyle()),
                ],
              ),
              SizedBox(height: 12),
              Divider(color: Colors.grey, height: 1),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thực nhận', style: primaryTextStyle()),
                  Text(
                      NumberUtil.formatIntPriceToVnd(
                          refundDetail.refundAmount!),
                      style: primaryTextStyle()),
                ],
              ),
            ],
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: () async {
                final result = await store.cancelBooking(booking.id);
                if (result) {
                  toast("Hủy đơn thành công");
                  _refresh();
                  finish(context);
                }
              },
              child: store.loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(rf_primaryColor),
                        strokeWidth: 2,
                      ),
                    )
                  : Text('OK', style: primaryTextStyle(size: 18)))
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              finish(context);
            },
            child: Text(
              'Suy nghĩ lại',
              style: primaryTextStyle(color: redColor, size: 18),
            )),
      ),
    );

    return Container(
      padding: EdgeInsets.all(12),
      height: 90,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          sSAppButton(
              context: context,
              color: Colors.redAccent,
              title: 'Hủy đơn',
              onPressed: () {
                showCupertinoModalPopup(
                    context: context, builder: (_) => cancelAction);
              }),
        ],
      ),
    );
  }

  Widget _buildComplete(BookingDetailModel booking) {
    return Container(
      padding: EdgeInsets.all(12),
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          sSAppButton(
              context: context,
              title: 'Đánh giá chuyến đi',
              onPressed: () {
                BookingFeedbackScreen(
                  onCreate: (
                      {required double rating, required String comment}) async {
                    final result = await store.createFeedback(booking.id,
                        rating: rating, comment: comment);
                    if (result) {
                      toast('Cảm ơn bạn đã đánh giá!');
                      _refresh();
                    }
                  },
                ).launch(context);
              }),
        ],
      ),
    );
  }

  Widget buildStatusContainer(OrderStatus status) {
    final Tuple2<Color, String> statusInfo =
        getBookingStatusColorAndLabel(status);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: statusInfo.item1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusInfo.item2,
        style: boldTextStyle(color: statusInfo.item1, size: 11),
      ),
    );
  }
}
