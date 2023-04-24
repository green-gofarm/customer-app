import 'package:customer_app/main.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/models/schedule_item_model.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/SSWidgets.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

typedef OnSubmitCallback = void Function(Map<DateTime, int>);

class RoomAddToCartBottomSheet extends StatefulWidget {
  final Map<DateTime, int> listItem;
  final OnSubmitCallback onSubmit;
  final RoomModel room;
  final Map<String, ScheduleItemModel> schedule;

  RoomAddToCartBottomSheet({
    required this.listItem,
    required this.onSubmit,
    required this.room,
    required this.schedule,
  });

  @override
  RoomAddToCartBottomSheetState createState() =>
      RoomAddToCartBottomSheetState();
}

class RoomAddToCartBottomSheetState extends State<RoomAddToCartBottomSheet> {
  Map<DateTime, int> _item = {};

  @override
  void initState() {
    super.initState();
    logger.i(widget.schedule.toString());
    _item = Map.of(widget.listItem);
  }

  void decrementQuantity(DateTime date) {
    setState(() {
        _item.remove(date);
    });
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
              title: 'Cập nhật giỏ hàng (${_item.length})',
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
                image: widget.room.images.avatar,
                fit: BoxFit.cover,
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    default_image,
                    fit: BoxFit.cover,
                  );
                },
              )),
        ),
        SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(widget.room.name,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 16),
                maxLines: 1),
            SizedBox(height: 8),
            Text(NumberUtil.formatIntPriceToVnd(widget.room.price),
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

              final key = DateFormat("yyyy-MM-dd").format(date);
              logger.i("Key: $key, item: ${widget.schedule}");

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: boxDecorationRoundedWithShadow(8,
                    shadowColor: rf_primaryColor.withOpacity(0.8),
                    blurRadius: 0.2,
                    backgroundColor:
                        appStore.isDarkModeOn ? cardDarkColor : white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1 ngày 1 đêm",
                            style: boldTextStyle(color: black)),
                        8.height,
                        Text(DateFormat.yMMMMd("vi_VN").format(date),
                            style: primaryTextStyle(color: black)),
                      ],
                    ).paddingAll(12).expand(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(12),
                                child: Icon(LineIcons.trash,
                                    color: Colors.redAccent))
                            .onTap(() {
                          decrementQuantity(date);
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
                      8.0); // Add a SizedBox with a specific height for spacing
            },
          ),
        )
      ],
    );
  }
}
