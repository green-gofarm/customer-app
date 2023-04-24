import 'package:customer_app/main.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingModel.dart';
import 'package:customer_app/screens/BookingDetailScreen.dart';
import 'package:customer_app/store/booking/booking_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/booking_status_util.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/order_status.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tuple/tuple.dart';

class BookingFragment extends StatefulWidget {
  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> {
  static const String APPBAR_NAME = "Đơn hàng";

  final BookingStore store = BookingStore();

  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    init();
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
    await store.getCustomerBookings();
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
        // center: true,
        showBack: false,
        // color: rf_primaryColor,
        // textColor: Colors.white,
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
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: store.bookings.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (_, i) {
          CustomerBookingModel booking = store.bookings[i];

          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            decoration: boxDecorationRoundedWithShadow(0,
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
                      DateTimeUtil.getFormattedDateInVietnamese(
                          booking.createdDate),
                      style: primaryTextStyle(size: 12),
                    ),
                    buildStatusContainer(
                        OrderStatusExtension.fromValue(booking.status)),
                  ],
                )
              ],
            ),
          ).onTap(() {
            BookingDetailScreen(
              bookingId: booking.id,
              onBack: () => _refresh(),
            ).launch(context);
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
