import 'package:customer_app/fragment/CustomerSearchDelegate.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/screens/HomeSearchResultScreen.dart';
import 'package:customer_app/screens/HomeTopScreen.dart';
import 'package:customer_app/screens/SelectCityScreen.dart';

import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeFragment extends StatefulWidget {
  final String? name;

  HomeFragment({this.name});

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  final _kTabs = <Tab>[
    Tab(text: 'GỢI Ý CHO BẠN'),
    Tab(text: 'TOP'),
  ];

  final _kTabPages = <Widget>[
    HomeSearchResultScreen(),
    HomeTopScreen(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  width: context.width(),
                  child: Material(
                    color: context.cardColor,
                    child: TabBar(
                      tabs: _kTabs,
                      indicatorColor: rf_primaryColor,
                      labelColor: rf_primaryColor,
                      unselectedLabelColor: grey,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: _kTabPages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget("",
        center: false,
        showBack: false,
        color: rf_primaryColor,
        textColor: Colors.white,
        textSize: 14,
        titleWidget: _buildSearchBar(),
        actions: [
          _buildSuggest(),
          _buildNotification(),
        ]);
  }

  Widget _buildSearchBar() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: TextFormField(
              enabled: false,
              style: primaryTextStyle(size: 14),
              onFieldSubmitted: (val) {},
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: 'Khám phá trải nghiệm mới',
                hintStyle: secondaryTextStyle(),
                fillColor:
                    appStore.isDarkModeOn ? cardDarkColor : editTextBgColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: radius(4),
                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: radius(4),
                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.search,
                      size: 20,
                      color: appStore.isDarkModeOn
                          ? white
                          : gray.withOpacity(0.5)),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ]).onTap(() {
      showSearch(context: context, delegate: CustomerSearchDelegate());
    });
  }

  Widget _buildSuggest() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    ).onTap(
      () {
        SelectCityScreen().launch(context,
            pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
      },
    );
  }

  Widget _buildNotification() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    ).onTap(
      () {
        // HomeFilterScreen().launch(context,
        //     pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
      },
    );
  }
}
