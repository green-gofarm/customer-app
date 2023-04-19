import 'package:customer_app/models/faq_model.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FaqDetailScreen extends StatefulWidget {
  final FaqModel faq;

  FaqDetailScreen({required this.faq});

  @override
  _FaqDetailScreenState createState() => _FaqDetailScreenState();
}

class _FaqDetailScreenState extends State<FaqDetailScreen> {
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
              Text('Câu hỏi', style: secondaryTextStyle(color: rf_primaryColor, size: 12)),
              4.height,
              Text(widget.faq.question, style: boldTextStyle(size: 24), maxLines: 2),
              8.height,
              Text(widget.faq.answer ?? "Chưa có trả lời từ chủ farmstay", style: primaryTextStyle(size: 14)),
              16.height,
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return jsAppBar(
        context,
        titleWidget: Text(widget.faq.question),
        appBarHeight: 50,
        backWidget: true,
    );
  }
}
