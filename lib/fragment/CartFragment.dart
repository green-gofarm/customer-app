import 'package:customer_app/fragment/CartDetailFragment.dart';
import 'package:customer_app/models/all_cart/CartItemModel.dart';
import 'package:customer_app/store/cart/cart_store.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';

class CartFragment extends StatefulWidget {
  @override
  _CartFragmentState createState() => _CartFragmentState();
}

class _CartFragmentState extends State<CartFragment> {
  static final APPBAR_NAME = "Giỏ hàng của bạn";

  final CartStore store = CartStore();
  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      loadingInit = true;
    });

    await _refresh();

    setState(() {
      loadingInit = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _refresh() async {
    await store.getAllCustomerCarts();
    setState(() {});
  }

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
    return appBarWidget(APPBAR_NAME,
        center: true,
        showBack: false,
        color: rf_primaryColor,
        textColor: Colors.white,

        textSize: 18);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color:
          appStore.isDarkModeOn ? context.scaffoldBackgroundColor : mainBgColor,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: _buildListView(context),
          ),
          if (loadingInit)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    final carts = store.allCarts;

    if (carts.length < 1) {
      return Container(
          width: context.width(),
          color: mainBgColor,
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Text(
                  "Chưa có giỏ hàng nào",
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(fontStyle: FontStyle.italic),
                ),
              )
            ],
          ));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: carts.length,
            itemBuilder: (_, i) {
              CartItemModel cart = carts[i];
              return _buildCartItem(context, cart);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 8);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemModel cart) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration:
          boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.farmstayName,
                  style: boldTextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                16.height,
                Row(
                  children: [
                    Icon(Icons.shopping_cart),
                    8.width,
                    Text("${cart.totalCartItem} sản phẩm.")
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            height: 60,
            width: 100,
            child: FadeInImage.assetNetwork(
              placeholder: default_image,
              image: cart.farmstayImages.avatar!,
              fit: BoxFit.cover,
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  default_image,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    ).onTap(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartDetailFragment(
            farmstayId: cart.farmstayId,
            onBack: () {
              logger.i("callback here");
              _refresh();
            },
          ),
        ),
      );
    });
  }
}
