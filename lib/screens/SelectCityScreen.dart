import 'package:customer_app/main.dart';
import 'package:customer_app/models/address_model.dart';
import 'package:customer_app/screens/SelectHashtagScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/StorageUtil.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({Key? key}) : super(key: key);

  @override
  _SelectCityScreenState createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  static const String CityImageUrl =
      "https://assets.iqonic.design/old-themeforest-images/prokit/images/eventApp/london.jpg";

  List<ProvinceModel> filteredProvinces = [];
  Set<int> selectedCities = {};

  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() => loadingInit = true);

    await _refresh();
    List<ProvinceModel> storedCities = await StorageUtil.getCities();

    setState(() {
      loadingInit = false;
      filteredProvinces = List.from(provinceStore.provinces);
      selectedCities = storedCities.map((city) => city.code).toSet();
    });
  }

  Future<void> _refresh() async {
    await provinceStore.getProvinces();
  }

  void filterProvinces(String query) {
    List<ProvinceModel> tempList = [];

    if (query.isEmpty) {
      tempList = List.from(provinceStore.provinces);
    } else {
      provinceStore.provinces.forEach((province) {
        if (province.name.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(province);
        }
      });
    }

    setState(() {
      filteredProvinces = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => SafeArea(
              child: Scaffold(
                appBar: _buildAppbar(context),
                body: _buildBody(context),
              ),
            ));
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      "Bạn muốn đi đâu?".toUpperCase(),
      center: false,
      showBack: false,
      color: rf_primaryColor,
      textColor: Colors.white,
      textSize: 16,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutePaths.HOME.value, (route) => false);
          },
          icon: Text("Bỏ"),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _buildRefreshIndicator(context),
              ),
              _buildButtonContainer(context),
            ],
          ),
          if (loadingInit) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  RefreshIndicator _buildRefreshIndicator(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchField(),
            _buildCityList(context),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Container _buildSearchField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: boxDecorationWithShadow(
          backgroundColor: context.cardColor,
          shadowColor: grey.withOpacity(0.3)),
      child: TextFormField(
        onChanged: (value) => filterProvinces(value),
        style: primaryTextStyle(),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.search, color: Colors.grey, size: 24)),
          hintText: 'Tìm tên thành phố',
          hintStyle: primaryTextStyle(),
        ),
      ),
    );
  }

  Widget _buildCityList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 16,
        spacing: 16,
        children: List.generate(
          filteredProvinces.length,
          (index) => _buildCityItem(context, index),
        ),
      ),
    );
  }

  Widget _buildCityItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          int? provinceCode = filteredProvinces[index].code;
          if (selectedCities.contains(provinceCode)) {
            selectedCities.remove(provinceCode);
          } else {
            selectedCities.add(provinceCode);
          }
        });
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCityImage(context, index),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child:
                  Text(filteredProvinces[index].name, style: boldTextStyle()),
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildCityImage(BuildContext context, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCityImageContent(context, index),
        _buildCityImageOverlay(context, index),
        _buildCityImageIcon(index),
      ],
    );
  }

  ClipRRect _buildCityImageContent(BuildContext context, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FadeInImage.assetNetwork(
        placeholder: default_image,
        image: CityImageUrl,
        fit: BoxFit.cover,
        height: 250,
        width: context.width() * 0.43,
        imageErrorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset(
            default_image,
            fit: BoxFit.cover,
            height: 250,
            width: context.width() * 0.43,
          );
        },
      ),
    );
  }

  Container _buildCityImageOverlay(BuildContext context, int index) {
    int? provinceCode = filteredProvinces[index].code;
    return Container(
      height: 250,
      width: context.width() * 0.43,
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(8),
        gradient: selectedCities.contains(provinceCode)
            ? LinearGradient(colors: [
                rf_primaryColor.withOpacity(0.4),
                rf_primaryColor.withOpacity(0.4)
              ])
            : LinearGradient(colors: [transparentColor, transparentColor]),
      ),
    );
  }

  Icon _buildCityImageIcon(int index) {
    return Icon(Icons.check_circle_outline,
        size: 30,
        color: selectedCities.contains(filteredProvinces[index].code)
            ? white
            : transparentColor);
  }

  Container _buildLoadingIndicator() {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<ProvinceModel> getSelectedCityNames() {
    return selectedCities.map((cityCode) {
      return provinceStore.provinces
          .firstWhere((province) => province.code == cityCode);
    }).toList();
  }

  Widget _buildButtonContainer(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildClearAllButton(context),
                16.width,
                _buildNextButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearAllButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCities.clear();
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: context.width() * 0.43,
        // Update width
        height: 50,
        decoration: boxDecorationWithShadow(
            borderRadius: radius(8),
            gradient: LinearGradient(colors: [
              Colors.redAccent.withOpacity(0.8),
              Colors.redAccent.withOpacity(0.8)
            ])),
        child: Text('Bỏ chọn (${selectedCities.length})'.toUpperCase(),
            style: boldTextStyle(color: white, size: 18)),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        List<ProvinceModel> cities = getSelectedCityNames();
        await StorageUtil.storeCities(cities);
        SelectHashtagScreen().launch(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: context.width() * 0.43,
        // Update width
        height: 50,
        decoration: boxDecorationWithShadow(
            borderRadius: radius(8),
            gradient:
                LinearGradient(colors: [rf_primaryColor, rf_primaryColor])),
        child: Text('Tiếp theo'.toUpperCase(),
            style: boldTextStyle(color: white, size: 18)),
      ),
    );
  }
}
