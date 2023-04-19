import 'package:customer_app/models/service_model.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;

  ServiceDetailScreen({required this.service});

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dịch vụ ${widget.service.categoryId}', style: secondaryTextStyle(color: rf_primaryColor, size: 12)),
              4.height,
              Text(widget.service.name, style: boldTextStyle(size: 24), maxLines: 2),
              8.height,
              Text(NumberUtil.formatIntPriceToVnd(widget.service.price), style: primaryTextStyle(size: 14)),
              16.height,
              FadeInImage.assetNetwork(
                placeholder: default_image,
                image: widget.service.image,
                height: isMobile ? 200 : 300,
                width: context.width(),
                fit: BoxFit.cover,
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    default_image,
                    fit: BoxFit.cover,
                    height: isMobile ? 200 : 300,
                    width: context.width(),
                  );
                },
              ).cornerRadiusWithClipRRect(5),
              16.height,
              Text(widget.service.description ?? "Chưa có mô tả", style: primaryTextStyle(size: 14)),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return jsAppBar(
      context,
      titleWidget: Text(widget.service.name),
      appBarHeight: 50,
      backWidget: true,
    );
  }
}
