import 'package:customer_app/models/faq_model.dart';
import 'package:customer_app/models/policy_model.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PolicyDetailScreen extends StatefulWidget {
  final PolicyModel policy;

  PolicyDetailScreen({required this.policy});

  @override
  _PolicyDetailScreenState createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends State<PolicyDetailScreen> {
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
              Text('Quy định', style: secondaryTextStyle(color: rf_primaryColor, size: 12)),
              4.height,
              Text(widget.policy.name, style: boldTextStyle(size: 24), maxLines: 2),
              8.height,
              Text(widget.policy.description, style: primaryTextStyle(size: 14)),
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
      titleWidget: Text(widget.policy.name),
      appBarHeight: 50,
      backWidget: true,
    );
  }
}
