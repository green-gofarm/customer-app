import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonAppComponent extends StatefulWidget {
  final Widget? subWidget;

  CommonAppComponent(
      {
        this.subWidget,
       });

  @override
  State<CommonAppComponent> createState() => _CommonAppComponentState();
}

class _CommonAppComponentState extends State<CommonAppComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              widget.subWidget.validate(),
            ],
          ),
        ],
      ),
    );
  }
}
