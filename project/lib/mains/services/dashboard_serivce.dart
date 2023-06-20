import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../mains/services/network/network_api_service.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/route/route_name.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/constants/api_urls.dart';
import '../models/dashboard_model.dart';

class DashboardService extends ChangeNotifier {
  DashboardModel _dashboardModel = DashboardModel(data: Data(dashboard: Dashboard()));
  DashboardModel get dashboardModel => _dashboardModel;

  Loadingstatus _loadingstatus = Loadingstatus.none;
  Loadingstatus get loadingstatus => _loadingstatus;

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  void setLoadingDashboard() {
    _loadingstatus = Loadingstatus.loading;
    notifyListeners();
  }

  Future<void> readDashboard(BuildContext context) async {
    try {
      var lists = await UserLocalService().getUser();
      const String url = kHost + kdashboard;
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      final http.Response response = await NetworkApiService().getApiResponse(url, headers: headers);
      _loadingstatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        _dashboardModel = await compute(_parse, response.body);
        _loadingstatus = Loadingstatus.complete;
      }
      // your token is expired, need to login again redirect to sign in page
      else if (response.statusCode == 401) {
        _loadingstatus = Loadingstatus.error;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        _loadingstatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (error) {
      _loadingstatus = Loadingstatus.error;
      _errorMsg = '$error';
    } finally {
      notifyListeners();
    }
  }
}

DashboardModel _parse(String jsonString) {
  return DashboardModel.fromJson(json.decode(jsonString));
}
