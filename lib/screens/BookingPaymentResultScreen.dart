import 'package:customer_app/fragment/BookingFragment.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class BookingPaymentResultScreen extends StatelessWidget {
  final bool isSuccessful;

  BookingPaymentResultScreen({required this.isSuccessful});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: _buildAppbar(context),
          body: _buildBody(context),
        ),
        onWillPop: () async {
          HomeScreen().launch(context);
          return false;
        });
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildStepBar(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage("images/app/ic_shopping.png"),
                  height: 150,
                  width: 150,
                  color: appStore.isDarkModeOn ? Colors.white : Colors.black,
                  fit: BoxFit.cover),
              SizedBox(height: 16),
              Text("Thanh toán thành công",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: boldTextStyle(size: 18)),
              SizedBox(height: 16),
              Text("Cảm ơn bạn đã mua hàng.",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: secondaryTextStyle()),
            ],
          ),
          sSAppButton(
            context: context,
            title: 'Xem đơn hàng',
            onPressed: () {
              BookingFragment().launch(context);
            },
          ),
        ],
      ),
    );
  }

  static const APPBAR_NAME = 'Hoàn thành';

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(APPBAR_NAME, showBack: false, textSize: 18, actions: [
      IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutePaths.HOME.value, (route) => false);
          },
          icon: Icon(Icons.home, size: 20))
    ]);
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
          Icon(Icons.credit_card,
              color: rf_primaryColor.withOpacity(0.5), size: 24),
          _buildActiveDot(),
          _buildActiveDot(),
          _buildActiveDot(),
          _buildActiveDot(),
          Icon(Icons.verified, color: rf_primaryColor, size: 24),
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
        color: appStore.isDarkModeOn ? rf_primaryColor_dark : rf_primaryColor,
        shape: BoxShape.circle,
        border: Border.all(
            color:
                appStore.isDarkModeOn ? rf_primaryColor_dark : rf_primaryColor,
            width: 1),
      ),
    );
  }
}
