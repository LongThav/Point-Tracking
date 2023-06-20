import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../mains/services/network/api_status.dart';
import '../../mains/utils/logger.dart';
import '../../sales/models/purchase_order_sale_model.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/utils/route/route_name.dart';
import '../../mains/utils/common.dart';

class PoSaleService extends ChangeNotifier {
  final _serviceName = 'PoSale Service';

  PurchaseOrderSaleModel _purchaseOrderSaleModel = PurchaseOrderSaleModel();
  PurchaseOrderSaleModel get purchaseOrderSaleModel => _purchaseOrderSaleModel;

  Loadingstatus _loadingStatus = Loadingstatus.none;
  Loadingstatus get loadingStatus => _loadingStatus;

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  void setLoading() {
    _loadingStatus = Loadingstatus.loading;
    notifyListeners();
  }

  /// single purchase order
  Data? _singlePurchaseOrder;
  Data? get singlePurchaseOrder => _singlePurchaseOrder;

  final UserLocalService _userLocalService = UserLocalService();

  Future<void> readPOSale(BuildContext context, {String params = ''}) async {
    '_$_serviceName readPOSale called'.log();
    try {
      var lists = await _userLocalService.getUser();

      var url = kHost + kPO + kSales + params;
      'url:: $url'.log();

      var response = await NetworkApiService().getApiResponse(url, headers: getHeaders(lists[0].data.access_token.toString()));
      _loadingStatus = Loadingstatus.complete;

      if (response.statusCode == 200) {
        _purchaseOrderSaleModel = await compute(_parsePoSale, response.body);
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        _errorMsg = response.body;
        "Error Response::$_errorMsg".log();
        _loadingStatus = Loadingstatus.error;
      }
    } catch (error) {
      "Error Response::$error".log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSinglePO({required BuildContext context, required int poID}) async {
    '_$_serviceName getSinglePO called'.log();
    try {
      var lists = await _userLocalService.getUser();

      var url = '$kHost$kPO/$poID/show';
      'url:: $url'.log();

      var response = await NetworkApiService().getApiResponse(url, headers: getHeaders(lists[0].data.access_token.toString()));

      if (response.statusCode == 200) {
        var purchaseOrderSaleModel = await compute(_parsePoSale, response.body);
        if (purchaseOrderSaleModel.data.isEmpty) {
          _errorMsg = 'Unknown Error';
          _loadingStatus = Loadingstatus.error;
          return;
        }

        _singlePurchaseOrder = purchaseOrderSaleModel.data[0];
        _loadingStatus = Loadingstatus.complete;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        _errorMsg = response.body;
        "Error Response::$_errorMsg".log();
        _loadingStatus = Loadingstatus.error;
      }
    } catch (e) {
      _errorMsg = e.toString();
      "Error Response::$_errorMsg".log();
      _loadingStatus = Loadingstatus.error;
    } finally {
      notifyListeners();
    }
  }
}

PurchaseOrderSaleModel _parsePoSale(String jsonString) {
  return PurchaseOrderSaleModel.fromMap(json.decode(jsonString));
}
