import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  @override
  SupportScreenState createState() => SupportScreenState();
}

class SupportScreenState extends State<SupportScreen> {
  static const String APPBAR_NAME = "Trung tâm hỗ trợ";

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: _buildAppbar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      APPBAR_NAME,
      showBack: true,
      textSize: 18,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color:
          appStore.isDarkModeOn ? context.scaffoldBackgroundColor : mainBgColor,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {},
            child: _buildEmpty(context, MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email app');
    }
  }

  Widget _buildEmpty(BuildContext context, double width) {
    return SingleChildScrollView(
      child: Container(
        color: context.scaffoldBackgroundColor,
        height: context.height(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: width * 0.15),
              Icon(Icons.support_agent_rounded, size: width * 0.5),
              8.height,
              Text(
                'Hỗ trợ khách hàng.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: width * 0.07),
              Text(
                "Nếu bạn gặp vấn đề hoặc có câu hỏi, vui lòng liên hệ\nvới bộ phận hỗ trợ của chúng tôi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: width * 0.07),
              GestureDetector(
                onTap: () => _launchEmail('gofarm.service@gmail.com'),
                child: Text(
                  'Gửi email cho chúng tôi tại địa chỉ: \ngofarm.service@gmail.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
