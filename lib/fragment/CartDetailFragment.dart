import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_ticket_model.dart';
import 'package:customer_app/models/combine_cart_item.dart';
import 'package:customer_app/screens/ActivityDetailScreen.dart';
import 'package:customer_app/screens/BookingPaymentScreen.dart';
import 'package:customer_app/store/booking/booking_store.dart';
import 'package:customer_app/store/cart/cart_store.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/room_ticket_model.dart';

class CartDetailFragment extends StatefulWidget {
  final int farmstayId;
  final VoidCallback onBack;

  CartDetailFragment({required this.farmstayId, required this.onBack});

  @override
  CartDetailFragmentState createState() => CartDetailFragmentState();
}

class CartDetailFragmentState extends State<CartDetailFragment> {
  final BookingStore bookingStore = BookingStore();
  final CartStore store = CartStore();
  final GlobalKey bottomSheetKey = GlobalKey();

  List<CombinedCartItem> combinedList = [];

  bool loadingCreate = false;
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
    await store.getCustomerCartInFarmstay(widget.farmstayId);
    combine();
    if (!store.hasAvailableCart()) {
      toast("Giỏ hàng đã bị xóa hoặc không tồn tại");
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
      return;
    }
  }

  void combine() {
    if (store.cart != null) {
      combinedList.clear();
      combinedList.addAll(store.cart!.activities
          .map((activity) => CombinedCartItem(type: 'activity', item: activity))
          .toList());
      combinedList.addAll(store.cart!.rooms
          .map((room) => CombinedCartItem(type: 'room', item: room))
          .toList());
    }
  }

  void removeItem(int id) async {
    bool result = await store.removeItem(widget.farmstayId, id);
    if (!result) {
      toast("Xóa $id thất bại");
      return;
    }

    toast("Xóa thành công");
    await _refresh();

    if (!store.hasAvailableCart()) {
      Navigator.pop(context);
      return;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getBookingByRef(String id) async {
    await bookingStore.getBookingByReferenceId(id);
  }

  void processCreateBooking() async {
    setState(() {
      loadingCreate = true;
    });

    try {
      await bookingStore.createBooking(widget.farmstayId);
      if (bookingStore.referenceId == null) {
        showCreateBookingFailed();
        return;
      }

      bool isFirstLoop = true;
      final loopSecond = 3;

      do {
        if (!isFirstLoop) {
          await Future.delayed(Duration(seconds: loopSecond));
        }
        isFirstLoop = false;
        await getBookingByRef(bookingStore.referenceId!);
      } while (bookingStore.message == IS_CREATING_BOOKING);

      if (bookingStore.booking != null) {
        await store.clearCart(widget.farmstayId);
        BookingPaymentScreen(referenceId: bookingStore.referenceId!)
            .launch(context);
        return;
      }

      if (bookingStore.message == CREATE_BOOKING_FAILED) {
        showCreateBookingFailed();
        return;
      }

      toast(UNKNOWN_ERROR_MESSAGE);
    } finally {
      setState(() {
        loadingCreate = false;
      });
    }
  }

  void showCreateBookingFailed() {
    toast(CREATE_BOOKING_FAILED);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          widget.onBack();
          return true;
        },
        child: Observer(
            builder: (_) => Scaffold(
                  appBar: _buildAppbar(context),
                  body: _buildBody(),
                  bottomSheet: _buildBottomSheet(context),
                )));
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return jsAppBar(context,
        appBarHeight: 50,
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Giỏ hàng", style: boldTextStyle(color: white))],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final isConfirmed = await _showDialog(context);
                if(isConfirmed) {
                  await store.clearCart(widget.farmstayId);
                  await _refresh();
                  widget.onBack();
                }
              },
              icon: Icon(LineIcons.trash, size: 20),
              color: Colors.white)
        ]);
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            _getBottomSheetHeight()),
                    child: Column(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.all(8),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: combinedList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 8);
                          },
                          itemBuilder: (_, index) {
                            final combinedItem = combinedList[index];

                            if (combinedItem.type == 'activity') {
                              return _buildActivityItem(combinedItem.item);
                            } else if (combinedItem.type == 'room') {
                              return _buildRoomItem(combinedItem.item);
                            }

                            return SizedBox.shrink();
                          },
                        ),
                        140.height
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (loadingCreate || loadingInit)
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

  Widget _buildActivityItem(ActivityTicketModel activity) {
    return Container(
      padding: EdgeInsets.all(12),
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
                Container(
                  padding: EdgeInsets.all(4),
                  width: 80,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: rfCommonCachedNetworkImage(
                    activity.images.avatar,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(8),
                ),
                SizedBox(height: 16, width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(activity.name ?? "No_name",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle()),
                          Icon(Icons.clear).onTap(() {
                            removeItem(activity.id);
                          })
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(DateFormat.yMMMMd().format(activity.date),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle()),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            NumberUtil.formatIntPriceToVnd(activity.price),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: boldTextStyle(size: 14),
                          ),
                          SizedBox(width: 32),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            4.height,
            Divider(),
            4.height,
            Text(
              "Xem chi tiết",
              style: primaryTextStyle(color: rf_primaryColor),
            ).onTap(() {
              ActivityDetailScreen(
                farmstayId: widget.farmstayId,
                activityId: activity.itemId,
              ).launch(context,
                  pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
            })
          ],
        ),
      ),
    );
  }

  Widget _buildRoomItem(RoomTicketModel room) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          //Todo: navigate to room detail
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12, width: 1),
              ),
              child: rfCommonCachedNetworkImage(
                room.images.avatar,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(8),
            ),
            SizedBox(height: 16, width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(room.name ?? "No_name",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: boldTextStyle()),
                      Icon(Icons.clear).onTap(() {
                        removeItem(room.id);
                      })
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(DateFormat.yMMMMd().format(room.date),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryTextStyle()),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberUtil.formatIntPriceToVnd(room.price),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: boldTextStyle(size: 14),
                      ),
                      SizedBox(width: 32),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getBottomSheetHeight() {
    final RenderBox? renderBox =
        bottomSheetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 56; // Default height if renderBox is null
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      key: bottomSheetKey,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      height: 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //color: context.cardColor,
        boxShadow: defaultBoxShadow(shadowColor: Colors.grey.withOpacity(0.1)),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("x${store.getTotalItem()}", style: boldTextStyle()),
                Text('Tổng: ${store.getTotalPriceVndString()}',
                    style: boldTextStyle()),
              ],
            ),
            SizedBox(height: 16),
            sSAppButton(
              context: context,
              onPressed: () {
                processCreateBooking();
              },
              enabled: !(loadingCreate || store.loading),
              child: loadingCreate || store.loading
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 4,
                      ),
                    )
                  : null,
              title: "Đặt đơn",
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDialog(BuildContext parentContext) async {
    bool result = false;

    await showDialog<bool>(
      context: parentContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentTextStyle: secondaryTextStyle(),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          title: Text("Xóa giỏ hàng", style: boldTextStyle()),
          content: Text("Bán có chắc muốn xóa giỏ hàng?",
              style: secondaryTextStyle()),
          actions: <Widget>[
            TextButton(
              child: Text("Quay lại",
                  style: TextStyle(color: Colors.blue, fontSize: 14)),
              onPressed: () {
                Navigator.pop(context, false); // Return false when canceled
              },
            ),
            TextButton(
              child: Text("Xác nhận",
                  style: TextStyle(color: Colors.blue, fontSize: 14)),
              onPressed: () {
                Navigator.pop(context, true); // Return false when canceled
              },
            ),
          ],
        );
      },
    ).then((value) => result = value is bool ? value : false);

    return result;
  }
}
