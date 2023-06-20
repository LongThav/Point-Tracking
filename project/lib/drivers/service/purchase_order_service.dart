import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../mains/utils/common.dart';
import '../../mains/utils/logger.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/utils/route/route_name.dart';
import '../models/purchase_order_driver.dart';

class PurchaseOrderDriverService extends ChangeNotifier {
  PurchaseOrderModelDriver _purchaseOrderModelDriver = PurchaseOrderModelDriver();
  PurchaseOrderModelDriver get purchaseOrderModelDriver => _purchaseOrderModelDriver;

  Loadingstatus _loadingstatus = Loadingstatus.none;
  Loadingstatus get loadingstatus => _loadingstatus;

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  void setLoading() {
    _loadingstatus = Loadingstatus.loading;
    notifyListeners();
  }

  final UserLocalService _userLocalService = UserLocalService();

  Future<void> readPODriver(BuildContext context, {String params = ''}) async {
    try {
      List<dynamic> lists = await _userLocalService.getUser();

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      var url = kHost + kPO + kDelivery + params;
      '[readPODriver] url:: $url'.log();
      final http.Response response = await NetworkApiService().getApiResponse(url, headers: headers);
      "Respone::${response.body}".log();
      if (response.statusCode == 200) {
        _purchaseOrderModelDriver = await compute(_parsedPoDriver, response.body);
        _loadingstatus = Loadingstatus.complete;
      } else if (response.statusCode == 401) {
        _loadingstatus = Loadingstatus.error;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      }
    } catch (error) {
      "Error Respone::$error".log();
      _loadingstatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> uploadImage(Map<String, String> map, int productId, BuildContext context) async {
    '[uploadImage] called...'.log();
    try {
      List<dynamic> lists = await _userLocalService.getUser();
      final body = json.encode(map);
      'url: ${'$kHost$kPO/$productId$kDelivered'}'.log();

      http.Response response = await http.put(
        Uri.parse('$kHost$kPO/$productId$kDelivered'),
        body: body,
        headers: getHeaders(lists[0].data.access_token.toString()),
      );
      _loadingstatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _loadingstatus = Loadingstatus.error;
        "false Response".log();
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        return false;
      } else {
        "Other Response::${response.statusCode}".log();
        return false;
      }
    } catch (error) {
      "Error statusCode::$error".log();
      return false;
    } finally {
      notifyListeners();
    }
  }
}

PurchaseOrderModelDriver _parsedPoDriver(String jsonString) {
  return PurchaseOrderModelDriver.fromMap(json.decode(jsonString));
}
