import 'package:customer_app/fragment/BookingFragment.dart';
import 'package:customer_app/fragment/CartFragment.dart';
import 'package:customer_app/fragment/HomeFragment.dart';
import 'package:customer_app/fragment/SearchFragment.dart';
import 'package:customer_app/fragment/SettingFragment.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/utils/ICImages.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFImages.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  var _pages = [
    HomeFragment(),
    SearchFragment(),
    CartFragment(),
    BookingFragment(),
    authStore.user != null ? SettingFragment() : SignInScreen(),
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
          icon: ic_home.iconImage(size: 22),
          label: 'Trang chủ',
          activeIcon: ic_fill_home.iconImage(
              color: appStore.isDarkModeOn ? white : rf_primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Tìm kiếm',
          activeIcon: Icon(Icons.search_rounded),
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
                icon: rf_setting.iconImage(size: 22),
                label: 'Cài đặt',
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light);
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
        bottomNavigationBar: _bottomTab(),
        body: Center(child: _pages.elementAt(_selectedIndex)),
      ),
    );
  }
}
