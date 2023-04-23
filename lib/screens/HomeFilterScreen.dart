import 'package:customer_app/main.dart';
import 'package:customer_app/models/address_model.dart';
import 'package:customer_app/models/tag_category_model.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/StorageUtil.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeFilterScreen extends StatefulWidget {
  const HomeFilterScreen({Key? key}) : super(key: key);

  @override
  _HomeFilterScreenState createState() => _HomeFilterScreenState();
}

class _HomeFilterScreenState extends State<HomeFilterScreen> {
  Set<int> selectedCities = {};
  Set<int> selectedTagIds = {};
  List<ProvinceModel> filteredProvinces = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await _refresh();

    List<ProvinceModel> storedCities = await StorageUtil.getCities();
    List<TagCategoryModel> selectedTags = await StorageUtil.getHashtags();

    setState(() {
      filteredProvinces = List.from(provinceStore.provinces);
      selectedTagIds = selectedTags.map((tag) => tag.id).toSet();
      selectedCities = storedCities.map((city) => city.code).toSet();
    });
  }

  Future<void> _refresh() async {
    await provinceStore.getProvinces();
    await tagCategoryStore.getListCategories();
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
    return Scaffold(
      appBar: _buildAppbar(context),
      bottomNavigationBar: _buildBottom(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Địa điểm', style: boldTextStyle())
                .paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
            _buildSearchField(),
            8.height,
            _buildSelectCities(context),
            16.height,
            Text('#Hashtag', style: boldTextStyle())
                .paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
            _buildSelectTags(context),
            16.height,
          ],
        ),
      ),
    );
  }

  Container _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        alignment: Alignment.center,
        decoration: boxDecorationWithShadow(
            borderRadius: BorderRadius.circular(4),
            backgroundColor: context.cardColor,
            shadowColor: grey.withOpacity(0.2)),
        child: TextFormField(
          onChanged: (value) => filterProvinces(value),
          style: primaryTextStyle(),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.search, color: Colors.grey, size: 24)),
            hintText: 'Tìm tên tỉnh thành',
            hintStyle: primaryTextStyle(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(
      "Yêu thích",
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

  List<TagCategoryModel> getSelectedTags() {
    return selectedTagIds.map((id) {
      return tagCategoryStore.categories
          .firstWhere((province) => province.id == id);
    }).toList();
  }

  List<ProvinceModel> getSelectedCityNames() {
    return selectedCities.map((cityCode) {
      return provinceStore.provinces
          .firstWhere((province) => province.code == cityCode);
    }).toList();
  }

  Widget _buildBottom() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      width: context.width(),
      height: 50,
      decoration: boxDecorationWithShadow(
        borderRadius: radius(24),
        gradient: LinearGradient(colors: [rf_primaryColor, rf_primaryColor]),
      ),
      child: Text('Tìm kiếm'.toUpperCase(),
          style: primaryTextStyle(color: white, size: 16)),
    ).onTap(
      () async {
        await StorageUtil.storeCities(getSelectedCityNames());
        await StorageUtil.storeHashtags(getSelectedTags());
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.HOME.value, (route) => false);
      },
    );
  }

  Widget _buildSelectCities(BuildContext context) {
    return HorizontalList(
      itemCount: filteredProvinces.length,
      itemBuilder: (context, i) {
        final province = filteredProvinces[i];

        return Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecorationRoundedWithShadow(16,
              backgroundColor: selectedCities.contains(province.code)
                  ? rf_primaryColor
                  : appStore.isDarkModeOn
                      ? cardDarkColor
                      : white),
          child: Text(
            province.name,
            style: primaryTextStyle(
                color: selectedCities.contains(province.code)
                    ? white
                    : appStore.isDarkModeOn
                        ? white
                        : black),
          ),
        ).onTap(
          () {
            setState(() {
              if (selectedCities.contains(province.code)) {
                selectedCities.remove(province.code);
              } else {
                selectedCities.add(province.code);
              }
            });
          },
        );
      },
    );
  }

  Widget _buildSelectTags(BuildContext context) {
    return HorizontalList(
        itemCount: tagCategoryStore.categories.length,
        itemBuilder: (context, i) {
          final category = tagCategoryStore.categories[i];

          return Container(
            padding: EdgeInsets.all(8),
            decoration: boxDecorationRoundedWithShadow(16,
                backgroundColor: selectedTagIds.contains(category.id)
                    ? rf_primaryColor
                    : appStore.isDarkModeOn
                        ? cardDarkColor
                        : white),
            child: Text(
              category.name,
              style: primaryTextStyle(
                  color: selectedTagIds.contains(category.id)
                      ? white
                      : appStore.isDarkModeOn
                          ? white
                          : black),
            ),
          ).onTap(() {
            setState(() {
              if (selectedTagIds.contains(category.id)) {
                selectedTagIds.remove(category.id);
              } else {
                selectedTagIds.add(category.id);
              }
            });
          });
        });
  }
}
