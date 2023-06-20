import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../mains/services/network/api_status.dart';
import '../../mains/utils/logger.dart';
import '../models/view_user_model.dart';

class UserLocalService with ChangeNotifier {
  Loadingstatus _loadingStatus = Loadingstatus.none;
  Loadingstatus get loadingStatus => _loadingStatus;

  // String _errorMsg = '';
  // String get errorMsg => _errorMsg;

  void setLoading() {
    _loadingStatus = Loadingstatus.loading;
    notifyListeners();
  }

  Future<bool> saveUser(UserModel value) async {
    int? expiredTime = value.data.expiresIn;
    String? email = value.data.user!.email;
    String? name = value.data.user!.name;
    String? phone = value.data.user!.phone;
    String? avatarUrl = value.data.user!.avatarUrl;
    int? id = value.data.user?.id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('access_token', value.data.access_token.toString());
    prefs.setString('role', value.data.role.toString());

    DateTime loginTime = DateTime.now(); // create login time
    int loginTimeMilliSeconds = loginTime.millisecondsSinceEpoch;
    prefs.setString('loginTimeMilliSeconds', loginTimeMilliSeconds.toString()); // save loginTime milliseconds to local
    prefs.setString('expiredTime', expiredTime.toString()); // save expiredTime to local

    prefs.setString('email', email.toString());
    prefs.setString('name', name.toString());
    prefs.setString('phone', phone.toString());
    prefs.setString('avatar_url', avatarUrl.toString());
    prefs.setInt('id', id ?? 0);

    notifyListeners();
    return true;
  }

  Future<List<dynamic>> getUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('access_token');
    final String? role = sharedPreferences.getString('role');
    final String? email = sharedPreferences.getString('email');
    final String? name = sharedPreferences.getString('name');
    final String? phone = sharedPreferences.getString('phone');
    final String? avatarUrl = sharedPreferences.getString('avatar_url');
    final int? id = sharedPreferences.getInt('id');

    final user = UserModel(
      data: Data(
        access_token: token.toString(),
        role: role.toString(),
        user: User(
          id: id,
          email: email,
          name: name,
          phone: phone,
          avatarUrl: avatarUrl,
        ),
      ),
    );
    final List<dynamic> lists = [];
    lists.add(user); // lists[0]

    final String? expiredTime = sharedPreferences.getString('expiredTime');
    lists.add(expiredTime); // lists[1]

    final String? loginTimeMilliSeconds = sharedPreferences.getString('loginTimeMilliSeconds');
    lists.add(loginTimeMilliSeconds); // lists[2]

    _loadingStatus = Loadingstatus.complete;
    return lists;
  }

  Future<bool> removeUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('access_token');
    sharedPreferences.remove('role');
    sharedPreferences.remove('loginTimeMilliSeconds');
    sharedPreferences.remove('expiredTime');

    notifyListeners();
    return true;
  }

  Future<bool> updateUser({String? email, String? name, String? phone, String? avatarUrl}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // update the local value
    if (email != null) {
      'email update: $email'.log();
      prefs.setString('email', email.toString());
    }
    if (name != null) {
      'name update: $name'.log();
      prefs.setString('name', name.toString());
    }
    if (phone != null) {
      'phone update: $phone'.log();
      prefs.setString('phone', phone.toString());
    }
    'avatarUrl::$avatarUrl'.log();
    if (avatarUrl != null) {
      'avatar_url: $avatarUrl'.log();
      prefs.setString('avatar_url', avatarUrl.toString());
    }

    notifyListeners();
    return true;
  }
}
