import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../auths/services/auth_service.dart';
import '../../auths/widgets/login_button.dart';
import '../constants/colors.dart';
import '../constants/logo.dart';
import '../../mains/services/network/api_status.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _passwordObscure = true;

  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  final GlobalKey<FormState> _signInKey = GlobalKey<FormState>();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _init() {
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _onSubmitPressed() async {
    if (_signInKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'email': _emailCtrl.text,
        'password': _passwordCtrl.text,
      };
      context.read<AuthService>().loadingStatus();
      await Future.delayed(const Duration(milliseconds: 500), () {});
      if (!mounted) return;
      await context.read<AuthService>().loginApi(data, context);
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
      bottomNavigationBar: _buildVersion,
    );
  }

  Widget get _buildBody {
    return Form(
      key: _signInKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.appBarColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSignInText(),
              _buildBlockBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInText() {
    return Container(
      margin: EdgeInsets.only(top: 1.8.h, left: 2.h),
      alignment: Alignment.topLeft,
      child: const Text(
        'Sign in',
        style: TextStyle(fontFamily: 'Poppins_Bold', fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.iconColor),
      ),
    );
  }

  Widget _buildBlockBody() {
    return Expanded(
      flex: 5,
      child: Container(
        margin: EdgeInsets.only(top: 2.5.h),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLogo(),
            _frmUserName(),
            _fromPassword(),
            Flexible(child: _buildButtonRounded()),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0.h, bottom: 6.h),
      width: 132.48,
      height: 67.3,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Logo.logo), fit: BoxFit.fill),
      ),
    );
  }

  Widget _frmUserName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      width: MediaQuery.of(context).size.width,
      height: 44,
      child: TextFormField(
        focusNode: _userNameFocusNode,
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _userNameFocusNode, _passwordFocusNode);
        },
        validator: (input) {
          if (input == null || input.isEmpty) {
            return 'Please enter Username';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Username',
          labelStyle: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.87),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.email,
              color: Color(0XFF828282),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fromPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
      width: MediaQuery.of(context).size.width,
      height: 44,
      child: TextFormField(
        focusNode: _passwordFocusNode,
        obscureText: _passwordObscure,
        obscuringCharacter: '*',
        keyboardType: TextInputType.text,
        controller: _passwordCtrl,
        validator: (input) {
          if (input == null || input.isEmpty) {
            return 'Please enter Password';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontWeight: FontWeight.w500, color: Color(0XFFCACACA)),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordObscure ? Icons.lock : Icons.lock,
              color: _passwordObscure ? const Color(0XFFCACACA) : const Color(0XFF343434),
            ),
            onPressed: () {
              setState(() {
                _passwordObscure = !_passwordObscure;
              });
            },
          ),
          labelText: 'Password',
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          labelStyle: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.87),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        onFieldSubmitted: (value) async {
          await _onSubmitPressed();
        },
      ),
    );
  }

  Widget _buildButtonRounded() {
    final Loadingstatus loadingStatus = context.watch<AuthService>().loadingstatus;
    bool loading = loadingStatus == Loadingstatus.loading ? true : false;
    return RoundButton(title: 'Sign in', loading: loading, onPress: _onSubmitPressed);
  }

  Material get _buildVersion {
    return Material(
      elevation: 0.0,
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: const SizedBox(
            child: Text(
          'Version 1.0',
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
