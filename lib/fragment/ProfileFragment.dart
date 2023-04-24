import 'package:customer_app/main.dart';
import 'package:customer_app/models/user_model.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/screens/UserProfileScreen.dart';
import 'package:customer_app/store/user/user_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/SHImages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  UserStore store = UserStore();

  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = authStore.user!.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) => Scaffold(body: _buildBody()));
  }

  Widget _buildBody() {
    return Stack(
      children: [
        if (store.isLoading)
          Container(
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        Container(
          padding: EdgeInsets.all(12.0),
          height: context.height(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(user),
                _buildActionCard(
                  iconData: Icons.account_circle,
                  title: "Hồ sơ cá nhân",
                  onTap: () {
                    UserProfileScreen().launch(context);
                  },
                ),
                _buildActionCard(
                  iconData: Icons.logout,
                  title: "Đăng xuất",
                  onTap: () async {
                    final isConfirmed = await _showDialog(context);
                    if (isConfirmed) {
                      await authStore.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Column(
      children: [
        SizedBox(height: 30),
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 8,
                  margin: EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  child: CircleAvatar(
                    backgroundImage: _getProfileImage(user.avatar),
                    radius: 55,
                  ).paddingAll(4),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.0),
                margin: EdgeInsets.only(bottom: 30, right: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.cardColor,
                  border: Border.all(color: Colors.grey.shade500, width: 1),
                ),
                child: Icon(Icons.camera_alt, color: Colors.black, size: 20),
              ).onTap(() async {
                String? imageSource = await _showImagePickerDialog(context);
                if (imageSource != null) {
                  _pickImage(imageSource);
                }
              })
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(user.name ?? "NO_NAME", style: boldTextStyle()),
        SizedBox(height: 8),
        Text(user.email ?? "NO_EMAIL", style: secondaryTextStyle()),
      ],
    );
  }

  Future<void> _pickImage(String source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = null;

    try {
      if (source == 'gallery') {
        image = await _picker.pickImage(source: ImageSource.gallery);
      } else if (source == 'camera') {
        image = await _picker.pickImage(source: ImageSource.camera);
      }

      if (image != null) {
        logger.i('Image path: ${image.path}');
        final isUpdated = await store.updateAvatar(image);

        if (isUpdated) {
          toast("Cập nhật thành công");
          await authStore.signInCustomer(true);
          setState(() {
            if(authStore.user != null) {
              user = authStore.user!.copyWith();
            }
          });
        } else {
          toast("Cập nhật thất bại");
        }
      } else {
        logger.e('No image selected');
      }
    } catch (error) {
      logger.e('Error picking image: $error');
    }
  }

  ImageProvider _getProfileImage(String? imageUrl) {
    if (imageUrl == null) {
      return Image.asset(
        ic_user,
        fit: BoxFit.cover,
      ).image;
    }

    return FadeInImage.assetNetwork(
      placeholder: default_image,
      image: imageUrl,
      fit: BoxFit.cover,
      height: 170,
      width: context.width() - 32,
      imageErrorBuilder: (_, __, ___) {
        return Image.asset(
          default_image,
          fit: BoxFit.cover,
        );
      },
    ).image;
  }

  Widget _buildActionCard(
      {required IconData iconData,
      required String title,
      required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: Offset(0.0, 1.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(iconData, size: 23, color: rf_primaryColor),
          SizedBox(width: 8),
          Expanded(child: Text(title, style: secondaryTextStyle())),
        ],
      ),
    ).onTap(onTap);
  }

  Future<bool> _showDialog(BuildContext parentContext) async {
    const String ACTION_TITLE = 'Đăng xuất';
    const String ACTION_MESSAGE =
        "Xác nhận muốn đăng xuất khỏi tài khoản hiện tại?";
    const String ACTION_CANCEL = 'Suy nghĩ lại';
    const String ACTION_OK = 'OK';

    bool result = false;

    final removeAction = CustomTheme(
      child: CupertinoActionSheet(
        title: Text(
          ACTION_TITLE,
          style: boldTextStyle(size: 18),
        ),
        message: Text(
          ACTION_MESSAGE,
          style: secondaryTextStyle(),
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, true); // Return false when canceled
              },
              child: Text(ACTION_OK, style: primaryTextStyle(size: 18)))
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, false); // Return false when canceled
            },
            child: Text(
              ACTION_CANCEL,
              style: primaryTextStyle(color: redColor, size: 18),
            )),
      ),
    );

    await showCupertinoModalPopup<bool>(
            context: context, builder: (_) => removeAction)
        .then((value) => result = value is bool ? value : false);

    return result;
  }

  Future<String?> _showImagePickerDialog(BuildContext context) async {
    const String ACTION_TITLE = 'Chọn hình avatar';
    const String ACTION_GALLERY_MESSAGE = "Bộ sưu tập";
    const String ACTION_CAMERA_MESSAGE = 'Camera';
    const String ACTION_CANCEL = 'Hủy';

    String? result;

    final imagePickerAction = CustomTheme(
      child: CupertinoActionSheet(
        title: Text(
          ACTION_TITLE,
          style: boldTextStyle(size: 18),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, 'gallery');
            },
            child:
                Text(ACTION_GALLERY_MESSAGE, style: primaryTextStyle(size: 18)),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, 'camera');
            },
            child:
                Text(ACTION_CAMERA_MESSAGE, style: primaryTextStyle(size: 18)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(
            ACTION_CANCEL,
            style: primaryTextStyle(color: redColor, size: 18),
          ),
        ),
      ),
    );

    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => imagePickerAction,
    ).then((value) => result = value);

    return result;
  }
}
