import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../mains/utils/common.dart';
import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/utils/logger.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/utils/route/route_name.dart';
import '../db/pocart_database.dart';
import '../models/form_model.dart' as form_model;
import '../models/products_item.dart';

class ProductItemService extends ChangeNotifier {
  final _serviceName = 'ProductItemService';

  /// Product Cart From Api store only temporary
  ProductModelList _productCartFromApi = ProductModelList();
  ProductModelList get productCartFromApi => _productCartFromApi;

  /// Main products is POCARTS
  final ProductModelList _pocarts = ProductModelList();
  ProductModelList get pocarts => _pocarts;

  /// Form Model
  form_model.FormModel? _formModel;
  form_model.FormModel? get formModel => _formModel;

  /// tmpListCartsUpdate
  List<Data>? _tmpListCartsUpdate;
  List<Data>? get tmpListCartsUpdate => _tmpListCartsUpdate;
  void setTmpListCartsUpdate(List<Data>? newValue) {
    _tmpListCartsUpdate = newValue;
  }

  Loadingstatus _loadingStatus = Loadingstatus.none;
  Loadingstatus get loadingStatus => _loadingStatus;

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  final NetworkApiService _networkApiService = NetworkApiService();

  void setLoading() {
    _loadingStatus = Loadingstatus.loading;
    notifyListeners();
  }

  Future<void> readFromLocalStorage() async {
    '[readFromLocalStorage] called...'.log();

    _loadingStatus = Loadingstatus.loading;

    var tmpLists = <Data>[];
    var lists = await POCARTDatabase.instance.readAll();
    var productsLocal = <Data>[];
    int totalItem = 0;
    double subTotal = 0;
    if (lists.isNotEmpty) {
      'local storage lists is not empty'.log();
      productsLocal = lists[0];

      if (_pocarts.data.isEmpty) {
        totalItem = lists[1];
        subTotal = lists[2];
      } else {
        totalItem = getUpdateTotalItem();
        subTotal = getUpdateSubTotal();
      }
      'totalItem : $totalItem'.log();
      'subTotal: $subTotal'.log();
    }
    var products = productCartFromApi.data;
    if (productsLocal.isNotEmpty && products.isNotEmpty) {
      for (int i = 0; i < productsLocal.length; i++) {
        for (int j = 0; j < products.length; j++) {
          if (productsLocal[i].id == products[j].id) {
            products[j].quantity = productsLocal[i].quantity;
            'product quantity from local storage: ${products[j].quantity}'.log();

            products[j].price = productsLocal[i].price;
            'product price from local storage: ${products[j].price}'.log();

            products[j].total = products[j].price * products[j].quantity;
            'product total: ${products[j].total}'.log();

            for (int k = 0; k < products[j].packages.length; k++) {
              if (products[j].packages[k].id == productsLocal[i].packages[0].id) {
                'found package ID local storage: ${products[j].packages[k].id}'.log();
                products[j].packages[k].isDefault = 1;
              } else {
                products[j].packages[k].isDefault = 0;
              }
            }

            tmpLists.add(products[j]);
          }
        }
      }
    }

    _pocarts.data = tmpLists;
    _pocarts.totalItem = totalItem;
    _pocarts.subTotal = subTotal;
    _loadingStatus = Loadingstatus.complete;
    notifyListeners();
  }

  Future<void> updateFromLocalStorage({
    required Data updatePOCART,
    required int packageId,
  }) async {
    '[updateFromLocalStorage] called...'.log();

    'updatePOCART: $updatePOCART'.log();
    'packageId: $packageId'.log();
    'price: ${updatePOCART.price}'.log();
    'total: ${updatePOCART.total}'.log();

    int totalItem = _pocarts.totalItem;
    'totalItem: $totalItem'.log();

    double subTotal = _pocarts.subTotal;
    'subTotal: $subTotal'.log();

    final int response =
        await POCARTDatabase.instance.update(updatePOCART: updatePOCART, packageId: packageId, totalItem: totalItem, subTotal: subTotal);
    'update response status : [$response]'.log();
    notifyListeners();
  }

  Future<bool> deleteProductCart({required int productId}) async {
    '[deleteProductCart] called...'.log();
    try {
      _pocarts.data.removeWhere((product) => product.id == productId);
      _pocarts.totalItem--;
      'totalItem : [${_pocarts.totalItem}]'.log();

      _pocarts.subTotal--;
      'subTotal : [${_pocarts.subTotal}]'.log();

      // delete from local storage using id
      final int response = await POCARTDatabase.instance.delete(productId);

      // success return 1 otherwise failed 0
      'delete response status : [$response]'.log();

      if (response == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      'deleteProductCart exception:: $e'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deleteAllProducts() async {
    '[deleteAllProducts] called...'.log();
    try {
      // delete from local storage using id
      final int response = await POCARTDatabase.instance.deleteAll();

      // success return 1 otherwise failed 0
      'delete response status : [$response]'.log();

      if (response == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      'deleteAllProducts exception:: $e'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> readProductList(BuildContext context, {String params = ''}) async {
    '[readProductList] called...'.log();
    var lists = await UserLocalService().getUser();
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      var url = kHost + kproductList + params;
      'url:: $url'.log();
      http.Response response = await NetworkApiService().getApiResponse(url, headers: headers);
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        _productCartFromApi = await compute(_parsedJson, response.body);
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (e) {
      'readProductList exception: [$e]'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'Unknown error: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> addProductToCart({
    required Data newProduct,
    required int packageId,
  }) async {
    '[addProductToCart] called...'.log();
    'packageId:: $packageId'.log();
    'price:: ${newProduct.price}'.log();
    'total:: ${newProduct.total}'.log();

    int totalItem = 0;
    double subTotal = 0;
    if (_pocarts.data.isEmpty) {
      'Product Cart not exist...'.log();

      _pocarts.data = [];
      _pocarts.data.add(newProduct);

      _pocarts.totalItem++;
      totalItem = _pocarts.totalItem;
      'totalItem:: $totalItem'.log();

      _pocarts.subTotal = newProduct.total;
      subTotal = _pocarts.subTotal;
      'subTotal:: $subTotal'.log();

      // save to local
      POCARTDatabase.instance.create(
        pocart: newProduct,
        packageSelectId: packageId,
        totalItem: totalItem,
        subTotal: subTotal,
      );
    } else {
      var listProductsCart = pocarts.data;

      _pocarts.totalItem++;
      totalItem = _pocarts.totalItem;
      'totalItem2:: $totalItem'.log();

      var priceUpdate = newProduct.quantity * newProduct.price;
      'price update:: $priceUpdate'.log();

      newProduct.total = priceUpdate;

      _pocarts.subTotal += newProduct.total;
      subTotal = _pocarts.subTotal;
      'subTotal2:: $subTotal'.log();

      var foundProductCart = false;
      var foundIndex = 0;
      for (int i = 0; i < listProductsCart.length; i++) {
        if (listProductsCart[i].id == newProduct.id) {
          foundProductCart = true;
          foundIndex = i;
          break;
        }
      }

      // if the cart already have -> then increment the counter only
      if (foundProductCart) {
        'Product Cart exist...'.log();
        'increment quantity...'.log();
        // update lists of data
        listProductsCart[foundIndex].quantity++;

        // update to local
        POCARTDatabase.instance.update(
          updatePOCART: listProductsCart[foundIndex],
          packageId: packageId,
          totalItem: totalItem,
          subTotal: subTotal,
        );
      } else {
        'Product Cart not exist II...'.log();
        listProductsCart.add(newProduct);

        // save to local
        POCARTDatabase.instance.create(
          pocart: newProduct,
          packageSelectId: packageId,
          totalItem: totalItem,
          subTotal: subTotal,
        );
      }
    }

    notifyListeners();
  }

  Data getPOCARTByID(int pocartID) {
    '[getPOCARTByID] called...'.log();

    late Data findPOCart;
    var listProductsCart = _pocarts.data;
    for (int i = 0; i < listProductsCart.length; i++) {
      if (listProductsCart[i].id == pocartID) {
        findPOCart = listProductsCart[i];
        break;
      }
    }
    'findPOCART: ${findPOCart.total}'.log();
    return findPOCart;
  }

  double getPriceFromApi(int pocartID) {
    'getPriceFromApi called...'.log();
    var foundProduct = _productCartFromApi.data.firstWhere((item) => item.id == pocartID);
    return foundProduct.price;
  }

  Future<void> updatePOCart(Data pocart, {int? quantity}) async {
    '[updatePOCart] called...'.log();
    if (quantity != null) {
      var priceUpdate = quantity * pocart.price;
      'priceUpdate: $priceUpdate'.log();

      pocart.total = priceUpdate;
    }

    _pocarts.subTotal = getUpdateSubTotal();
    '_pocarts subTotal update :: ${_pocarts.subTotal}'.log();

    var listProductsCart = _pocarts.data;

    for (int i = 0; i < listProductsCart.length; i++) {
      if (listProductsCart[i].id == pocart.id) {
        listProductsCart[i] = pocart;
        'POCART update:: ${listProductsCart[i]}'.log();

        var packageId = 0;
        if (listProductsCart[i].packages.isNotEmpty) {
          packageId = listProductsCart[i].packages.firstWhere((package) => package.isDefault == 1).id;
        }

        // update local storage
        await updateFromLocalStorage(updatePOCART: listProductsCart[i], packageId: packageId);
        break;
      }
    }

    notifyListeners();
  }

  Future<void> onSelectedPackage(
      {required BuildContext context,
      required Package selectedPackage,
      required Data productCart,
      required int totalItem,
      required double subTotal}) async {
    'selected package: $selectedPackage'.log();

    for (int i = 0; i < productCart.packages.length; i++) {
      if (productCart.packages[i].id == selectedPackage.id) {
        productCart.packages[i].isDefault = 1;
        int packageId = productCart.packages[i].id;
        var updatePOCART = productCart;
        await POCARTDatabase.instance.update(updatePOCART: updatePOCART, packageId: packageId, totalItem: totalItem, subTotal: subTotal);
      } else {
        productCart.packages[i].isDefault = 0;
      }
    }

    notifyListeners();
  }

  void incrementPOCART({required BuildContext context, required Data selectedPOCART}) {
    'incrementPOCART called...'.log();

    selectedPOCART.quantity++;
    var quantity = selectedPOCART.quantity;
    'quantity update: ${selectedPOCART.quantity}'.log();

    _pocarts.totalItem++;
    'totalItem update: ${_pocarts.totalItem}'.log();

    var priceUpdate = quantity * selectedPOCART.price;
    'price increment update:: $priceUpdate'.log();

    selectedPOCART.total = priceUpdate;

    // if (_pocarts.data.length == 1) {
    //   _pocarts.subTotal = selectedPOCART.total;
    // } else {
    //   _pocarts.subTotal += selectedPOCART.total;
    // }
    // 'subTotal increment update:: ${_pocarts.subTotal}'.log();

    context.read<ProductItemService>().updatePOCart(selectedPOCART);
  }

  void decrementPOCART({required BuildContext context, required Data selectedPOCART}) {
    'decrementPOCART called...'.log();

    selectedPOCART.quantity--;
    'quantity: ${selectedPOCART.quantity}'.log();

    _pocarts.totalItem--;
    'totalItem update: ${_pocarts.totalItem}'.log();

    var priceUpdate = selectedPOCART.total - selectedPOCART.price;
    'price decrement update:: $priceUpdate'.log();

    selectedPOCART.total = priceUpdate;

    // _pocarts.subTotal -= selectedPOCART.total;
    // 'subTotal decrement update:: ${_pocarts.subTotal}'.log();

    context.read<ProductItemService>().updatePOCart(selectedPOCART);
  }

  int getUpdateTotalItem() {
    var lists = List<int>.from(_pocarts.data.map((element) => element.quantity));
    var sum = lists.sum;
    return sum;
  }

  double getUpdateSubTotal() {
    'pocarts data:: ${_pocarts.data}'.log();
    var lists = List<double>.from(_pocarts.data.map((element) => element.total));
    var total = lists.reduce((acc, initial) => acc + initial);
    return total;
  }

  Future<void> getPOForm(BuildContext context) async {
    '[ProductItemService] getPOForm called...'.log();
    try {
      var lists = await UserLocalService().getUser();
      var response = await _networkApiService.getApiResponse('$kHost/po/form', headers: getHeaders(lists[0].data.access_token.toString()));
      _loadingStatus = Loadingstatus.complete;
      'response:: ${response.statusCode}'.log();

      if (response.statusCode == 200) {
        _formModel = form_model.FormModel.fromJson(json.decode(response.body));
      } else {
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (e) {
      '[ProductItemService] getPOForm exception: [$e]'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'Unknown error: $e';
    } finally {
      '[ProudctItemService] getPOForm finally'.log();
      notifyListeners();
    }
  }

  /// get temporary of update list carts
  Future<List<Data>?> getTmpUpdateListCarts() async {
    '$_serviceName getTmpUpdateListCarts called...'.log();
    try {
      await Future.delayed(const Duration(seconds: 1), () {});
      _loadingStatus = Loadingstatus.complete;
      return _tmpListCartsUpdate;
    } catch (e) {
      '$_serviceName getTmpUpdateListCarts exception: [$e]'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'Unknown error: $e';
      return null;
    } finally {
      '$_serviceName getTmpUpdateListCarts finally'.log();
      notifyListeners();
    }
  }
}

ProductModelList _parsedJson(dynamic jsonString) {
  return ProductModelList.fromJson(json.decode(jsonString));
}
