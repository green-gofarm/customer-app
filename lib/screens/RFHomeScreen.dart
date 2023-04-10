import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/fragment/RFAccountFragment.dart';
import 'package:customer_app/fragment/RFHomeFragment.dart';
import 'package:customer_app/fragment/RFSearchFragment.dart';
import 'package:customer_app/fragment/RFSettingsFragment.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFImages.dart';
import 'package:customer_app/utils/RFWidget.dart';

class RFHomeScreen extends StatefulWidget {
  @override
  _RFHomeScreenState createState() => _RFHomeScreenState();
}

class _RFHomeScreenState extends State<RFHomeScreen> {
  int _selectedIndex = 0;

  var _pages = [
    RFHomeFragment(),
    RFSearchFragment(),
    RFSettingsFragment(),
    RFAccountFragment(),
  ];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedLabelStyle: boldTextStyle(size: 14),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 22),
          label: 'Home',
          activeIcon:
              Icon(Icons.home_outlined, color: rf_primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: rf_search.iconImage(),
          label: 'Search',
          activeIcon: rf_search.iconImage(color: rf_primaryColor),
        ),
        BottomNavigationBarItem(
          icon: rf_setting.iconImage(size: 22),
          label: 'Settings',
          activeIcon:
              rf_setting.iconImage(color: rf_primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: rf_person.iconImage(),
          label: 'Account',
          activeIcon: rf_person.iconImage(color: rf_primaryColor),
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
    
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomTab(),
      body: Center(child: _pages.elementAt(_selectedIndex)),
    );
  }
}
