import 'package:customer_app/components/CompletedBookingListComponent.dart';
import 'package:customer_app/components/OngoingBookingListComponents.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingFragment extends StatefulWidget {
  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> {
  static final String appbarName = "Đơn hàng";
  static final String onGoingLabel = "Đang diễn ra";
  static final String completedLabel = "Lịch sử";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        appBar: appBarWidget(
          appbarName,
          center: true,
          showBack: false,
          color: context.cardColor,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: context.iconColor),
              onPressed: () {
                //
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: rf_primaryColor,
            labelStyle: boldTextStyle(color: black, size: 18),
            unselectedLabelStyle: secondaryTextStyle(size: 16),
            labelColor: rf_primaryColor,
            unselectedLabelColor: appStore.isDarkModeOn ? white : black,
            isScrollable: false,
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(onGoingLabel),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(completedLabel),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [OngoingBookingListComponents(), CompletedBookingListComponent()],
        ),
      ),
    );
  }
}
