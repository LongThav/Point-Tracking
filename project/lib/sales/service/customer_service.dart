import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/common.dart';
import '../../mains/utils/logger.dart';
import '../../sales/models/form_detail_model.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/utils/route/route_name.dart';
import '../models/customer_model.dart';
import '../../sales/models/address_list_model.dart';
import '../../sales/models/contact_model.dart';

class CustomerService extends ChangeNotifier {
  final _serviceName = 'Location Service';
  final NetworkApiService _networkApiService = NetworkApiService();

  /// common required info: userID
  String? _userID;
  String? get userID => _userID;
  void setUserID(String value) {
    _userID = value;
  }

  /// common required info: token
  String? _token;
  String? get token => _token;

  CustomerModel _customerModel = CustomerModel();
  CustomerModel get customerModel => _customerModel;

  FrmDetailModel _frmDetailModel = FrmDetailModel(data: FrmDetail());
  FrmDetailModel get frmDetailModel => _frmDetailModel;

  AddressModel? _addressModel;
  AddressModel? get addressModel => _addressModel;

  List<ContactM>? _listContacts;
  List<ContactM>? get listContacts => _listContacts;
  void setListContacts(List<ContactM>? newValue) {
    _listContacts = newValue;
  }

  String _poNumber = '';
  String get poNumber => _poNumber;
  void setPONumber(String newValue) {
    _poNumber = newValue;
  }

  String _patenName = '';
  String get patenName => _patenName;

  List<int> _patenBytes = [];
  List<int> get patenBytes => _patenBytes;

  String _patenBase64FileStr = '';
  String get patenBase64FileStr => _patenBase64FileStr; // This base64 file can be pdf or images

  File? _localFile;
  File? get localFile => _localFile;

  Loadingstatus _loadingStatus = Loadingstatus.none;
  Loadingstatus get loadingStatus => _loadingStatus;
  void setLoadingStatus(Loadingstatus newValue) {
    _loadingStatus = newValue;
  }

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  void setLoadingCustomerService() {
    _loadingStatus = Loadingstatus.loading;
    notifyListeners();
  }

  Loadingstatus _generatePOStatus = Loadingstatus.none;
  Loadingstatus get generatePOStatus => _generatePOStatus;
  void setLoadingGeneratePOStatus() {
    _generatePOStatus = Loadingstatus.loading;
    notifyListeners();
  }

  /// __init__
  Future<void> init() async {
    List<dynamic> lists = await UserLocalService().getUser();
    var accessToken = lists[0].data.access_token.toString();
    // 'token: $accessToken'.log();

    _token = accessToken;

    var userIdCache = lists[0].data.user.id.toString();
    // 'userId: $userIdCache'.log();

    _userID = userIdCache;
  }

  Future<void> readCustomerService(BuildContext context) async {
    '$_serviceName readCustomerService called...'.log();
    try {
      var url = kHost + kCustomer;
      'url: $url'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var response = await NetworkApiService().getApiResponse(url, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        _customerModel = await compute(_parsedJsonCustomer, response.body);
        "$_serviceName Response success".log();
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await UserLocalService().removeUser();
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        "Log Error::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Unknown Error: ${response.body}';
      }
    } catch (error) {
      '$_serviceName readCustomerService error: $error'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      '$_serviceName readCustomerService finally'.log();
      notifyListeners();
    }
  }

  Future<void> readLocation(BuildContext context, String customerID) async {
    '$_serviceName readLocation call...'.log();
    try {
      _addressModel = null;

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var url = '$kHost$kCustomer/$customerID$kAddress';
      'url: $url'.log();

      var response = await _networkApiService.getApiResponse(url, headers: getHeaders(_token!));
      'status code ::${response.statusCode}'.log();

      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        _addressModel = await compute(_parsedJsonLocation, response.body);
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        "error::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (error) {
      "$_serviceName readLocation error: $error".log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = errorMsg.toString();
    } finally {
      '$_serviceName readLocation finally'.log();
      notifyListeners();
    }
  }

  Future<void> readFrmDetail(BuildContext context) async {
    '$_serviceName readFrmDetail called...'.log();
    try {
      var url = kHost + kFormDetail;
      'url: url'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var response = await _networkApiService.getApiResponse(url, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        _frmDetailModel = await compute(_parsedFrmJson, response.body);
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (error) {
      '$_serviceName readFrmDetail error: $error'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      '$_serviceName readFrmDetail finally'.log();
      notifyListeners();
    }
  }

  Future<bool> createCustomer(BuildContext context, Map<String, dynamic> map, Function(Customer? data) callback) async {
    '$_serviceName createCustomer called...'.log();
    try {
      _loadingStatus = Loadingstatus.loading;
      var body = json.encode(map);
      'body: body'.log();

      var url = kHost + kCustomer;
      'url: $url'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var response = await _networkApiService.postApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonString = json.decode(response.body)['data'];
        final Customer customer = Customer.fromJson(jsonString);
        callback(customer);
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        callback(null);
        return false;
      } else {
        _loadingStatus = Loadingstatus.error;
        callback(null);
        return throw Exception('Error : ${response.body}');
      }
    } catch (e) {
      _loadingStatus = Loadingstatus.error;
      '$_serviceName createCustomer error: $e'.log();
      callback(null);
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName createCustomer finally'.log();
      notifyListeners();
    }
  }

  Future<bool> createContacts(BuildContext context, Map<String, dynamic> map) async {
    '$_serviceName createContacts called...'.log();
    try {
      var body = json.encode(map);
      'body : $body'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var url = "$kHost$kCustomer/${_userID!}$kContact";
      'url: $url'.log();

      final http.Response response = await _networkApiService.postApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        "Create Contact successfully::${response.statusCode}".log();
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        return false;
      } else {
        _loadingStatus = Loadingstatus.error;
        return throw Exception('Error : ${response.body}');
      }
    } catch (e) {
      "$_serviceName createContacts Error::$e".log();
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName createContacts finally'.log();
      notifyListeners();
    }
  }

  Future<bool> createLocation(BuildContext context, Map<String, dynamic> map) async {
    '$_serviceName createLocation called...'.log();
    try {
      var body = json.encode(map);
      'body: $body'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var url = "$kHost$kCustomer/$_userID$kAddress";
      'url: $url'.log();

      var response = await _networkApiService.postApiResponse(url, body, headers: getHeaders(_token!));
      "Response Body:: ${response.body}".log();

      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        "success response".log();
        "Create Contact successfully::${response.statusCode}".log();
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _loadingStatus = Loadingstatus.error;
        return false;
      } else {
        _loadingStatus = Loadingstatus.error;
        return throw Exception('Error : ${response.body}');
      }
    } catch (e) {
      "$_serviceName createLocation Error::$e".log();
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName createLocation finally'.log();
      notifyListeners();
    }
  }

  Future<bool> updateCustomer(BuildContext context, Map<String, dynamic> map, int customerId, Function(Map<String, dynamic>) callback) async {
    '$_serviceName updateCustomer called...'.log();
    try {
      setLoadingCustomerService();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      final body = json.encode(map);
      'body: $body'.log();

      var url = "$kHost$kCustomer/$customerId";
      'url: $url'.log();

      final http.Response response = await _networkApiService.putApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResult = json.decode(response.body);
        final Map<String, String> data = {
          'paten_file': jsonResult['data']['paten_file'],
        };
        callback(data);
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.pop(context);
        });
        return false;
      } else {
        _loadingStatus = Loadingstatus.error;
        return false;
      }
    } catch (e) {
      '$_serviceName updateCustomer error: $e'.log();
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName updateCustomer finally'.log();
      notifyListeners();
    }
  }

  /// PDF helper: loadNetwork
  Future<File> loadNetwork(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  /// PDF helper: loadAsset
  Future<File> loadAsset(String patenName, List<int> patenFile) {
    return _storeFile(patenName, patenFile);
  }

  /// PDF helper: storeFile
  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);

    notifyListeners();
    return file;
  }

  Future<void> readContact(BuildContext context, String customerID) async {
    '$_serviceName readContact called...'.log();
    try {
      _listContacts = null;

      // if (_token == null) {
      //   await init();
      // }
      await init();

      final String url = '$kHost$kCustomer/$customerID$kContact';
      'url: $url'.log();

      var response = await _networkApiService.getApiResponse(url, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        _listContacts = [];
        _listContacts = await compute(_parsedJsonContact, response.body);
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
      } else {
        "Log Error::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (error) {
      "Response Error::$error".log();
      '$_serviceName readContact error: $error'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      '$_serviceName readContact finally'.log();
      notifyListeners();
    }
  }

  Future<bool> updateContact(BuildContext context, Map<String, dynamic> map, int contactId) async {
    '$_serviceName updateContact called...'.log();
    try {
      final body = json.encode(map);
      'request body::$body'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      //{{URL}}/api/customer/3/contact/17
      final url = '$kHost$kCustomer/$_userID$kContact/$contactId';
      http.Response response = await _networkApiService.putApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      'Response::${response.body}'.log();
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _loadingStatus = Loadingstatus.error;
        return false;
      } else {
        "_serviceName updateContact Response Body::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        return false;
      }
    } catch (e) {
      '$_serviceName updateContact error: $e'.log();
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName updateContact called...'.log();
      notifyListeners();
    }
  }

  Future<bool> updateLocation(BuildContext context, Map<String, dynamic> map, int addressId) async {
    '$_serviceName updateLocation called...'.log();
    try {
      setLoadingCustomerService();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      final url = '$kHost$kCustomer/$_userID$kAddress/$addressId';
      'url: $url'.log();

      final body = json.encode(map);
      var response = await _networkApiService.putApiResponse(url, body, headers: getHeaders(_token!));
      'Response Body::${response.body}'.log();

      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        "update successs!!".log();
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _loadingStatus = Loadingstatus.error;
        return false;
      } else {
        "Other Error::${response.statusCode}".log();
        _loadingStatus = Loadingstatus.error;
        return false;
      }
    } catch (e) {
      "$_serviceName updateLocation error: $e".log();
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName updateLocation finally'.log();
      notifyListeners();
    }
  }

  Future<void> getPatenBase64String(BuildContext context) async {
    '$_serviceName getPatenBase64String called...'.log();
    try {
      /// Processing Upload Paten File or Photo File as Base64 String
      'upload Paten File tapped...'.log();
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'png', 'jpg', 'pdf'],
        // allowedExtensions: ['png', 'pdf'],
      );
      // if no file is picked
      if (result == null) return;

      // we will log the name, size and path of the
      'name: ${result.files.first.name}'.log();
      'size: ${result.files.first.size}'.log();
      'path: ${result.files.first.path}'.log();

      _patenName = result.files.first.name;

      final filePath = result.files.first.path.toString(); // filePath
      final int fileSize = result.files.first.size; // file size
      final String fileName = result.files.first.name; // file name
      final String fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1);
      'fileExtension: $fileExtension'.log();

      var patenFile = File(filePath);
      _localFile = patenFile;

      /// handle the image file upload ~= 1MB only
      if (fileExtension != 'pdf') {
        final double totalSize = fileSize / 1000; // 1000 bytes => 1KB
        if (totalSize / 1000 > 1) {
          // 1000 KB => 1MB
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The file is large, please choose other image...'),
              ),
            );
          }
          return;
        } else {
          /// handle image processing ...
          final List<int> imageBytes = patenFile.readAsBytesSync();
          _patenBytes = imageBytes;
          _patenBase64FileStr = "data:image/$fileExtension;base64,${base64Encode(imageBytes)}";
        }
      } else {
        /// handle pdf's size upload ~= 1MB only
        var totalSize = fileSize / 1000;
        if (totalSize / 1000 > 1) {
          // 1000 KB => 1MB
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The file is large, please choose other image...'),
              ),
            );
          }
          return;
        }

        /// handling pdf processing
        final List<int> pdfBytes = patenFile.readAsBytesSync();
        _patenBytes = pdfBytes;
        _patenBase64FileStr = "data:@file/pdf;base64,${base64Encode(pdfBytes)}";
      }
    } catch (e) {
      '$_serviceName getPatenBase64String exception: $e'.log();
    } finally {
      '$_serviceName getPatenBase64String finally'.log();
    }
  }

  Future<String> generatePONumber(BuildContext context) async {
    try {
      '$_serviceName generatePONumber called'.log();
      // if (_token == null) {
      //   await init();
      // }
      await init();

      /// For testing purpose
      // var responseMap = '{"code":200,"message":"PO number generated successfully!","data":{"po_number":"POID000009"}}';
      // var resultJson = jsonDecode(responseMap);
      // var poNumber = resultJson['data']['po_number'];
      // 'po number:: $poNumber'.log();
      // _poNumber = poNumber;
      // _generatePOStatus = Loadingstatus.complete;
      // return poNumber;
      /// end testing

      // {{URL}}/api/po/number
      var response = await _networkApiService.getApiResponse('$kHost/po/number', headers: getHeaders(_token!));
      _generatePOStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        'success :: ${response.body}'.log();
        var resultJson = jsonDecode(response.body);
        var poNumber = resultJson['data']['po_number'];
        'po number:: $poNumber'.log();

        _poNumber = poNumber;
        return poNumber;
      } else if (response.statusCode == 401) {
        _generatePOStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _generatePOStatus = Loadingstatus.error;
        return '';
      } else {
        _generatePOStatus = Loadingstatus.error;
        _errorMsg = 'Exception ${response.body}';
        return '';
      }
    } catch (e) {
      '$_serviceName generatePONumber error: $e'.log();
      _errorMsg = 'Exception $e';
      _generatePOStatus = Loadingstatus.error;
      return '';
    } finally {
      '$_serviceName generatePONumber finally'.log();
      notifyListeners();
    }
  }

  Future<bool> createNewPO(BuildContext context, Map<String, dynamic> postData) async {
    '$_serviceName createNewPO called'.log();
    try {
      postData['products'] = json.encode(postData['products']);
      final body = json.encode(postData);
      'request body::$body'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      //{{URL}}/api/po/new
      var url = '$kHost/po/new';
      'url: url'.log();

      var response = await _networkApiService.postApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      'Response body:: ${response.body}'.log();

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is end...'),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _loadingStatus = Loadingstatus.error;
        return false;
      } else {
        "$_serviceName createNewPO Response Body Error::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        // _errorMsg = 'Exception ${response.body}';
        return false;
      }
    } catch (e) {
      "$_serviceName createNewPO Error::$e".log();
      _loadingStatus = Loadingstatus.error;
      return false;
    } finally {
      '$_serviceName createNewPO finally'.log();
      notifyListeners();
    }
  }

  /// update po general: {{URL}}/api/po/10/update-general
  Future<bool> updateGeneral({
    required BuildContext context,
    required Map<String, dynamic> postData,
    required int poID,
  }) async {
    '$_serviceName updateGeneral called'.log();
    try {
      final body = json.encode(postData);
      'request body::$body'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var url = '$kHost/po/$poID/update-general';
      'url: url'.log();

      var response = await _networkApiService.putApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      'Response body:: ${response.body}'.log();

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _loadingStatus = Loadingstatus.error;
        return false;
      } else {
        "$_serviceName updateGeneral Response Body Error::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Exception ${response.body}';
        return false;
      }
    } catch (e) {
      "$_serviceName updateGeneral Error::$e".log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'Exception $e';
      return false;
    } finally {
      '$_serviceName updateGeneral finally'.log();
      notifyListeners();
    }
  }

  /// update po products: {{URL}}/api/po/10/update-products
  Future<bool> updateProducts({
    required BuildContext context,
    required Map<String, dynamic> postData,
    required int poID,
  }) async {
    '$_serviceName updateProducts called'.log();
    try {
      postData['products'] = json.encode(postData['products']);
      final body = json.encode(postData);
      'request body::$body'.log();

      // if (_token == null) {
      //   await init();
      // }
      await init();

      var url = '$kHost/po/$poID/update-products';
      'url: url'.log();

      var response = await _networkApiService.putApiResponse(url, body, headers: getHeaders(_token!));
      _loadingStatus = Loadingstatus.complete;
      'Response body:: ${response.body}'.log();

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _loadingStatus = Loadingstatus.error;

        /// set token to null
        _token = null;
        await Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your session is end...')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (Route<dynamic> route) => false);
        });
        _loadingStatus = Loadingstatus.error;
        return false;
      } else {
        "$_serviceName updateProducts Response Body Error::${response.body}".log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'Exception ${response.body}';
        return false;
      }
    } catch (e) {
      "$_serviceName updateProducts Error::$e".log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'Exception $e';
      return false;
    } finally {
      '$_serviceName updateProducts finally'.log();
      notifyListeners();
    }
  }
}

CustomerModel _parsedJsonCustomer(String jsonString) {
  return CustomerModel.fromJson(json.decode(jsonString));
}

FrmDetailModel _parsedFrmJson(String jsonString) {
  return FrmDetailModel.fromJson(json.decode(jsonString));
}

AddressModel _parsedJsonLocation(String jsonString) {
  return AddressModel.fromJson(json.decode(jsonString));
}

List<ContactM> _parsedJsonContact(String jsonString) {
  return ContactModel.fromJson(json.decode(jsonString)).data;
}
