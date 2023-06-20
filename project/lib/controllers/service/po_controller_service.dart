import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../mains/utils/logger.dart';
import '../../mains/services/network/api_status.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/utils/route/route_name.dart';
import '../models/product_detail.dart';
import '../models/purchase_order_controller.dart';

class PoControllerService extends ChangeNotifier {
  PurchaseOrderModelController _poModelController = PurchaseOrderModelController();

  PurchaseOrderModelController get poModelController => _poModelController;

  ProductDetailModel _productDetailModel = ProductDetailModel();

  ProductDetailModel get productDetailModel => _productDetailModel;

  Loadingstatus _loadingstatus = Loadingstatus.none;

  Loadingstatus get loadingstatus => _loadingstatus;

  void setLoading() {
    _loadingstatus = Loadingstatus.loading;
    notifyListeners();
  }

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  Future<void> readPoController(BuildContext context, {String params = ''}) async {
    try {
      List<dynamic> lists = await UserLocalService().getUser();
      final String url = kHost + kPOcontroller + kController + params;
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      final http.Response response = await NetworkApiService().getApiResponse(url, headers: headers);
      if (response.statusCode == 200) {
        _poModelController = await compute(_parsejsonController, response.body);
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
      } else {
        _loadingstatus = Loadingstatus.error;
        _errorMsg = 'Unknown Error: ${response.body}';
      }
    } catch (e) {
      _loadingstatus = Loadingstatus.error;
      _errorMsg = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> readDetailPoController(BuildContext context, int id) async {
    'readDetailPoController call'.log();
    try {
      List<dynamic> lists = await UserLocalService().getUser();
      final String url = '$kHost$kPOcontroller/$id$kShow';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      final http.Response response = await NetworkApiService().getApiResponse(url, headers: headers);
      'Url readDetailPoController:: $url'.log();
      if (response.statusCode == 200) {
        _productDetailModel = await compute(_parseDetailjsonController, response.body);
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
      } else {
        _loadingstatus = Loadingstatus.error;
        _errorMsg = 'Unknown Error: ${response.body}';
      }
    } catch (e) {
      _loadingstatus = Loadingstatus.error;
      "Error catch::$e".log();
      _errorMsg = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> confirmDelivery(int id, BuildContext context) async {
    List<dynamic> lists = await UserLocalService().getUser();
    try {
      final url = '$kHost$kPOcontroller/$id$KContrlled';
      "Url::$url".log();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };

      http.Response response = await http.put(Uri.parse(url), headers: headers);
      _loadingstatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        return true;
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
        return false;
      } else {
        _errorMsg = 'Unknown Error: ${response.body}';
        return false;
      }
    } catch (error) {
      _errorMsg = 'Unknown Error: $error';
      return false;
    } finally {
      notifyListeners();
    }
  }
}

PurchaseOrderModelController _parsejsonController(String jsonString) {
  return PurchaseOrderModelController.fromMap(json.decode(jsonString));
}

ProductDetailModel _parseDetailjsonController(String jsonString) {
  return ProductDetailModel.fromMap(json.decode(jsonString));
}
