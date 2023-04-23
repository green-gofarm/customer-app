import 'package:customer_app/components/ActivityListComponent.dart';
import 'package:customer_app/components/FarmstayListComponent.dart';
import 'package:customer_app/components/RoomListComponent.dart';
import 'package:customer_app/components/SkeletonFarmstayListComponent.dart';
import 'package:customer_app/store/farmstay/farmstay_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeTopScreen extends StatefulWidget {
  @override
  HomeTopScreenState createState() => HomeTopScreenState();
}

class HomeTopScreenState extends State<HomeTopScreen> {
  FarmstayStore store = FarmstayStore();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    await store.getTopRatedFarmstay();
    await store.getTopBookedActivities();
    await store.getTopBookedRooms();
    await Future.delayed(Duration(seconds: 2));
    setState(() => loading = false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        color: mainBgColor,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _buildRefreshIndicator(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RefreshIndicator _buildRefreshIndicator(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            8.height,
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Top farmstay được đánh giá tốt", style: boldTextStyle())
                      .paddingOnly(top: 12, left: 16),
                  _buildListFarmstays(context),
                ],
              ),
            ),
            8.height,
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Top hoạt động", style: boldTextStyle())
                      .paddingOnly(top: 12, left: 16),
                  _buildListActivities(context),
                ],
              ),
            ),
            8.height,
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Top phòng ở", style: boldTextStyle())
                      .paddingOnly(top: 12, left: 16),
                  _buildListRooms(context),
                ],
              ),
            ),
            8.height,
          ],
        ),
      ),
    );
  }

  Widget _buildListFarmstays(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (loading && store.topRatedFarmstays.length < 1)
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 12),
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, i) => SkeletonFarmstayListComponent()),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: store.topRatedFarmstays.length,
            itemBuilder: (context, i) {
              return FarmstayListComponent(
                  farmstay: store.topRatedFarmstays[i]);
            },
          )
        ],
      ),
    );
  }

  Widget _buildListActivities(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (loading && store.topBookedActivities.length < 1)
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 12),
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, i) => SkeletonFarmstayListComponent()),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: store.topBookedActivities.length,
            itemBuilder: (context, i) {
              return ActivityListComponent(
                  activity: store.topBookedActivities[i]);
            },
          )
        ],
      ),
    );
  }

  Widget _buildListRooms(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (loading && store.topBookedRooms.length < 1)
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 12),
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, i) => SkeletonFarmstayListComponent()),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: store.topBookedRooms.length,
            itemBuilder: (context, i) {
              return RoomListComponent(room: store.topBookedRooms[i]);
            },
          )
        ],
      ),
    );
  }
}
