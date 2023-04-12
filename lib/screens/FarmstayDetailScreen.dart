import 'package:customer_app/components/FarmstayScheduleComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/store/cart/cart_store.dart';
import 'package:customer_app/store/farmstay_detail/farmstay_detail_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/utils/event/EAImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/utils/number_utils.dart';

class FarmstayDetailScreen extends StatefulWidget {
  @override
  _FarmstayDetailScreenState createState() => _FarmstayDetailScreenState();
}

class _FarmstayDetailScreenState extends State<FarmstayDetailScreen> {
  FarmstayDetailStore farmstayStore = FarmstayDetailStore();
  CartStore cartStore = CartStore();

  List<String> imageUrls = [];
  List<ActivityModel> activities = [];

  @override
  void initState() {
    super.initState();
  }

  void prepareShowDetail(FarmstayDetailModel farmstay) {
    imageUrls.add(farmstay.images.avatar!);
    imageUrls.addAll(farmstay.images.others);
    activities.addAll(farmstay.activities);
  }

  Future<void> initFarmstayDetail(BuildContext context) async {
    final int? id = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['farmstayId'];

    if (id != null) {
      await farmstayStore.getFarmstayDetail(id);
      setState(() {
        if (farmstayStore.farmstayDetail != null) {
          prepareShowDetail(farmstayStore.farmstayDetail!);
          initFarmstayCart(farmstayStore.farmstayDetail!.id);
        }
      });
    }
  }

  Future<void> initFarmstayCart(int farmstayId) async {
    if (authStore.isAuthenticated()) {
      await cartStore.getCustomerCartInFarmstay(farmstayId);
    }
  }


  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    if (farmstayStore.farmstayDetail == null) {
      initFarmstayDetail(context);
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              title: Text(innerBoxIsScrolled
                  ? (farmstayStore.farmstayDetail?.name ?? "")
                  : ""),
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
              Text(farmstayStore.farmstayDetail?.name ?? "",
                      style: boldTextStyle(size: 22))
                  .paddingOnly(left: 12, bottom: 8),
              8.height,
              Container(
                color: grey.withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBarWidget(
                              onRatingChanged: (rating) {},
                              rating:
                                  farmstayStore.farmstayDetail?.rating ?? 0.0,
                              allowHalfRating: true,
                              itemCount: 5,
                              disable: true,
                              size: 16,
                              activeColor: Colors.yellow,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border_outlined,
                            ),
                            4.width,
                            Text(
                                '(${farmstayStore.farmstayDetail?.rating.toInt() ?? 0})',
                                style: secondaryTextStyle(size: 16)),
                          ],
                        ),
                      ],
                    ).expand(),
                  ],
                ),
              ),
              16.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mô tả'.toUpperCase(),
                      style: boldTextStyle(color: grey)),
                  8.height,
                  Text(
                      farmstayStore.farmstayDetail?.description ??
                          "Chưa có mô tả",
                      style: primaryTextStyle()),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vị trí'.toUpperCase(),
                      style: boldTextStyle(color: grey)),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      farmstayStore.farmstayDetail?.address.province?.name ??
                          "",
                      style: boldTextStyle()),
                  8.height,
                  Text(farmstayStore.farmstayDetail?.address.toString() ?? "",
                      style: secondaryTextStyle()),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
              rfCommonCachedNetworkImage(event_ic_map,
                  fit: BoxFit.cover, height: 200, width: context.width()),
              Text(
                'Liên hệ'.toUpperCase(),
                style: boldTextStyle(color: grey),
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              Column(
                children: farmstayStore.farmstayDetail?.contactInformation
                        .map((contact) => Row(
                              children: [
                                Text("${contact.method}:",
                                    style: boldTextStyle()),
                                8.width,
                                Text("${contact.value}",
                                    style: secondaryTextStyle()),
                              ],
                            ))
                        .toList() ??
                    [],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
              Text(
                'Lịch hoạt động'.toUpperCase(),
                style: boldTextStyle(color: grey),
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              if(farmstayStore.farmstayDetail!= null)
                FarmstayScheduleComponent(farmstay: farmstayStore.farmstayDetail!),
              Text(
                'Hoạt động'.toUpperCase(),
                style: boldTextStyle(color: grey),
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              HorizontalList(
                padding:
                    EdgeInsets.only(left: 12, bottom: 8, top: 8, right: 12),
                itemCount: activities.length,
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          rfCommonCachedNetworkImage(
                            activities[i].images.avatar!,
                            height: 180,
                            width: context.width() * 0.7,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(8),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          Text(activities[i].name!, style: boldTextStyle()),
                          6.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Entypo.book, size: 16),
                                  8.width,
                                  Text(
                                      "Lượt đặt: ${activities[i].bookingCount} lần",
                                      style: secondaryTextStyle()),
                                ],
                              ),
                            ],
                          ),
                          6.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.money, size: 16),
                              8.width,
                              Text(
                                NumberUtil.formatIntPriceToVnd(
                                    activities[i].price),
                                style:
                                    secondaryTextStyle(color: rf_primaryColor),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ).paddingRight(8).onTap(() {
                    Navigator.pushNamed(
                        context, RoutePaths.ACTIVITY_DETAIL.value, arguments: {
                      "farmstayId": farmstayStore.farmstayDetail?.id,
                      "activityId": activities[i].id
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) => cartStore.cart != null && cartStore.hasAvailableCart()
            ? Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                width: context.width(),
                height: 50,
                decoration: boxDecorationWithShadow(
                  borderRadius: radius(24),
                  gradient: LinearGradient(
                      colors: [rf_primaryColor, rf_primaryColor_dark]),
                ),
                child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ).onTap(() {
                // EATicketDetailScreen().launch(context);
              })
            : Container(height: 0),
      ),
    );
  }
}
