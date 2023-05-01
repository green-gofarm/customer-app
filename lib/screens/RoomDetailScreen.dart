import 'package:customer_app/components/MultiSelectScheduleComponent.dart';

import 'package:customer_app/components/RoomAddToCartBottomSheet.dart';
import 'package:customer_app/fragment/CartDetailFragment.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/create_cart_item.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/store/cart/cart_store.dart';
import 'package:customer_app/store/room_detail/room_detail_store.dart';
import 'package:customer_app/store/room_schedule/room_schedule_store.dart';

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

class RoomDetailArguments {
  final int farmstayId;
  final int roomId;
  final DateTime? defaultDatetime;
  final VoidCallback? onBack;

  RoomDetailArguments(
      {required this.farmstayId,
      required this.roomId,
      this.defaultDatetime,
      this.onBack});
}

class RoomDetailScreen extends StatefulWidget {
  final int farmstayId;
  final int roomId;
  final DateTime? defaultDatetime;
  final VoidCallback? onBack;

  RoomDetailScreen(
      {required this.farmstayId,
      required this.roomId,
      this.defaultDatetime,
      this.onBack});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  static double IMAGE_CONTAINER_HEIGHT = 250;

  RoomDetailStore roomStore = RoomDetailStore();
  RoomScheduleStore scheduleStore = RoomScheduleStore();
  CartStore cartStore = CartStore();

  bool initialized = false;

  List<String> imageUrls = [];
  late int farmstayId;
  late int roomId;
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
      roomId = widget.roomId;
      _tempTickets = {};
      _controller.selectedDates = [];
    });

    tagCategoryStore.getAllTagCategories();
    _refresh(widget.farmstayId, widget.roomId, isInit: true);
  }

  @override
  Widget build(BuildContext context) {
    final room = roomStore.roomDetail;

    return WillPopScope(
        child: Observer(
            builder: (_) => Scaffold(
                  backgroundColor: mainBgColor,
                  body: NestedScrollView(
                    headerSliverBuilder: _headerSliverBuilder,
                    body: _buildBody(room),
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
                    child: _buildBottomNavigationBar(room),
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
    final room = roomStore.roomDetail;
    return <Widget>[
      SliverAppBar(
        floating: true,
        pinned: true,
        title: Text(innerBoxIsScrolled ? (room?.name ?? "") : ""),
        backgroundColor: rf_primaryColor,
        expandedHeight: IMAGE_CONTAINER_HEIGHT,
        iconTheme: const IconThemeData(color: white),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RoutePaths.HOME.value, (route) => false);
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
    final avatar = roomStore.roomDetail?.images.avatar;

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

  Widget _buildBody(RoomModel? room) {
    return Builder(
      builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: () async {
            await _refresh(farmstayId, roomId);
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
                        _buildHeader(room),
                        const SizedBox(height: 8),
                        _buildDescription(room),
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

  Widget _buildHeader(RoomModel? room) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildHeaderContent(room)),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(RoomModel? room) {
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
                (room?.name ?? ""),
                style: boldTextStyle(size: 18),
                softWrap: true,
              ),
            ),
            room?.price != null
                ? Text(
                    "${NumberUtil.formatIntPriceToVnd(room!.price)} / ngày",
                    style: boldTextStyle(size: 16, color: rf_primaryColor),
                  )
                : Text(
                    "Miễn phí",
                    style: boldTextStyle(size: 16, color: rf_primaryColor),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(RoomModel? room) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mô tả'.toUpperCase(), style: boldTextStyle()),
          SizedBox(height: 8),
          room?.description != null
              ? Text(
                  room!.description!,
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
            itemId: roomId, // or any other unique identifier for the item
            date: DateFormat("yyyy-MM-dd").format(key),
            type: CartItemType.ROOM, // or the appropriate FarmstayItemType
          ),
        );
      }
    });

    return resultList;
  }

  void handleOnSubmit(Map<DateTime, int> tickets) async {
    if (cartStore.cart?.rooms != null) {
      await handleRemoveFromCart();
    }
    handleAddToCart(tickets);
  }

  Widget _buildBottomNavigationBar(RoomModel? room) {
    if (room == null) {
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
                    return RoomAddToCartBottomSheet(
                      room: room,
                      listItem: _tempTickets,
                      onSubmit: handleOnSubmit,
                      schedule: scheduleStore.roomSchedule!.schedule,
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
                  size: 32,
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
              Text('Đặt phòng'.toUpperCase(), style: boldTextStyle()),
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
                  await getSchedule(farmstayId, roomId,
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
                schedule: scheduleStore.roomSchedule?.schedule ?? {}),
          ),
        ],
      ),
    );
  }

  Widget BottomImageSlider() {
    final images = roomStore.roomDetail?.images.others;
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
          cartStore.cart!.rooms.forEach((room) {
            if (room.itemId == roomId) {
              _tempTickets.update(room.date, (value) => value + 1,
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

  Future<void> getSchedule(int farmstayId, int roomId,
      {DateTime? date, int? limit}) async {
    await scheduleStore.getRoomSchedule(
        farmstayId: farmstayId, roomId: roomId, date: date, limit: limit ?? 15);
  }

  Future<void> getRoomInfo(int farmstayId, int roomId) async {
    await roomStore.getRoomDetail(farmstayId: farmstayId, roomId: roomId);
    final room = roomStore.roomDetail;
    setState(() {
      if (room != null) {
        imageUrls.add(room.images.avatar);
        imageUrls.addAll(room.images.others);
      }
    });
  }

  Future<void> _refresh(int farmstayId, int roomId, {bool? isInit}) async {
    setState(() {
      if (isInit != true) {
        _tempTickets.clear();
        _controller.selectedDates = [];
      }
    });
    getCart(farmstayId);
    getRoomInfo(farmstayId, roomId);
    await getSchedule(farmstayId, roomId);
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

  void handleAddToCart(Map<DateTime, int> tickets) async {
    final items = convertTempTicketsToList(tickets);
    final isSuccessful = await cartStore.addToCart(farmstayId, items);
    if (!isSuccessful) {
      return;
    }

    toast("Cập nhật thành công");
    await _refresh(farmstayId, roomId);
  }

  Future<void> handleRemoveFromCart() async {
    final removeList = cartStore.cart!.rooms
        .where((ticket) => ticket.itemId == roomId)
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
        _refresh(farmstayId, roomId);
      },
    ).launch(context);
  }
}
