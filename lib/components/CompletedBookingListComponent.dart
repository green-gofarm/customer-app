import 'package:customer_app/main.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingModel.dart';
import 'package:customer_app/screens/BookingPaymentScreen.dart';
import 'package:customer_app/store/booking/booking_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/booking_status_util.dart';
import 'package:customer_app/utils/enum/order_status.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tuple/tuple.dart';

class CompletedBookingListComponent extends StatefulWidget {
  @override
  CompletedBookingListComponentState createState() =>
      CompletedBookingListComponentState();
}

class CompletedBookingListComponentState
    extends State<CompletedBookingListComponent> {
  final BookingStore store = BookingStore();

  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() =>loadingInit = true);
    await _refresh();
    setState(() =>loadingInit = false);
  }

  Future<void> _refresh() async {
    await store.getCustomerBookings();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Observer(
        builder: (_) => Container(
          color: appStore.isDarkModeOn
              ? context.scaffoldBackgroundColor
              : mainBgColor,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _refresh,
                child: _buildListView(),
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
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: store.bookings.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemBuilder: (_, i) {
          CustomerBookingModel booking = store.bookings[i];

          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(16),
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(booking.farmstayName,
                        style: boldTextStyle(),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.receipt_rounded),
                    4.width,
                    Row(
                      children: [
                        Text('Mã đơn - OD', style: secondaryTextStyle()),
                        Text(booking.id.toString(),
                            style: secondaryTextStyle()),
                      ],
                    ),
                  ],
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_money),
                    4.width,
                    Text(
                        '${NumberUtil.formatIntPriceToVnd(booking.totalPrice)}',
                        style: secondaryTextStyle()),
                  ],
                ),
                4.height,
                Divider(),
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMMd("vi_VN").format(booking.createdDate),
                      style: primaryTextStyle(size: 12),
                    ),
                    buildStatusContainer(
                        OrderStatusExtension.fromValue(booking.status)),
                  ],
                )
              ],
            ),
          ).onTap(() {
            // LSOrderDetailScreen(data).launch(context);
            if(OrderStatusExtension.fromValue(booking.status) == OrderStatus.PENDING_PAYMENT) {
              BookingPaymentScreen(referenceId: booking.referenceId).launch(context);
            }
          });
        });
  }

  Widget buildStatusContainer(OrderStatus status) {
    final Tuple2<Color, String> statusInfo =
        getBookingStatusColorAndLabel(status);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: statusInfo.item1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusInfo.item2,
        style: boldTextStyle(color: statusInfo.item1, size: 12),
      ),
    );
  }
}
