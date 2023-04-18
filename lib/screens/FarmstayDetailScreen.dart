import 'package:customer_app/components/FarmstayScheduleComponent.dart';
import 'package:customer_app/fragment/CartDetailFragment.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/contact_info_item_model.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/screens/ActivityDetailScreen.dart';
import 'package:customer_app/screens/RoomDetailScreen.dart';
import 'package:customer_app/store/cart/cart_store.dart';
import 'package:customer_app/store/farmstay_detail/farmstay_detail_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/event/EAImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/utils/number_utils.dart';

class FarmstayDetailArguments {
  final int farmstayId;

  FarmstayDetailArguments({required this.farmstayId});
}

class FarmstayDetailScreen extends StatefulWidget {
  final int farmstayId;

  FarmstayDetailScreen({required this.farmstayId});

  @override
  _FarmstayDetailScreenState createState() => _FarmstayDetailScreenState();
}

class _FarmstayDetailScreenState extends State<FarmstayDetailScreen> {
  static double IMAGE_CONTAINER_HEIGHT = 250;

  FarmstayDetailStore farmstayStore = FarmstayDetailStore();
  CartStore cartStore = CartStore();

  List<String> imageUrls = [];
  List<ActivityModel> activities = [];
  List<RoomModel> rooms = [];

  @override
  void initState() {
    super.initState();
    _refresh(widget.farmstayId);
  }

  void prepareShowDetail(FarmstayDetailModel farmstay) {
    imageUrls.clear();
    activities.clear();
    rooms.clear();

    imageUrls.add(farmstay.images.avatar!);
    imageUrls.addAll(farmstay.images.others);
    activities.addAll(farmstay.activities);
    rooms.addAll(farmstay.rooms);
  }

  Future<void> _refresh(int id) async {
    await farmstayStore.getFarmstayDetail(id);
    setState(() {
      if (farmstayStore.farmstayDetail != null) {
        prepareShowDetail(farmstayStore.farmstayDetail!);
        initFarmstayCart();
      }
    });
  }

  Future<void> initFarmstayCart() async {
    if (authStore.isAuthenticated()) {
      await cartStore.getCustomerCartInFarmstay(widget.farmstayId);
    }
  }

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: mainBgColor,
        body: NestedScrollView(
          headerSliverBuilder: _buildHeader,
          body: _buildBody(),
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        floating: true,
        pinned: true,
        title: Text(innerBoxIsScrolled
            ? (farmstayStore.farmstayDetail?.name ?? "")
            : ""),
        backgroundColor: rf_primaryColor,
        expandedHeight: IMAGE_CONTAINER_HEIGHT,
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
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotIndicator(
                      pageController: pageController,
                      pages: imageUrls,
                      indicatorColor: white,
                      unselectedIndicatorColor: grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildBody() {
    return Builder(
      builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: () async {
            if (farmstayStore.farmstayDetail != null) {
              return await _refresh(farmstayStore.farmstayDetail!.id);
            }
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              ..._buildSlivers(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSlivers() {
    return [
      SliverToBoxAdapter(child: _farmstayTitle()),
      SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(child: _farmstayDescription()),
      SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(child: _farmstaySchedule()),
      SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(child: _farmstayLocation()),
      SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(child: _farmstayContactInfo()),
      SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(child: _farmstayActivities()),
      SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(child: _farmstayRooms()),
    ];
  }

  Widget _farmstayTitle() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(farmstayStore.farmstayDetail?.name ?? "",
                    style: boldTextStyle(size: 20)),
                8.height,
                Row(
                  children: [
                    RatingBarWidget(
                      onRatingChanged: (rating) {},
                      rating: farmstayStore.farmstayDetail?.rating ?? 0.0,
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
                    farmstayStore.farmstayDetail?.rating != null &&
                            farmstayStore.farmstayDetail!.rating > 0.0
                        ? Text(
                            "(${farmstayStore.farmstayDetail!.rating})",
                            style: primaryTextStyle(size: 12),
                          )
                        : Text(
                            "Chưa có đánh giá",
                            style: primaryTextStyle(
                                fontStyle: FontStyle.italic, size: 12),
                          ),
                    8.width,
                    if (farmstayStore.farmstayDetail?.rating != null &&
                        farmstayStore.farmstayDetail!.rating > 0.0)
                      Text(
                        "20 nhận xét",
                        style: primaryTextStyle(
                            size: 12,
                            color: rf_primaryColor,
                            weight: FontWeight.bold),
                      ),
                  ],
                ),
              ],
            ).expand(),
          ],
        ));
  }

  Widget _farmstayDescription() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mô tả'.toUpperCase(), style: boldTextStyle()),
          8.height,
          farmstayStore.farmstayDetail?.description != null
              ? Text(
                  farmstayStore.farmstayDetail!.description!,
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.justify,
                )
              : Text("Chưa có mô tả",
                  style: secondaryTextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _farmstayLocation() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vị trí'.toUpperCase(), style: boldTextStyle()),
            ],
          ),
          8.height,
          Text(farmstayStore.farmstayDetail?.address.province?.name ?? "",
              style: boldTextStyle()),
          8.height,
          Text(farmstayStore.farmstayDetail?.address.toString() ?? "",
              style: secondaryTextStyle()),
          rfCommonCachedNetworkImage(event_ic_map,
              fit: BoxFit.cover, height: 200, width: context.width()),
        ],
      ),
    );
  }

  Widget _farmstayContactInfo() {
    List<ContactInfoItemModel> listContact =
        farmstayStore.farmstayDetail?.contactInformation ?? [];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liên hệ'.toUpperCase(),
            style: boldTextStyle(),
          ),
          8.height,
          Table(
            columnWidths: {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: listContact.map((contact) {
              return TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text("${contact.method}:",
                        style: boldTextStyle(size: 13)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                    child: Text("${contact.value}",
                        style: secondaryTextStyle(size: 13)),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _farmstayActivities() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoạt động (${activities.length})'.toUpperCase(),
            style: boldTextStyle(),
          ),
          8.height,
          ListActivities(),
        ],
      ),
    );
  }

  Widget _farmstayRooms() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phòng (${rooms.length})'.toUpperCase(),
            style: boldTextStyle(),
          ),
          8.height,
          ListRooms(),
        ],
      ),
    );
  }

  Widget _farmstaySchedule() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch hoạt động'.toUpperCase(),
            style: boldTextStyle(),
          ),
          farmstayStore.farmstayDetail != null
              ? FarmstayScheduleComponent(
                  farmstay: farmstayStore.farmstayDetail!,
                  refresh: () {
                    _refresh(widget.farmstayId);
                  },
                )
              : Text(
                  'Chưa có hoạt động nào',
                  style: secondaryTextStyle(fontStyle: FontStyle.italic),
                )
        ],
      ),
    );
  }

  Widget ListActivities() {
    return HorizontalList(
      padding: EdgeInsets.only(bottom: 8, top: 8, right: 12),
      itemCount: activities.length,
      itemBuilder: (context, i) {
        final activity = activities[i];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: default_image,
                    image: activity.images.avatar!,
                    height: 180,
                    width: context.width() * 0.7,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(activity.name, style: boldTextStyle()),
                6.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Entypo.book, size: 16),
                        8.width,
                        Row(
                          children: [
                            Text("Số lần đặt:", style: secondaryTextStyle()),
                            4.width,
                            activity.bookingCount != null &&
                                    activity.bookingCount! > 0
                                ? Text("${activity.bookingCount ?? 0} lần",
                                    style: secondaryTextStyle())
                                : Text("Chờ khám phá",
                                    style: secondaryTextStyle(
                                        fontStyle: FontStyle.italic, size: 11))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                6.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.price_change, size: 16),
                    8.width,
                    Text(
                      NumberUtil.formatIntPriceToVnd(activity.price),
                      style: secondaryTextStyle(color: rf_primaryColor),
                    ),
                  ],
                ),
              ],
            )
          ],
        ).paddingRight(8).onTap(() {
          ActivityDetailScreen(
            farmstayId: activity.farmstayId,
            activityId: activity.id,
            onBack: () => _refresh(activity.farmstayId),
          ).launch(context,
              pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
        });
      },
    );
  }

  Widget ListRooms() {
    return HorizontalList(
      padding: EdgeInsets.only(bottom: 8, top: 8, right: 12),
      itemCount: rooms.length,
      itemBuilder: (context, i) {
        final room = rooms[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: default_image,
                    image: room.images.avatar!,
                    height: 180,
                    width: context.width() * 0.7,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(room.name, style: boldTextStyle()),
                6.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Số lần đặt:", style: secondaryTextStyle()),
                        4.width,
                        room.bookingCount != null && room.bookingCount! > 0
                            ? Text("${room.bookingCount ?? 0} lần",
                                style: secondaryTextStyle())
                            : Text("Chờ khám phá",
                                style: secondaryTextStyle(
                                    fontStyle: FontStyle.italic, size: 11))
                      ],
                    ),
                  ],
                ),
                6.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.price_change, size: 16),
                    8.width,
                    Text(
                      NumberUtil.formatIntPriceToVnd(room.price),
                      style: secondaryTextStyle(color: rf_primaryColor),
                    ),
                  ],
                ),
              ],
            )
          ],
        ).paddingRight(8).onTap(() {
          RoomDetailScreen(
            farmstayId: room.farmstayId,
            roomId: room.id,
            onBack: () => _refresh(room.farmstayId),
          ).launch(context,
              pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
        });
      },
    );
  }

  void handleGoToCartDetailScreen() {
    final farmstayId = farmstayStore.farmstayDetail?.id;
    if (farmstayId == null) return;
    CartDetailFragment(
      farmstayId: farmstayId,
      onBack: () {
        if (farmstayId != null) {
          _refresh(farmstayId);
        }
      },
    ).launch(context);
  }

  Widget _buildBottom() {
    if (!cartStore.hasAvailableCart() || farmstayStore.farmstayDetail == null) {
      return Container(height: 0);
    }

    return Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 24),
        width: context.width(),
        height: 50,
        decoration: boxDecorationWithShadow(
          borderRadius: radius(24),
          gradient: LinearGradient(colors: [rf_primaryColor, rf_primaryColor]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart_outlined, color: Colors.white),
                8.width,
                Text("(${cartStore.getTotalItem()})",
                    style: boldTextStyle(color: Colors.white))
              ],
            ),
            Text(cartStore.getTotalPriceVndString(),
                style: boldTextStyle(color: Colors.white)),
          ],
        ),
      ).onTap(handleGoToCartDetailScreen),
    );
  }
}