import 'package:customer_app/main.dart';
import 'package:customer_app/models/user_model.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../store/user/user_store.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const String APPBAR_NAME = "Hồ sơ cá nhân";
  static const String REQUIRED_INFO = "Thông tin bắt buộc";

  final UserStore store = UserStore();
  late UserModel _user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _user = authStore.user!.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => Scaffold(
              appBar: _buildAppbar(context),
              body: _buildBody(),
            ));
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                16.height,
                _buildNameField(),
                16.height,
                _buildFirstNameField(),
                16.height,
                _buildLastNameField(),
                16.height,
                _buildEmailField(),
                16.height,
                _buildPhoneNumberField(),
                16.height,
                _buildGenderField(),
                16.height,
                _buildDateOfBirthField()
              ],
            ),
          ),
        ),
        if (store.isLoading)
          Container(
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  void handleCancel() {
    setState(() {
      _formKey.currentState!.reset();
      _user = authStore.user!.copyWith();
      _isEditing = false;
    });
  }

  void handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isUpdated = await store.updateProfile(_user);

      if (isUpdated) {
        await authStore.signInCustomer(true);
        toast("Cập nhật thành công");
        setState(() {
          _user = authStore.user!.copyWith();
          _isEditing = false;
        });
      } else {
        toast("Cập nhật thất bại");
      }
    }
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return appBarWidget(APPBAR_NAME, showBack: false, textSize: 18, actions: [
      _isEditing
          ? Row(children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: handleCancel,
              ),
              IconButton(
                icon: Icon(Icons.save),
                onPressed: handleSave,
              ),
            ])
          : IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                }
                setState(() {
                  _isEditing = true;
                });
              },
            ),
    ]);
  }

  InputDecoration _buildInputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: _isEditing
            ? rf_primaryColor
            : Colors.grey, // Update label color here
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: _isEditing ? rf_primaryColor : Colors.grey.shade500,
            width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: rf_primaryColor, width: 2.0),
      ),
      border: OutlineInputBorder(),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _user.name,
      enabled: _isEditing,
      decoration: _buildInputDecoration(labelText: 'Tên đầy đủ'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return REQUIRED_INFO;
        }
        return null;
      },
      onSaved: (value) => _user = _user.copyWith(name: value),
    );
  }

  TextFormField _buildFirstNameField() {
    return TextFormField(
      initialValue: _user.firstName,
      enabled: _isEditing,
      decoration: _buildInputDecoration(labelText: 'Tên'),
      validator: (value) {
        return null;
      },
      onSaved: (value) => _user = _user.copyWith(firstName: value),
    );
  }

  TextFormField _buildLastNameField() {
    return TextFormField(
      initialValue: _user.lastName,
      enabled: _isEditing,
      decoration: _buildInputDecoration(labelText: 'Họ'),
      validator: (value) {
        return null;
      },
      onSaved: (value) => _user = _user.copyWith(lastName: value),
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      initialValue: _user.email,
      enabled: _isEditing,
      decoration: _buildInputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return REQUIRED_INFO;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email không hợp lệ';
        }
        return null;
      },
      onSaved: (value) => _user = _user.copyWith(email: value),
    );
  }

  TextFormField _buildPhoneNumberField() {
    return TextFormField(
      initialValue: _user.phoneNumber,
      enabled: _isEditing,
      decoration: _buildInputDecoration(labelText: 'Số điện thoại'),
      keyboardType: TextInputType.phone,
      validator: (value) {
        return null;
      },
      onSaved: (value) => _user = _user.copyWith(phoneNumber: value),
    );
  }

  DropdownButtonFormField<Gender> _buildGenderField() {
    return DropdownButtonFormField<Gender>(
      value: _user.gender,
      isExpanded: true,
      decoration: _buildInputDecoration(labelText: 'Giới tính'),
      items: Gender.values.map<DropdownMenuItem<Gender>>((Gender gender) {
        return DropdownMenuItem<Gender>(
          value: gender,
          child: Text(gender.name),
        );
      }).toList(),
      onChanged: _isEditing
          ? (Gender? newValue) {
              setState(() {
                _user = _user.copyWith(gender: newValue ?? null);
              });
            }
          : null,
    );
  }

  DateTimePicker _buildDateOfBirthField() {
    return DateTimePicker(
      type: DateTimePickerType.date,
      initialValue: _user.dateOfBirth?.toIso8601String() ?? '',
      enabled: _isEditing,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      decoration: _buildInputDecoration(labelText: 'Ngày sinh'),
      validator: (value) {
        return null;
      },
      onChanged: (value) {
        setState(() {
          _user = _user.copyWith(dateOfBirth: DateTime.parse(value));
        });
      },
        locale: Locale('vi'),
    );
  }
}
