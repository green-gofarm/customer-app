import 'package:customer_app/components/ActivityScheduleComponent.dart';
import 'package:customer_app/components/AddToCartBottomSheet.dart';
import 'package:customer_app/fragment/CartDetailFragment.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/create_cart_item.dart';
import 'package:customer_app/store/activity_detail/activity_detail_store.dart';
import 'package:customer_app/store/activity_schedule/activity_schedule_store.dart';
import 'package:customer_app/store/cart/cart_store.dart';

import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/cart_item_type.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ActivityDetailScreen extends StatefulWidget {
  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  static double IMAGE_CONTAINER_HEIGHT = 250;

  ActivityDetailStore activityStore = ActivityDetailStore();
  ActivityScheduleStore scheduleStore = ActivityScheduleStore();
  CartStore cartStore = CartStore();

  bool initialized = false;

  List<String> imageUrls = [];
  late int farmstayId;
  late int activityId;
  late DateTime? defaultDateTime;

  Map<DateTime, int> _tempTickets = {};
  DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await tagCategoryStore.getAllTagCategories();
    setState(() {
      _controller.selectedDates = [];
    });
  }

  Future<void> getCart(int farmstayId) async {
    if (authStore.isAuthenticated()) {
      await cartStore.getCustomerCartInFarmstay(farmstayId);
      setState(() {});
    }
  }

  Future<void> getSchedule(
      int farmstayId, int activityId, DateTime? date, int limit) async {
    await scheduleStore.getActivitySchedule(
        farmstayId: farmstayId,
        activityId: activityId,
        date: defaultDateTime,
        limit: limit);
    setState(() {});
  }

  Future<void> getActivityInfo(int farmstayId, int activityId) async {
    await activityStore.getActivityDetail(
        farmstayId: farmstayId, activityId: activityId);
    final activity = activityStore.activityDetail;
    setState(() {
      if (activity != null) {
        imageUrls.add(activity.images.avatar!);
        imageUrls.addAll(activity.images.others);
      }
    });
  }

  void setupDefaultSelectedDate(DateTime defaultDateTime) {
    setState(() {
      _tempTickets = {defaultDateTime: 1};
      _controller.selectedDates = _tempTickets.keys.toList();
    });
  }

  Future<void> initActivityDetail(BuildContext context) async {
    final map =
        (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
    farmstayId = map['farmstayId'];
    activityId = map['activityId'];
    defaultDateTime = map['defaultDateTime'];

    _refresh(farmstayId, activityId);
  }

  Future<void> _refresh(int farmstayId, int activityId) async {
    await getCart(farmstayId);
    await getActivityInfo(farmstayId, activityId);
  }

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    final activity = activityStore.activityDetail;

    if (activity == null && !initialized) {
      setState(() {
        initialized = true;
      });
      initActivityDetail(context);
    }

    return Scaffold(
      backgroundColor: mainBgColor,
      body: NestedScrollView(
        headerSliverBuilder: _headerSliverBuilder,
        body: _buildBody(activity),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, -1), // Offset for the shadow, change as needed
              blurRadius: 2, // Adjust the blur radius as needed
            ),
          ],
        ),
        child: _buildBottomNavigationBar(activity),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    final activity = activityStore.activityDetail;
    return <Widget>[
      SliverAppBar(
        floating: true,
        pinned: true,
        title: Text(innerBoxIsScrolled ? (activity?.name ?? "") : ""),
        backgroundColor: rf_primaryColor,
        expandedHeight: IMAGE_CONTAINER_HEIGHT,
        iconTheme: const IconThemeData(color: white),
        automaticallyImplyLeading: true,
        flexibleSpace: FlexibleSpaceBar(
          background: _buildFlexibleSpaceBackground(),
        ),
      ),
    ];
  }

  Widget _buildFlexibleSpaceBackground() {
    final avatar = activityStore.activityDetail?.images.avatar;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: avatar != null ? 1 : 0,
          itemBuilder: (context, i) {
            return FadeInImage.assetNetwork(
              placeholder: default_image,
              image: avatar!,
              fit: BoxFit.cover,
            );
          },
          onPageChanged: (value) {
            setState(() => currentIndexPage = value);
          },
        ),
        DotIndicator(
          pageController: pageController,
          pages: avatar != null ? [avatar] : [],
          indicatorColor: white,
          unselectedIndicatorColor: grey,
        ).paddingBottom(8),
      ],
    );
  }

  Widget _buildBody(ActivityModel? activity) {
    return Builder(
      builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: () async {
            await _refresh(farmstayId, activityId);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    color: mainBgColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(activity),
                        const SizedBox(height: 8),
                        _buildDescription(activity),
                        const SizedBox(height: 8),
                        Calendar(),
                        const SizedBox(height: 8),
                        BottomImageSlider(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildHeader(ActivityModel? activity) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildHeaderContent(activity)),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(ActivityModel? activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text((activity?.name ?? ""), style: boldTextStyle(size: 20)),
            activity?.price != null
                ? Text(
                    "${NumberUtil.formatIntPriceToVnd(activity!.price)} / vé",
                    style: boldTextStyle(size: 16, color: rf_primaryColor))
                : Text("Miễn phí",
                    style: boldTextStyle(size: 16, color: rf_primaryColor)),
          ],
        ),
        activity?.tags != null && activity!.tags!.length > 0
            ? Column(
                children: [const SizedBox(height: 8), ActivityHashtags()],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget ActivityHashtags() {
    final activity = activityStore.activityDetail!;

    return Container(
      child: HorizontalList(
          itemCount: activity.tags!.length,
          itemBuilder: (context, i) {
            final name = tagCategoryStore.categoryMap[activity.tags![i]]?.name;
            if (name == null) {
              return SizedBox();
            }

            return Container(
              decoration:
                  boxDecorationWithRoundedCorners(borderRadius: radius(16)),
              child: Text(
                "#$name",
                style: primaryTextStyle(color: Colors.indigo, size: 12),
              ),
            );
          }),
    );
  }

  Widget _buildDescription(ActivityModel? activity) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mô tả'.toUpperCase(), style: boldTextStyle()),
          SizedBox(height: 8),
          activity?.description != null
              ? Text(
                  activity!.description!,
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.justify,
                )
              : Text("Chưa có mô tả",
                  style: secondaryTextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  int getTotalQuantity() {
    int totalQuantity = 0;

    _tempTickets.forEach((date, quantity) {
      totalQuantity += quantity;
    });

    return totalQuantity;
  }

  void handleOnClose(Map<DateTime, int> items) {
    logger.i("ON CLOSE");
    setState(() {
      _tempTickets = items;
    });
  }

  void handleUpdateQuantity(DateTime date, int newQuantity) {
    Map<DateTime, int> newTempTickets = {};

    _tempTickets.keys.forEach((key) {
      newTempTickets[key] = _tempTickets[key] ?? 0;
    });

    newTempTickets[date] = newQuantity;

    setState(() {
      _tempTickets = newTempTickets;
      _controller.selectedDates = newTempTickets.keys
          .where((date) => newTempTickets[date]! > 0)
          .toList();
    });
  }

  List<CreateCartItem> convertTempTicketsToList() {
    List<CreateCartItem> resultList = [];

    _tempTickets.forEach((key, value) {
      for (int i = 0; i < value; i++) {
        resultList.add(
          CreateCartItem(
            itemId: activityId, // or any other unique identifier for the item
            date: DateFormat("yyyy-MM-dd").format(key),
            type: CartItemType.ACTIVITY, // or the appropriate FarmstayItemType
          ),
        );
      }
    });

    return resultList;
  }

  void handleAddToCart() async {
    final items = convertTempTicketsToList();
    final isSuccessful = await cartStore.addToCart(farmstayId, items);
    if (!isSuccessful) {
      toast("Có lỗi xảy ra, không thể đặt vé");
      return;
    }

    toast("Thêm thành công");
  }

  Widget _buildBottomNavigationBar(ActivityModel? activity) {
    if (_tempTickets.isEmpty || activity == null) {
      return _buildCartOnlyBottom();
    }

    final totalTempTicket = getTotalQuantity();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          _smallCart(),
          SizedBox(width: 8),
          Expanded(
            child: sSAppButton(
              enabled: totalTempTicket > 0,
              context: context,
              title: 'Mua ngay (${totalTempTicket})',
              child: cartStore.loading
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : null,
              onPressed: () async {
                await showModalBottomSheet<Map<DateTime, int>>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  context: context,
                  builder: (_) {
                    return AddToCartBottomSheet(
                        activity: activity,
                        listItem: _tempTickets,
                        onSubmit: handleAddToCart,
                        onUpdatedQuantity: handleUpdateQuantity);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _smallCart() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              offset: Offset(0, 0),
              // Offset for the shadow, change as needed
              blurRadius: 2, // Adjust the blur radius as needed
            ),
          ],
          color: cartStore.hasAvailableCart() ? rf_primaryColor : Colors.white),
      padding: EdgeInsets.all(12),
      child: Icon(Icons.shopping_cart_outlined,
          color: cartStore.hasAvailableCart() ? Colors.white : Colors.black),
    ).onTap(() {
      if (cartStore.hasAvailableCart()) {
        handleGoToCartDetailScreen();
      }
    });
  }

  void handleGoToCartDetailScreen() {
    CartDetailFragment(
      farmstayId: farmstayId,
      onBack: () {
        if (farmstayId != null) {
          _refresh(farmstayId, activityId);
        }
      },
    ).launch(context);
  }

  Widget _buildCartOnlyBottom() {
    if (!cartStore.hasAvailableCart()) {
      return Container(height: 0);
    }

    return Container(
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
              Text(cartStore.getTotalItem().toString(),
                  style: boldTextStyle(color: Colors.white))
            ],
          ),
          Text(cartStore.getTotalPriceVndString(),
              style: boldTextStyle(color: Colors.white)),
        ],
      ),
    ).onTap(handleGoToCartDetailScreen);
  }

  Widget Calendar() {
    return Observer(
        builder: (_) => Container(
              color: Colors.white,
              padding: EdgeInsets.all(12),
              width: context.width(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Đặt vé'.toUpperCase(), style: boldTextStyle()),
                      16.width,
                      // if (scheduleStore.isLoading)
                      //   SizedBox(
                      //     width: 14,
                      //     height: 14,
                      //     child: CircularProgressIndicator(strokeWidth: 2),
                      //   )
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 300,
                    child: ActivityScheduleComponent(
                        controller: _controller,
                        onViewChanged: (start, end) async {
                          final centerDay =
                              DateTimeUtil.getCenterDate(start, end);
                          final limit = DateTimeUtil.getLongestPeriod(
                              start, end, centerDay);
                          await getSchedule(
                              farmstayId, activityId, centerDay, limit);
                        },
                        onSelectedDates: (List<DateTime> dates) {
                          Map<DateTime, int> newTempTickets = {};

                          dates.forEach((date) {
                            newTempTickets[date] =
                                _tempTickets.containsKey(date)
                                    ? _tempTickets[date]!
                                    : 1;
                          });

                          setState(() {
                            _tempTickets = newTempTickets;
                            _controller.selectedDates = _tempTickets.keys
                                .where((date) => _tempTickets[date]! > 0)
                                .toList();
                          });
                        },
                        schedule:
                            scheduleStore.activitySchedule?.schedule ?? {}),
                  ),
                ],
              ),
            ));
  }

  Widget BottomImageSlider() {
    final images = activityStore.activityDetail?.images.others;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ảnh minh họa'.toUpperCase(), style: boldTextStyle()),
          SizedBox(height: 8),
          Container(
            height: 200, // Adjust the height of the horizontal list as needed
            child: ListView.builder(
              itemCount: images != null ? images.length : 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                final link = images![i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: default_image,
                    image: link,
                    fit: BoxFit.cover,
                    height: 170,
                    width: 300,
                  ),
                ).paddingRight(8.0);
              },
            ),
          )
        ],
      ),
    );
  }
}
