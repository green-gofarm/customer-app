import 'dart:collection';

import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_ticket_model.dart';
import 'package:customer_app/models/combine_cart_item.dart';
import 'package:customer_app/screens/ActivityDetailScreen.dart';
import 'package:customer_app/screens/BookingPaymentScreen.dart';
import 'package:customer_app/screens/FarmstayDetailScreen.dart';
import 'package:customer_app/screens/RoomDetailScreen.dart';
import 'package:customer_app/store/booking/booking_store.dart';
import 'package:customer_app/store/cart/cart_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
      widget.onBack();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
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

  static const String APPBAR_NAME = "Chi tiết giỏ hàng";

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(APPBAR_NAME,
        showBack: true,
        textSize: 18,
        actions: [
          IconButton(
              onPressed: () async {
                final isConfirmed = await _showDialog(context);
                if (isConfirmed) {
                  await store.clearCart(widget.farmstayId);
                  await _refresh();
                  widget.onBack();
                }
              },
              icon: Icon(LineIcons.trash, size: 20))
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
                        _buildFarmstayInfo(context),
                        _buildList(context),
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

  Widget _buildFarmstayInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Điểm đến", style: boldTextStyle()),
          12.height,
          if (store.cart?.farmstayImages.avatar != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 16,
                          ),
                          8.width,
                          Text(
                            store.cart?.farmstayName ?? "",
                            style: boldTextStyle(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: 16,
                          ),
                          8.width,
                          Text("${store.cart?.totalCartItem ?? 0} sản phẩm.")
                        ],
                      )
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: appStore.iconColor)
              ],
            ).onTap(() {
              if (store.cart?.farmstayId != null) {
                FarmstayDetailScreen(
                  farmstayId: store.cart!.farmstayId,
                  onBack: () => _refresh(),
                ).launch(context);
              }
            }),
          12.height,
          Divider(color: Colors.grey.withOpacity(0.5), height: 1),
          12.height,
          Text("Tóm tắt giỏ hàng", style: boldTextStyle()),
        ],
      ),
    );
  }

  int getItemId(CombinedCartItem item) {
    if (item.type == 'activity') {
      return (item.item as ActivityTicketModel).itemId;
    } else {
      return (item.item as RoomTicketModel).itemId;
    }
  }

  Widget _buildList(BuildContext context) {
    final Map<int, dynamic> data = {};
    LinkedHashMap<int, int> itemCountMap = LinkedHashMap<int, int>();

    combinedList.forEach((item) {
      int itemId = getItemId(item);
      itemCountMap.update(itemId, (count) => count + 1, ifAbsent: () => 1);
      if (data[itemId] == null) {
        data[itemId] = item;
      }
    });

    List<dynamic> itemList = [];

    itemCountMap.forEach((itemId, count) {
      itemList.add({
        "itemId": itemId,
        "count": count,
        "data": data[itemId],
      });
    });

    return ListView.separated(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemList.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 8);
      },
      itemBuilder: (_, index) {
        final item = itemList[index];
        final data = item['data'];

        // Assuming the CartItemType enum has string values like 'activity' and 'room'
        if (data.type == 'activity') {
          return _buildActivityItem(data.item, item["count"]);
        } else if (data.type == 'room') {
          return _buildRoomItem(data.item, item["count"]);
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget _buildActivityItem(ActivityTicketModel activity, int quantity) {
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
                  height: 60,
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
                          Text(
                            NumberUtil.formatIntPriceToVnd(
                                activity.price * quantity),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: boldTextStyle(size: 14),
                          )
                        ],
                      ),
                      SizedBox(height: 4),
                      Text("x${quantity} vé",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle()),
                      SizedBox(height: 4),
                      Text("Chỉnh sửa",
                              style: boldTextStyle(
                                  color: rf_primaryColor, size: 12))
                          .onTap(() {
                        ActivityDetailScreen(
                          farmstayId: store.cart!.farmstayId,
                          activityId: activity.itemId,
                          onBack: () => _refresh(),
                        ).launch(context);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomItem(RoomTicketModel room, int quantity) {
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
                  height: 60,
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
                          Text(
                            NumberUtil.formatIntPriceToVnd(
                                room.price * quantity),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: boldTextStyle(size: 14),
                          )
                        ],
                      ),
                      SizedBox(height: 4),
                      Text("x${quantity} ngày & đêm",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle()),
                      SizedBox(height: 4),
                      Text("Chỉnh sửa",
                              style: boldTextStyle(
                                  color: rf_primaryColor, size: 12))
                          .onTap(() {
                        RoomDetailScreen(
                          farmstayId: store.cart!.farmstayId,
                          roomId: room.itemId,
                          onBack: () => _refresh(),
                        ).launch(context);
                      }),
                    ],
                  ),
                ),
              ],
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

  static const String ACTION_TITLE = 'Xóa giỏ hàng';
  static const String ACTION_MESSAGE = "Bán có chắc muốn xóa giỏ hàng?";
  static const String ACTION_CANCEL = 'Suy nghĩ lại';
  static const String ACTION_OK = 'OK';

  Future<bool> _showDialog(BuildContext parentContext) async {
    bool result = false;

    final removeAction = CustomTheme(
      child: CupertinoActionSheet(
        title: Text(
          ACTION_TITLE,
          style: boldTextStyle(size: 18),
        ),
        message: Text(
          ACTION_MESSAGE,
          style: secondaryTextStyle(),
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, true); // Return false when canceled
              },
              child: Text(ACTION_OK, style: primaryTextStyle(size: 18)))
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, false); // Return false when canceled
            },
            child: Text(
              ACTION_CANCEL,
              style: primaryTextStyle(color: redColor, size: 18),
            )),
      ),
    );

    await showCupertinoModalPopup<bool>(
            context: context, builder: (_) => removeAction)
        .then((value) => result = value is bool ? value : false);

    return result;
  }
}
