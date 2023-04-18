import 'package:customer_app/utils/JSWidget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String url;
  final VoidCallback onCloseCallback;

  PaymentScreen({required this.url, required this.onCloseCallback});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: jsAppBar(
            context,
            titleWidget: Text('VN Pay'),
            appBarHeight: 50,
            backWidget: true,
            callBack: widget.onCloseCallback
          ),
          body: WebViewWidget(controller: controller),
        ),
        onWillPop: () async {
          widget.onCloseCallback();
          return true;
        });
  }
}
