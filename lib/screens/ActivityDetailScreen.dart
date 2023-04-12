import 'package:customer_app/main.dart';
import 'package:customer_app/store/activity_detail/activity_detail_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/utils/number_utils.dart';

class ActivityDetailScreen extends StatefulWidget {
  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  ActivityDetailStore store = ActivityDetailStore();

  int? farmstayId = null;
  int? activityId = null;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initFarmstayDetail(BuildContext context) async {
    final map = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>);
    final int? fId = map['farmstayId'];
    final int? aId = map['activityId'];

    logger.i("FarmstayId $fId , ActivityId: $aId");
    if (fId != null && aId != null) {
      await store.getActivityDetail(farmstayId: fId!, activityId: aId!);
      setState(() {
        farmstayId = fId;
        activityId = aId;
        if (store.activityDetail != null) {
          imageUrls.add(store.activityDetail!.images.avatar!);
          imageUrls.addAll(store.activityDetail!.images.others);
        }
      });
    }
  }

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  bool fev = false;

  @override
  Widget build(BuildContext context) {
    if (farmstayId == null) {
      initFarmstayDetail(context);
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              title: Text(
                  innerBoxIsScrolled ? (store.activityDetail?.name ?? "") : ""),
              backgroundColor: rf_primaryColor,
              expandedHeight: 250.0,
              iconTheme: IconThemeData(color: white),
              automaticallyImplyLeading: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, i) {
                        final link = imageUrls[i];
                        return FadeInImage.assetNetwork(
                          placeholder: default_image,
                          image: link,
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (value) {
                        setState(() => currentIndexPage = value);
                      },
                    ),
                    DotIndicator(
                      pageController: pageController,
                      pages: imageUrls,
                      indicatorColor: white,
                      unselectedIndicatorColor: grey,
                    ).paddingBottom(8),
                  ],
                ),
              ),
              actions: [
                Icon(AntDesign.sharealt, color: white).paddingRight(12),
                Icon(Icons.favorite_border, color: white).paddingRight(12),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text(store.activityDetail?.name ?? "",
                  style: boldTextStyle(size: 22))
                  .paddingOnly(left: 12, bottom: 8),
              8.height,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mô tả'.toUpperCase(),
                      style: boldTextStyle(color: grey)),
                  8.height,
                  Text(store.activityDetail?.description ?? "Chưa có mô tả",
                      style: primaryTextStyle()),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    NumberUtil.formatIntPriceToVnd(store.activityDetail?.price ?? 0),
                    style:
                    secondaryTextStyle(color: rf_primaryColor),
                  ),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20),
        width: context.width(),
        height: 50,
        decoration: boxDecorationWithShadow(
          borderRadius: radius(24),
          gradient:
          LinearGradient(colors: [rf_primaryColor, rf_primaryColor_dark]),
        ),
        child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ).onTap(
            () {
          // EATicketDetailScreen().launch(context);
        },
      ),
    );
  }
}
