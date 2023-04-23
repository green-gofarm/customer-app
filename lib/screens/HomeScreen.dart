import 'package:customer_app/fragment/BookingFragment.dart';
import 'package:customer_app/fragment/CartFragment.dart';
import 'package:customer_app/fragment/HomeFragment.dart';
import 'package:customer_app/fragment/NotificationFragment.dart';
import 'package:customer_app/fragment/ProfileFragment.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/utils/ICImages.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  final int? selectedIndex;

  HomeScreen({this.selectedIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final int HOME_ITEM_INDEX = 0;

  int _selectedIndex = HOME_ITEM_INDEX;

  final _pages = [
    HomeFragment(),
    NotificationFragment(),
    CartFragment(),
    BookingFragment(),
    authStore.user != null ? ProfileFragment() : null,
  ];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedLabelStyle: boldTextStyle(size: 11),
      selectedItemColor: appStore.isDarkModeOn ? white : rf_primaryColor,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
          activeIcon: ic_fill_home.iconImage(
              color: appStore.isDarkModeOn ? white : rf_primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Thông báo',
          activeIcon: Icon(Icons.notifications),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Giỏ hàng',
          activeIcon: Icon(Icons.shopping_cart),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_outlined),
          label: 'Đơn hàng',
          activeIcon: Icon(Icons.receipt_rounded),
        ),
        authStore.user != null
            ? BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Tài khoản',
                activeIcon: ic_fill_profile.iconImage(
                    color: appStore.isDarkModeOn ? white : rf_primaryColor,
                    size: 22),
              )
            : BottomNavigationBarItem(
                icon: Icon(Icons.login),
                label: 'Đăng nhập',
                activeIcon: Icon(Icons.login_rounded),
              ),
      ],
    );
  }

  void _onItemTapped(int index) {
    if (index != HOME_ITEM_INDEX && authStore.user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.selectedIndex != null) {
      setState(() {
        _selectedIndex = widget.selectedIndex!;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: "Nhấn lại để thoát",
      child: Scaffold(
        body: Center(child: _pages.elementAt(_selectedIndex)),
        bottomNavigationBar: _bottomTab(),
      ),
    );
  }
}
