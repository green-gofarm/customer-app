import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/schedule_item_model.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

typedef OnSubmitCallback = void Function(Map<DateTime, int>);

class ActivityAddToCartBottomSheet extends StatefulWidget {
  final Map<DateTime, int> listItem;
  final OnSubmitCallback onSubmit;
  final ActivityModel activity;
  final Map<String, ScheduleItemModel> schedule;

  ActivityAddToCartBottomSheet({
    required this.listItem,
    required this.onSubmit,
    required this.activity,
    required this.schedule,
  });

  @override
  ActivityAddToCartBottomSheetState createState() =>
      ActivityAddToCartBottomSheetState();
}

class ActivityAddToCartBottomSheetState
    extends State<ActivityAddToCartBottomSheet> {
  Map<DateTime, int> _item = {};

  @override
  void initState() {
    super.initState();
    logger.i(widget.schedule.toString());
    _item = Map.of(widget.listItem);
  }

  void incrementQuantity(DateTime date) {
    setState(() {
      final quantity = _item[date]! + 1;
      _item[date] = quantity;
    });
  }

  void decrementQuantity(DateTime date) {
    setState(() {
      final quantity = _item[date]! - 1;
      if (quantity >= 0) {
        _item[date] = quantity;
      }
    });
  }

  int getTotalQuantity() {
    int totalQuantity = 0;

    _item.forEach((date, quantity) {
      totalQuantity += quantity;
    });

    return totalQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _itemDetail(),
          Divider(color: Colors.grey),
          Container(
            height: MediaQuery.of(context).size.height * 0.5 - 150,
            child: _listItem(),
          ),
          Divider(color: Colors.grey),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: sSAppButton(
              context: context,
              title: 'Cập nhật giỏ hàng (${getTotalQuantity()})',
              onPressed: () {
                Navigator.pop(context);
                widget.onSubmit(_item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: default_image,
                image: widget.activity.images.avatar,
                fit: BoxFit.cover,
              )),
        ),
        SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(widget.activity.name,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 16),
                maxLines: 1),
            SizedBox(height: 8),
            Text(NumberUtil.formatIntPriceToVnd(widget.activity.price),
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: primaryTextStyle(color: rf_primaryColor)),
          ],
        ),
      ],
    ).paddingAll(12);
  }

  Widget _listItem() {
    // Filter out items with quantity less than 1
    List<DateTime> filteredDates = _item.keys.toList();

    return Row(
      children: [
        Expanded(
          child: ListView.separated(
            key: ValueKey(_item), // Add a ValueKey here
            itemCount: filteredDates.length,
            itemBuilder: (context, index) {
              DateTime date = filteredDates[index];
              int quantity = _item[date]!;

              final key = DateFormat("yyyy-MM-dd").format(date);
              final scheduleItem = widget.schedule[key];
              logger.i("Key: $key, item: ${widget.schedule}");

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: boxDecorationRoundedWithShadow(8,
                    backgroundColor:
                        appStore.isDarkModeOn ? cardDarkColor : white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)),
                          backgroundColor: quantity == 0
                              ? grey.withOpacity(0.2)
                              : rf_primaryColor),
                      child: Text(quantity.toString(),
                          style: boldTextStyle(
                              size: 50, color: quantity == 0 ? grey : white)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vé tham gia", style: boldTextStyle(color: black)),
                        8.height,
                        Text(DateFormat.yMMMMd("vi_VN").format(date),
                            style: primaryTextStyle(color: black)),
                        8.height,
                        Text("Còn ${scheduleItem?.availableItem ?? 0} vé",
                            style: secondaryTextStyle(color: rf_primaryColor)),
                      ],
                    ).paddingAll(8).expand(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(12),
                                decoration: boxDecorationWithShadow(
                                    backgroundColor: context.cardColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8))),
                                child: Icon(Icons.add, color: rf_primaryColor))
                            .onTap(() {
                          if (quantity < (scheduleItem?.availableItem ?? 0)) {
                            incrementQuantity(date);
                          }
                        }),
                        Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(12),
                                decoration: boxDecorationWithShadow(
                                    backgroundColor: context.cardColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8))),
                                child: Icon(Icons.minimize,
                                    color: rf_primaryColor))
                            .onTap(() {
                          if (quantity > 0) {
                            decrementQuantity(date);
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                  height:
                      8); // Add a SizedBox with a specific height for spacing
            },
          ),
        )
      ],
    );
  }
}
