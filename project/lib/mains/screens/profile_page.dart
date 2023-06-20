import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/services/profile_service.dart';
import '../../auths/models/view_user_model.dart';
import '../../mains/utils/logger.dart';
import '../../auths/services/auth_service.dart';
import '../../mains/constants/colors.dart';
import '../../sales/widgets/common_text_form_field.dart';
import '../../sales/widgets/save_btn.dart';
import '../services/network/api_status.dart';
import '../utils/route/route_name.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtr;
  late final TextEditingController _newPasswordCtr;
  late final TextEditingController _confirmPasswordCtr;

  final FocusNode _nameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  // FocusNode _emailNode = FocusNode();
  // FocusNode _phoneNode = FocusNode();

  String? _avatarUrl;
  File? _imgFile;

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordCtr.text == _confirmPasswordCtr.text) {
        if (_confirmPasswordCtr.text.isNotEmpty && _confirmPasswordCtr.text.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your password must be at least 6 characters long. Please try another.'),
            ),
          );
        } else {
          Map<String, String> data = {};
          data['name'] = _nameCtr.text.toString();

          // update only enter new password & confirm password
          if (_confirmPasswordCtr.text.isNotEmpty) {
            data['password'] = _confirmPasswordCtr.text.toString();
          }

          // checking _imgFile
          if (_imgFile != null) {
            'imgFile path: [${_imgFile!.path}]'.log();
            final String imgExtension = _imgFile!.path.substring(_imgFile!.path.lastIndexOf('.') + 1);
            'imgExtension: $imgExtension'.log();
            List<int> imageBytes = _imgFile!.readAsBytesSync();
            String base64Image = "data:image/$imgExtension;base64,${base64Encode(imageBytes)}";
            data['avatar'] = base64Image;
          }

          context.read<AuthService>().loadingStatus();
          await Future.delayed(const Duration(milliseconds: 500), () {});
          if (!mounted) return;
          final result = await context.read<AuthService>().updateProfile(data, context);
          if (!mounted) return;
          if (result) {
            if (_confirmPasswordCtr.text.isNotEmpty) {
              await Provider.of<AuthService>(context, listen: false).logOut(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update success')));
              await Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update success')));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update fail')));
          }
          if (!mounted) return;
          Navigator.of(context).pop(true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password not match')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameCtr = TextEditingController(text: widget.userModel.data.user?.name);
    _newPasswordCtr = TextEditingController(text: '');
    _confirmPasswordCtr = TextEditingController(text: '');
    _avatarUrl = widget.userModel.data.user?.avatarUrl;
  }

  @override
  void dispose() {
    super.dispose();
    _nameCtr.dispose();
    _newPasswordCtr.dispose();
    _confirmPasswordCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfile(context),
              _buildCardSaleProfile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Text(
            'Profile',
            style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: 22),
          ),
        )
      ],
    );
  }

  Widget _buildCardSaleProfile(BuildContext context) {
    final profileService = context.read<ProfileService>();
    return GestureDetector(
      onTap: () async {
        'Profile click...'.log();
        final files = await profileService.pickImage(context: context);
        if (files.isNotEmpty) {
          final CroppedFile? croppedFiles = await profileService.crop(
            file: files.first,
            cropStyle: CropStyle.rectangle,
          );
          if (croppedFiles != null) {
            setState(() {
              _imgFile = File(croppedFiles.path);
            });
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
        width: double.infinity,
        // height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(85, 75, 186, 0.14),
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ]),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1.7.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCircleAvatar,
              CommonTextFormField(
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _nameNode, _passwordNode);
                },
                focusNode: _nameNode,
                text: 'Name',
                isRequired: true,
                ctr: _nameCtr,
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Input Name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.5.h,
              ),
              CommonTextFormField(
                initialValue: widget.userModel.data.user?.email,
                focusBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                readOnly: true,
                text: 'Email',
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Input Email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.5.h,
              ),
              CommonTextFormField(
                initialValue: widget.userModel.data.user?.phone,
                focusBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                text: 'Phone',
                readOnly: true,
                keyboardType: TextInputType.number,
                hintText: 'Phone',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Input Phone';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.5.h,
              ),
              _buildSecurity,
              SizedBox(
                height: 1.5.h,
              ),
              _frmSave(),
            ],
          ),
        ),
      ),
    );
  }

  get _buildCircleAvatar {
    DecorationImage? decorationImage() {
      DecorationImage? decImg;
      if (_avatarUrl != null) {
        decImg = DecorationImage(image: NetworkImage(_avatarUrl!));
      }
      if (_imgFile != null) {
        decImg = DecorationImage(image: FileImage(_imgFile!));
      }

      return decImg;
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        image: decorationImage(),
      ),
      child: _avatarUrl == null
          ? Center(
              child: Icon(
                Icons.person_outline,
                size: 30,
                color: Colors.grey[600],
              ),
            )
          : null,
    );
  }

  Widget _frmSave() {
    final Loadingstatus loadingstatus = context.watch<AuthService>().loadingstatus;
    if (loadingstatus == Loadingstatus.loading) {
      'Loading'.log();
      return const CircularProgressIndicator();
    }
    return SaveBtn(
      title: "Save",
      onPress: _onSubmitPressed,
    );
  }

  Widget get _buildSecurity {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1.h,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Security',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        CommonTextFormField(
          obSecureText: true,
          obscuringCharacter: '*',
          ctr: _newPasswordCtr,
          hintText: 'Enter new password',
        ),
        SizedBox(
          height: 1.5.h,
        ),
        CommonTextFormField(
          obSecureText: true,
          obscuringCharacter: '*',
          ctr: _confirmPasswordCtr,
          hintText: 'Confirm new password',
        ),
      ],
    );
  }
}
