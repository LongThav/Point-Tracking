// ignore_for_file: use_build_context_synchronously

import 'dart:convert' as json;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/route/route_name.dart';
import '../models/view_user_model.dart';
import '../../mains/services/network/network_api_service.dart';
import 'user_local_service.dart';
import '../../mains/utils/logger.dart';

class AuthService with ChangeNotifier {
  final NetworkApiService _networkApiService = NetworkApiService();

  Loadingstatus _loadingstatus = Loadingstatus.none;

  Loadingstatus get loadingstatus => _loadingstatus;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  void loadingStatus() {
    _loadingstatus = Loadingstatus.loading;
    notifyListeners();
  }

  Future<bool> loginApi(Map<String, dynamic> data, BuildContext context) async {
    'loginApi called'.log();
    try {
      final http.Response response = await _networkApiService.postApiResponse(
        kHost + kLogin,
        data,
      );
      _loadingstatus = Loadingstatus.complete;
      'Status code ::${response.statusCode}'.log();

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonString = json.jsonDecode(response.body);
        final user = UserModel.fromJson(jsonString);

        final userPreference = Provider.of<UserLocalService>(context, listen: false);
        userPreference.saveUser(user);
        var role = user.data.role;
        var route = RouteName.checkRole(role);
        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        return true;
      } else {
        if (response.statusCode == 401) {
          'response error: ${response.body}'.log();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please check your username or password again'),
              ),
            );
          }
        } else {
          'response error: ${response.body}'.log();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unknown error, please try again'),
              ),
            );
          }
        }
        return false;
      }
    } catch (e) {
      'loginApi exception::[$e]'.log();
      _errorMsg = e.toString();
      _loadingstatus = Loadingstatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> logOut(BuildContext context) async {
    'logout called'.log();
    try {
      final userLocalService = Provider.of<UserLocalService>(context, listen: false);
      final lists = await userLocalService.getUser(); // getting lists
      final userLocal = lists[0]; // getting user local

      final http.Response response = await _networkApiService.postApiResponse(kHost + kLogout, '{}', headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userLocal.data.access_token}',
      });
      _loadingstatus = Loadingstatus.complete;

      'logOut response::${response.body}'.log();
      final String message = json.jsonDecode(response.body)['message'];
      if (response.statusCode == 200 && message.toString().indexOf('Successfully logged out') > -1) {
        await userLocalService.removeUser();
        return true;
      } else {
        _loadingstatus = Loadingstatus.error;
        return false;
      }
    } catch (e) {
      _loadingstatus = Loadingstatus.error;
      'logout exception::[$e]'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateProfile(Map<String, String> body, BuildContext context) async {
    'updateProfile called'.log();
    try {
      final userLocalService = Provider.of<UserLocalService>(context, listen: false);
      final lists = await userLocalService.getUser(); // getting lists
      final UserModel userLocal = lists[0]; // getting user local
      final http.Response response = await _networkApiService.putApiResponse(kHost + kUpdateProfile, body, headers: {
        'Authorization': 'Bearer ${userLocal.data.access_token}',
      });
      _loadingstatus = Loadingstatus.complete;

      'updateProfile response:[${response.body}]'.log();
      final Map<String, dynamic> result = json.jsonDecode(response.body);

      if (result['code'] == 200 && result['message'].toString().indexOf('User profile updated successfully') > -1) {
        'result avatar_url: ${result['avatar_url']}'.log();

        await userLocalService.updateUser(email: body['email'], name: body['name'], phone: body['phone'], avatarUrl: result['data']['avatar_url']);
        return true;
      } else {
        _loadingstatus = Loadingstatus.error;
        return false;
      }
    } catch (e) {
      _loadingstatus = Loadingstatus.error;
      'updateProfile exception::[$e]'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }
}
