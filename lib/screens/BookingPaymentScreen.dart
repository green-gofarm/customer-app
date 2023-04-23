import 'dart:io';

import 'package:customer_app/components/CountDownButton.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/PaymentOption.dart';
import 'package:customer_app/models/booking_model.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/screens/BookingPaymentResultScreen.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/screens/PaymentScreen.dart';
import 'package:customer_app/store/farmstay_detail/farmstay_detail_store.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/order_status.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import '../store/booking/booking_store.dart';

class BookingPaymentScreen extends StatefulWidget {
  final String referenceId;

  BookingPaymentScreen({required this.referenceId});

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  static final List<PaymentOption> payment = [
    PaymentOption(name: "VNPay", image: "images/app/ic_payment.png")
  ];

  final BookingStore store = BookingStore();
  final FarmstayDetailStore farmstayStore = FarmstayDetailStore();

  bool loadingBackFromPayment = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void checkPaymentStatus() async {
    setState(() {
      loadingBackFromPayment = true;
    });

    logger.i("Callback is running");

    final String? id = store.booking?.referenceId;
    if (id != null) {
      await store.getBookingByReferenceId(id);
    }

    if (store.booking != null) {
      if (OrderStatusExtension.fromValue(store.booking!.status) ==
          OrderStatus.PENDING_APPROVE) {
        BookingPaymentResultScreen(
          isSuccessful: true,
        ).launch(context);
      } else if (OrderStatusExtension.fromValue(store.booking!.status) ==
          OrderStatus.FAILED) {
        BookingPaymentResultScreen(isSuccessful: false).launch(context);
      } else {
        toast("Có lỗi xảy ra");
        logger.i("payment status not right: ${store.booking!.status}");
      }
    }

    logger.i("Callback is end");

    setState(() {
      loadingBackFromPayment = false;
    });
  }

  Future<void> _refresh() async {
    await store.getBookingByReferenceId(widget.referenceId);
    if (store.booking != null) {
      farmstayStore.getFarmstayDetail(store.booking!.farmstayId);
    }
  }

  Future<void> init() async {
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Observer(
            builder: (_) => Scaffold(
              appBar: _buildAppbar(context),
              body: _buildBody(),
              bottomSheet: _buildBottom(),
            )),
        onWillPop: () async {
          HomeScreen().launch(context);
          return false;
        });
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return jsAppBar(
      context,
      homeAction: true,
      appBarHeight: 50,
      titleWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Thanh toán", style: boldTextStyle(color: white))],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildStepBar(),
          12.height,
          _buildDetail(),
          12.height,
          _buildPaymentMethod(),
        ],
      ),
    );
  }

  Widget _buildDetail() {
    if (store.booking == null || farmstayStore.farmstayDetail == null) {
      return Container(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 0, top: 12),
        child: Container(
          height: 300,
          color: Color(0xFFf7f7f7),
        ),
      );
    }

    final BookingModel booking = store.booking!;
    final FarmstayDetailModel farmstay = farmstayStore.farmstayDetail!;

    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 0, top: 12),
      child: Container(
        color: Color(0xFFf7f7f7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(farmstay.name,
                    style: boldTextStyle(size: 18),
                    overflow: TextOverflow.ellipsis),
                12.height,
                Row(
                  children: [
                    Icon(Icons.timelapse_rounded, size: 16),
                    8.width,
                    Text("Ngày check-in:", style: primaryTextStyle()),
                    4.width,
                    Text(
                        DateTimeUtil.getFormattedDateInVietnamese(
                            booking.checkInDate!),
                        style: primaryTextStyle()),
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
                        Text(farmstay.address.province!.name!,
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
              ],
            ).paddingAll(12),
            12.height,
            Divider(color: Colors.grey.withOpacity(0.5), height: 1),
            12.height,
            Container(
              padding: EdgeInsets.all(12),
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
                  SizedBox(height: 12),
                  ...booking.feeExtras.map(
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
                      Text('Phải thanh toán', style: primaryTextStyle()),
                      Text(
                          NumberUtil.formatIntPriceToVnd(
                              booking.totalPriceWithFee),
                          style: boldTextStyle()),
                    ],
                  ),
                  8.height,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phương thức thanh toán",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: boldTextStyle()),
          SizedBox(height: 16, width: 16),
          ListView.builder(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            shrinkWrap: true,
            itemCount: payment.length,
            itemBuilder: (_, index) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.iconColor, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.iconColor,
                              width: 1,
                            ),
                          ),
                        ),
                        Text(payment[index].name,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: boldTextStyle(
                              color: context.iconColor,
                            )),
                        Image(
                            image: AssetImage(payment[index].image),
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<String?> getDeviceIpAddress() async {
    String? ipAddress;
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      ipAddress = (await NetworkInterface.list(
        includeLinkLocal: true,
        type: InternetAddressType.IPv4,
      ))
          .expand((interface) => interface.addresses)
          .firstWhere(
            (address) => address.isLoopback == false,
            orElse: () => InternetAddress.loopbackIPv4,
          )
          .address;
    }

    return ipAddress;
  }

  Future<void> _launchURL(String url) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(
                  url: url,
                  onCloseCallback: () {
                    checkPaymentStatus();
                  },
                )),
      );
    } catch (e) {
      toast("Không thể mở giao diện thanh toán");
    }
  }

  Future<void> handlePerformPaymentProcess() async {
    final bookingId = store.booking?.id;
    if (bookingId != null) {
      final ipAddress = await getDeviceIpAddress();
      if (ipAddress == null) {
        toast(IP_ADDRESS_NOT_FOUND);
        _refresh();
        return;
      }

      final url = await store.payBooking(bookingId, ipAddress);
      if (url == null) {
        toast(UNKNOWN_ERROR_MESSAGE);
        _refresh();
        return;
      }

      await _launchURL(url);
    }
  }

  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.all(12),
      height: 150,
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
              if (store.booking?.expiredTime != null)
                CountdownText(
                    expiredTime: store.booking!.expiredTime!,
                    style: boldTextStyle(color: deletedTextColor)),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: Colors.grey, height: 1),
          SizedBox(height: 16),
          sSAppButton(
            context: context,
            title: 'Thanh toán',
            enabled: !store.loading || !loadingBackFromPayment,
            onPressed: () async {
              // SSOrderScreen().launch(context);
              handlePerformPaymentProcess();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepBar() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(Icons.shopping_cart,
              color: rf_primaryColor.withOpacity(0.5), size: 24),
          _buildActiveDot(),
          _buildActiveDot(),
          _buildActiveDot(),
          _buildActiveDot(),
          Icon(Icons.credit_card, color: rf_primaryColor, size: 24),
          _buildInactiveDot(),
          _buildInactiveDot(),
          _buildInactiveDot(),
          _buildInactiveDot(),
          Icon(Icons.verified, color: Color(0xff808080), size: 24),
        ],
      ).paddingAll(12),
    );
  }

  Widget _buildActiveDot() {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: appStore.isDarkModeOn ? context.iconColor : rf_primaryColor,
        shape: BoxShape.circle,
        border: Border.all(
            color: appStore.isDarkModeOn ? context.iconColor : rf_primaryColor,
            width: 1),
      ),
    );
  }

  Widget _buildInactiveDot() {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Color(0x1f000000),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0x4d9e9e9e), width: 1),
      ),
    );
  }
}
