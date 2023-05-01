import 'package:customer_app/components/MultiSelectScheduleComponent.dart';
import 'package:customer_app/components/ActivityAddToCartBottomSheet.dart';
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
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ActivityDetailArguments {
  final int farmstayId;
  final int activityId;
  final DateTime? defaultDatetime;
  final VoidCallback? onBack;

  ActivityDetailArguments(
      {required this.farmstayId,
      required this.activityId,
      this.defaultDatetime,
      this.onBack});
}

class ActivityDetailScreen extends StatefulWidget {
  final int farmstayId;
  final int activityId;
  final DateTime? defaultDatetime;
  final VoidCallback? onBack;

  ActivityDetailScreen(
      {required this.farmstayId,
      required this.activityId,
      this.defaultDatetime,
      this.onBack});

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
  DateTime? defaultDateTime;

  Map<DateTime, int> _tempTickets = {};
  DateRangePickerController _controller = DateRangePickerController();

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() {
      farmstayId = widget.farmstayId;
      activityId = widget.activityId;
      _tempTickets = {};
      _controller.selectedDates = [];
    });

    tagCategoryStore.getAllTagCategories();
    _refresh(widget.farmstayId, widget.activityId, isInit: true);
  }

  @override
  Widget build(BuildContext context) {
    final activity = activityStore.activityDetail;

    return WillPopScope(
        child: Observer(
            builder: (_) => Scaffold(
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
                          offset: Offset(0, -1),
                          // Offset for the shadow, change as needed
                          blurRadius: 2, // Adjust the blur radius as needed
                        ),
                      ],
                    ),
                    child: _buildBottomNavigationBar(activity),
                  ),
                )),
        onWillPop: () async {
          if (widget.onBack != null) {
            widget.onBack!();
            return true;
          }

          Navigator.pop(context);
          return true;
        });
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, RoutePaths.HOME.value, (route) => false);
              },
              icon: Icon(Icons.home, size: 20))
        ],
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
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  default_image,
                  fit: BoxFit.cover,
                );
              },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                (activity?.name ?? ""),
                style: boldTextStyle(size: 20),
                softWrap: true,
              ),
            ),
            activity?.price != null
                ? Text(
                    "${NumberUtil.formatIntPriceToVnd(activity!.price)} / vé",
                    style: boldTextStyle(size: 16, color: rf_primaryColor),
                  )
                : Text(
                    "Miễn phí",
                    style: boldTextStyle(size: 16, color: rf_primaryColor),
                  ),
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

  List<CreateCartItem> convertTempTicketsToList(Map<DateTime, int> tickets) {
    List<CreateCartItem> resultList = [];

    tickets.forEach((key, value) {
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

  void handleOnSubmit(Map<DateTime, int> tickets) async {
    if (cartStore.cart?.activities != null) {
      await handleRemoveFromCart();
    }
    handleAddToCart(tickets);
  }

  Widget _buildBottomNavigationBar(ActivityModel? activity) {
    if (activity == null) {
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
              enabled: !cartStore.loading,
              context: context,
              title: totalTempTicket > 0
                  ? 'Cập nhật giỏ hàng (${totalTempTicket})'
                  : 'Cập nhật giỏ hàng',
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
                if (totalTempTicket <= 0) {
                  handleOnSubmit({});
                  return;
                }
                await showModalBottomSheet<Map<DateTime, int>>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  context: context,
                  builder: (_) {
                    return ActivityAddToCartBottomSheet(
                      activity: activity,
                      listItem: _tempTickets,
                      onSubmit: handleOnSubmit,
                      schedule: scheduleStore.activitySchedule!.schedule,
                    );
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
              blurRadius: 2,
            ),
          ],
          color: cartStore.hasAvailableCart() ? rf_primaryColor : Colors.white),
      padding: EdgeInsets.all(6),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Center(
              child: Icon(Icons.shopping_cart_outlined,
                  size: 36,
                  color: cartStore.hasAvailableCart()
                      ? Colors.white
                      : Colors.black),
            ),
            if (cartStore.hasAvailableCart())
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cartStore.getTotalItem().toString(),
                      style: TextStyle(
                        color: rf_primaryColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ).onTap(() {
      if (cartStore.hasAvailableCart()) {
        handleGoToCartDetailScreen();
      }
    });
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
          if (cartStore.loading)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          Text(cartStore.getTotalPriceVndString(),
              style: boldTextStyle(color: Colors.white)),
        ],
      ),
    ).onTap(handleGoToCartDetailScreen);
  }

  Widget Calendar() {
    return Container(
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
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 300,
            child: MultiSelectScheduleComponent(
                controller: _controller,
                onViewChanged: (start, end) async {
                  final centerDay = DateTimeUtil.getCenterDate(start, end);
                  final limit =
                      DateTimeUtil.getLongestPeriod(start, end, centerDay);
                  await getSchedule(farmstayId, activityId,
                      date: centerDay, limit: limit);
                },
                onSelectedDates: (List<DateTime> dates) {
                  Map<DateTime, int> newTempTickets = {};

                  dates.forEach((date) {
                    newTempTickets[date] = _tempTickets.containsKey(date)
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
                schedule: scheduleStore.activitySchedule?.schedule ?? {}),
          ),
        ],
      ),
    );
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
            height: 200,
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
                    imageErrorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        default_image,
                        fit: BoxFit.cover,
                        height: 170,
                        width: 300,
                      );
                    },
                  ),
                ).paddingRight(8.0);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> getCart(int farmstayId) async {
    if (authStore.isAuthenticated()) {
      await cartStore.getCustomerCartInFarmstay(farmstayId);
      if (cartStore.cart != null) {
        setState(() {
          cartStore.cart!.activities.forEach((activity) {
            if (activity.itemId == activityId) {
              _tempTickets.update(activity.date, (value) => value + 1,
                  ifAbsent: () => 1);
            }
          });

          _controller.selectedDates = _tempTickets.keys
              .where((date) => _tempTickets[date]! > 0)
              .toList();
        });
      }
    }
  }

  Future<void> getSchedule(int farmstayId, int activityId,
      {DateTime? date, int? limit}) async {
    await scheduleStore.getActivitySchedule(
        farmstayId: farmstayId,
        activityId: activityId,
        date: date,
        limit: limit ?? 30);
  }

  Future<void> getActivityInfo(int farmstayId, int activityId) async {
    await activityStore.getActivityDetail(
        farmstayId: farmstayId, activityId: activityId);
    final activity = activityStore.activityDetail;
    setState(() {
      if (activity != null) {
        imageUrls.add(activity.images.avatar);
        imageUrls.addAll(activity.images.others);
      }
    });
  }

  Future<void> _refresh(int farmstayId, int activityId, {bool? isInit}) async {
    setState(() {
      if (isInit != true) {
        _tempTickets.clear();
        _controller.selectedDates = [];
      }
    });
    getCart(farmstayId);
    getActivityInfo(farmstayId, activityId);
    await getSchedule(farmstayId, activityId);
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

  void handleAddToCart(Map<DateTime, int> tickets) async {
    final items = convertTempTicketsToList(tickets);
    final isSuccessful = await cartStore.addToCart(farmstayId, items);
    if (!isSuccessful) {
      return;
    }

    toast("Cập nhật thành công");
    await _refresh(farmstayId, activityId);
  }

  Future<void> handleRemoveFromCart() async {
    final removeList = cartStore.cart!.activities
        .where((ticket) => ticket.itemId == activityId)
        .map((ticket) => ticket.id)
        .toList();
    if (removeList.length <= 0) {
      return;
    }

    final isSuccessful = await cartStore.removeItems(farmstayId, removeList);
    if (!isSuccessful) {
      toast("Có lỗi xảy ra");
      return;
    }
  }

  void handleGoToCartDetailScreen() {
    CartDetailFragment(
      farmstayId: farmstayId,
      onBack: () {
        _refresh(farmstayId, activityId);
      },
    ).launch(context);
  }
}
