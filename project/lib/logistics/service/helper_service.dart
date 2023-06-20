import 'package:flutter/material.dart';
import 'package:po_project/logistics/models/add_po.dart';
import 'package:uuid/uuid.dart';

import '../db_helper/db_helper_logistic.dart';
import '../models/helper_model.dart';
import 'package:po_project/mains/services/network/api_status.dart';
import 'package:po_project/mains/utils/logger.dart';

class DBHelperLogisticService extends ChangeNotifier {
  List<HelperLogisticModel> _product = [];
  List<HelperLogisticModel> get product => _product;

  Loadingstatus _loadingStatus = Loadingstatus.none;
  Loadingstatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = Loadingstatus.loading;
    notifyListeners();
  }

  void readProduct() async {
    try {
      final productItem = await DBHelperLogistic.showProduct();
      _product = productItem
          .map((pro) => HelperLogisticModel(
              id: pro['id'],
              poIdName: pro['poIdName'],
              poDateTime: pro['poDateTime'],
              poStatus: pro['poStatus'],
              poName: pro['poName'],
              poPhone: pro['poPhone'],
              poDeliveryAddress: pro['poDeliveryAddress']))
          .toList();
      _loadingStatus = Loadingstatus.complete;
    } catch (error) {
      'Error: $error'.log();
      _loadingStatus = Loadingstatus.error;
    } finally {
      notifyListeners();
    }
  }

  void addProduct(String poIdName, String poStatus, String poDatetime, String poName, String poPhone, String poDeliveryAddress) async {
    try {
      final newProduct = HelperLogisticModel(
          id: const Uuid().v1(),
          poIdName: poIdName,
          poStatus: poStatus,
          poDateTime: poDatetime,
          poName: poName,
          poPhone: poPhone,
          poDeliveryAddress: poDeliveryAddress);
      _product.add(newProduct);
      await DBHelperLogistic.insert(DBHelperLogistic.product, {
        'id': newProduct.id,
        'poIdName': newProduct.poIdName,
        'poDateTime': newProduct.poDateTime,
        'poStatus': newProduct.poStatus,
        'poName': newProduct.poName,
        'poPhone': newProduct.poPhone,
        'poDeliveryAddress': newProduct.poDeliveryAddress
      });
      "Add product Successfully".log();
    } catch (error) {
      'Add Product Error :$error'.log();
      _loadingStatus = Loadingstatus.error;
    } finally {
      notifyListeners();
    }
  }

  void deleteProById(pickId) async {
    await DBHelperLogistic.deletedById(DBHelperLogistic.product, 'id', pickId);
    notifyListeners();
  }
}
