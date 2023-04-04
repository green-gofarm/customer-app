import 'package:flutter/material.dart';
import 'package:customer_app/components/RFLocationComponent.dart';
import 'package:customer_app/models/RoomFinderModel.dart';
import 'package:customer_app/utils/RFDataGenerator.dart';
import 'package:customer_app/utils/RFWidget.dart';

class RFLocationViewAllScreen extends StatelessWidget {
  final List<RoomFinderModel> locationListData = locationList();
  final bool? locationWidth;

  RFLocationViewAllScreen({this.locationWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: "Locations",
          appBarHeight: 80,
          showLeadingIcon: false,
          roundCornerShape: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
        child: Wrap(
          spacing: 8,
          runSpacing: 16,
          children: List.generate(
            20,
            (index) {
              return RFLocationComponent(
                  locationData:
                      locationListData[index % locationListData.length],
                  locationWidth: locationWidth);
            },
          ),
        ),
      ),
    );
  }
}
