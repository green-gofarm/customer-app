import 'package:customer_app/components/CommonAppComponent.dart';
import 'package:customer_app/components/FarmstayListComponent.dart';
import 'package:customer_app/components/SkeletonFarmstayListComponent.dart';
import 'package:customer_app/models/PaginationModel.dart';
import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/store/farmstay_paging/farmstays_paging_store.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/components/RFLocationComponent.dart';
import 'package:customer_app/components/RFRecentUpdateComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/RoomFinderModel.dart';
import 'package:customer_app/screens/RFLocationViewAllScreen.dart';
import 'package:customer_app/screens/RFRecentupdateViewAllScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFDataGenerator.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  FarmstayPagingStore store = FarmstayPagingStore();

  List<FarmstayModel> listFarmstay = [];

  List<RoomFinderModel> hotelListData = hotelList();
  List<RoomFinderModel> locationListData = locationList();

  int selectCategoryIndex = 0;
  bool locationWidth = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await store.refresh();
    setState(() {
      listFarmstay = List.of(store.farmstays);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: rf_primaryColor,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
              child: TextFormField(
                style: primaryTextStyle(size: 14),
                onFieldSubmitted: (val) {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Bạn muốn đi đâu',
                  hintStyle: secondaryTextStyle(),
                  fillColor:
                      appStore.isDarkModeOn ? cardDarkColor : editTextBgColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: radius(4),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: radius(4),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search,
                        size: 20,
                        color: appStore.isDarkModeOn
                            ? white
                            : gray.withOpacity(0.5)),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_pin,
                        size: 20,
                        color: appStore.isDarkModeOn
                            ? white
                            : gray.withOpacity(0.5)),
                    onPressed: () {},
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded,
                    size: 24, color: Colors.white),
                onPressed: () {
                  //TODO: Navigate to notification
                },
              ),
            ],
          ),
        ],
      ),
      body: CommonAppComponent(
        subWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Farmstays', style: boldTextStyle()),
                TextButton(
                  onPressed: () async {
                    store.pagination.pageSize = store.pagination.totalItem ??
                        PaginationModel.DEFAULT_PAGE_SIZE;
                    logger.i("Totle item: ${store.pagination.totalItem}");
                    await store.refresh();
                    setState(() {
                      listFarmstay = List.of(store.farmstays);
                    });
                  },
                  child: Text('Xem tất cả',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline,
                          textBaseline: TextBaseline.alphabetic)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: store.isLoading
                  ? List.generate(6, (index) {
                      return SkeletonFarmstayListComponent();
                    })
                  : List.generate(listFarmstay.length, (index) {
                      return FarmstayListComponent(
                          farmstay: listFarmstay[index]);
                    }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hoạt động', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFLocationViewAllScreen(locationWidth: true)
                        .launch(context);
                  },
                  child: Text('Xem tất cả',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(locationListData.length, (index) {
                return RFLocationComponent(
                    locationData: locationListData[index]);
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phòng nghỉ', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFRecentUpdateViewAllScreen().launch(context);
                  },
                  child: Text('Xem tất cả',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: hotelListData.take(3).length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = hotelListData[index];
                return RFRecentUpdateComponent(recentUpdateData: data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
