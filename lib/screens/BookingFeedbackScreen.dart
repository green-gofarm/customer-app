import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

typedef HandleCreateFunction = Function(
    {required double rating, required String comment});

class BookingFeedbackScreen extends StatefulWidget {
  final HandleCreateFunction onCreate;

  BookingFeedbackScreen({required this.onCreate});

  @override
  _BookingFeedbackScreenState createState() => _BookingFeedbackScreenState();
}

class _BookingFeedbackScreenState extends State<BookingFeedbackScreen> {
  double rating = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      "Feedback",
      center: true,
      showBack: true,
      color: rf_primaryColor,
      textColor: Colors.white,
      textSize: 16,
      backWidget: IconButton(
        icon: Icon(Icons.close, color: white),
        onPressed: () {
          finish(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đánh giá về chuyền đi', style: boldTextStyle()).paddingAll(16),
          30.height,
          _buildSelectRating(context).center(),
          50.height,
          Text('Bình luận', style: boldTextStyle()).paddingAll(16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: radius(8),
                color: appStore.isDarkModeOn
                    ? context.cardColor
                    : Colors.grey.shade200),
            child: TextField(
              controller: _commentController,
              // Attach the controller to the TextField
              decoration: InputDecoration(border: InputBorder.none),
              cursorColor: rf_primaryColor,
              autofocus: true,
              minLines: 5,
              maxLines: 5,
            ),
          ),
          AppButton(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: context.width() - 32,
            color: rf_primaryColor,
            text: 'Gửi đánh giá',
            textStyle: boldTextStyle(color: white),
            onTap: () {
              final comment = _commentController
                  .text; // Get the text from the TextEditingController
              widget.onCreate(rating: rating, comment: comment);
              finish(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildSelectRating(BuildContext context) {
    return RatingBarWidget(
      onRatingChanged: (rating) {
        setState(() {
          this.rating = rating;
        });
      },
      rating: rating,
      allowHalfRating: true,
      itemCount: 5,
      size: 40,
      activeColor: rf_primaryColor,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border_outlined,
    ).center();
  }
}
