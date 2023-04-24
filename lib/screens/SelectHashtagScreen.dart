import 'package:customer_app/main.dart';
import 'package:customer_app/models/tag_category_model.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/StorageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectHashtagScreen extends StatefulWidget {
  const SelectHashtagScreen({Key? key}) : super(key: key);

  @override
  _SelectHashtagScreenState createState() => _SelectHashtagScreenState();
}

class _SelectHashtagScreenState extends State<SelectHashtagScreen> {
  Set<int> selectedTagIds = {};
  bool loadingInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() => loadingInit = true);

    List<TagCategoryModel> selectedTags = await StorageUtil.getHashtags();
    selectedTagIds = selectedTags.map((tag) => tag.id).toSet();

    await _refresh();
    setState(() {
      loadingInit = false;
    });
  }

  Future<void> _refresh() async {
    await tagCategoryStore.getListCategories();
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
      "Chọn #hashtag".toUpperCase(),
      center: false,
      showBack: false,
      color: rf_primaryColor,
      textColor: Colors.white,
      textSize: 16,
      actions: [
        IconButton(
          onPressed: () {
            HomeScreen().launch(context);
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
            _buildCityList(context),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Padding _buildCityList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 12,
        spacing: 16,
        children: List.generate(
          tagCategoryStore.categories.length,
          (index) => _buildHashTagItem(context, index),
        ),
      ),
    );
  }

  Widget _buildHashTagItem(BuildContext context, int index) {
    int? id = tagCategoryStore.categories[index].id;
    return GestureDetector(
        onTap: () {
          setState(() {
            if (selectedTagIds.contains(id)) {
              selectedTagIds.remove(id);
            } else {
              selectedTagIds.add(id);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecorationRoundedWithShadow(16,
              backgroundColor: selectedTagIds.contains(id)
                  ? rf_primaryColor
                  : appStore.isDarkModeOn
                      ? cardDarkColor
                      : white),
          child: Text(
            tagCategoryStore.categories[index].name,
            style: primaryTextStyle(
                color: selectedTagIds.contains(id)
                    ? white
                    : appStore.isDarkModeOn
                        ? white
                        : black),
          ),
        ));
  }

  Container _buildLoadingIndicator() {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
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
                SizedBox(width: 16),
                _buildNextButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TagCategoryModel> getSelectedTags() {
    return selectedTagIds.map((id) {
      return tagCategoryStore.categories
          .firstWhere((province) => province.id == id);
    }).toList();
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        List<TagCategoryModel> tags = getSelectedTags();
        await StorageUtil.storeHashtags(tags);
        HomeScreen().launch(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: context.width() * 0.43,
        height: 50,
        decoration: boxDecorationWithShadow(
            borderRadius: radius(8),
            gradient:
                LinearGradient(colors: [rf_primaryColor, rf_primaryColor])),
        child: Text('Hoàn tất'.toUpperCase(),
            style: boldTextStyle(color: white, size: 18)),
      ),
    );
  }

  Widget _buildClearAllButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTagIds.clear();
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: context.width() * 0.43,
        height: 50,
        decoration: boxDecorationWithShadow(
            borderRadius: radius(8),
            gradient: LinearGradient(colors: [
              Colors.redAccent.withOpacity(0.8),
              Colors.redAccent.withOpacity(0.8)
            ])),
        child: Text('Bỏ chọn (${selectedTagIds.length})'.toUpperCase(),
            style: boldTextStyle(color: white, size: 18)),
      ),
    );
  }
}
