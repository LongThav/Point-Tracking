import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:po_project/logistics/models/po_group_model.dart';

import '../../logistics/models/form_model.dart';
import '../../logistics/models/show_model.dart';
import '../../mains/constants/api_urls.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/logger.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/utils/route/route_name.dart';
import '../models/add_po.dart';
import '../models/po_model.dart';

class PurchaseServiceLogistic extends ChangeNotifier {
  PurchaseOrderModelLogistic _purchaseOrderModelLogistic = PurchaseOrderModelLogistic();
  PurchaseOrderModelLogistic get purchaseOrderModelLOgistic => _purchaseOrderModelLogistic;

  PoGroup _poGroup = PoGroup();
  PoGroup get poGroup => _poGroup;

  List<AddPO> _addPo = [];
  List<AddPO> get addPo => _addPo;

  final NetworkApiService _networkApiService = NetworkApiService();

  FormModel _formModel = FormModel(data: DetailForm());
  FormModel get formModel => _formModel;

  ShowModel _showModel = ShowModel();
  ShowModel get showModel => _showModel;

  String _patenName = '';
  String get patenName => _patenName;

  File? _localFile;
  File? get localFile => _localFile;

  List<int> _patenBytes = [];
  List<int> get patenBytes => _patenBytes;

  String _patenBase64FileStr = '';
  String get patenBase64FileStr => _patenBase64FileStr;

  final _serviceName = 'Location Service';

  Loadingstatus _loadingstatus = Loadingstatus.none;
  Loadingstatus get loadingstatus => _loadingstatus;

  final UserLocalService _userLocalService = UserLocalService();

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  void setLoading() {
    _loadingstatus = Loadingstatus.loading;
    notifyListeners();
  }

  Future<void> readPurchaseOrderLogistic(BuildContext context, {String params = ''}) async {
    try {
      List<dynamic> lists = await _userLocalService.getUser();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      var url = kHost + kPOLogistic + KLogistic + params;
      // '[readPODriver] url:: $url'.log();
      final http.Response response = await _networkApiService.getApiResponse(url, headers: headers);
      // 'Response logistic:: ${response.body}'.log();
      if (response.statusCode == 200) {
        _purchaseOrderModelLogistic = await compute(purchaseOrderModelLogisticFromMap, response.body);
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
      _loadingstatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      notifyListeners();
    }
  }

  void readForm(BuildContext context) async {
    'readFrmDetail called...'.log();
    List<dynamic> lists = await UserLocalService().getUser();
    try {
      const String url = kHost + KFormLogistic;
      "Url read form Logistic::$url".log();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      final http.Response response = await _networkApiService.getApiResponse(url, headers: headers);
      // "Respone Body::${response.body}".log();
      if (response.statusCode == 200) {
        _formModel = await compute(formModelFromMap, response.body);
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
        _errorMsg = 'Unknown error: ${response.statusCode}';
      }
    } catch (error) {
      "Error::$error".log();
      _loadingstatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> readShowDetail(String showid, BuildContext context) async {
    try {
      List<dynamic> lists = await _userLocalService.getUser();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      var url = '$kHost$kPOLogistic/$showid$kShowLogistic';
      "Url::$url".log();
      final http.Response response = await _networkApiService.getApiResponse(url, headers: headers);
      // "Response Logistic Show :: ${response.body}".log();
      if (response.statusCode == 200) {
        _showModel = await compute(ShowModelFromJson, response.body);
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
      'Error Logistic Show ::$error'.log();
      _errorMsg = error.toString();
      _loadingstatus = Loadingstatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> confirmDelivery(String idPo, String deliverId, String note, String poDriver, String street, BuildContext context) async {
    try {
      List<dynamic> lists = await _userLocalService.getUser();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      final Map<String, dynamic> body = {
        'id_po': idPo,
        'delivery_method_id': deliverId,
        'notes_for_driver': note,
        'po_driver': poDriver,
        'po_street': street
      };
      final map = jsonEncode(body);
      "Map::$map".log();

      var url = kHost + KLogistic + KConfirm;
      'Url: $url'.log();

      /// Testing purpose
      // await Future.delayed(const Duration(seconds: 3), () {});
      // _loadingstatus = Loadingstatus.complete;
      // return true;

      http.Response response = await http.put(Uri.parse(url), body: map, headers: headers);
      if (response.statusCode == 200) {
        "Respone successfully".log();

        _loadingstatus = Loadingstatus.complete;
        return true;
      } else if (response.statusCode == 401) {
        ("Error 401").log();
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
        _loadingstatus = Loadingstatus.error;
        _errorMsg = 'Unknown error: ${response.statusCode}';
        return throw Exception('what\'s error');
      }
    } catch (error) {
      'Error Logistic Show ::$error'.log();
      _errorMsg = error.toString();
      _loadingstatus = Loadingstatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> groupDelivery(String idPo, BuildContext context) async {
    '$_serviceName groupDelivery called...'.log();
    try {
      List<dynamic> lists = await _userLocalService.getUser();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${lists[0].data.access_token.toString()}',
      };
      String url = kHost + kPo + kGroupDelivery;
      'url:: $url'.log();

      final Map<String, dynamic> map = {'id_po': idPo};
      final body = jsonEncode(map);

      http.Response response = await http.post(Uri.parse(url), body: body, headers: headers);
      if (response.statusCode == 200) {
        _poGroup = await compute(poGroupFromJson, response.body);
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
      'error: $error'.log();
      _loadingstatus = Loadingstatus.error;
      _errorMsg = error.toString();
    } finally {
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
    return file;
  }

  Future<void> addPO(int id, String poIdName, String poStatus, String poDatetime, String poName, String poPhone, String poDeliveryAddres) async {
    try {
      final newPo = AddPO(
          poIdName: poIdName, poStatus: poStatus, poDate: poDatetime, poContactName: poName, poPhone: poPhone, poDelivery: poDeliveryAddres, id: 0);
      _addPo.add(newPo);
    } catch (error) {
      _loadingstatus = Loadingstatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<List<AddPO>> readPO() async {
    return _addPo;
  }

  void clearPO() {
    return _addPo.clear();
  }
}

PoGroup poGroupFromJson(String str) => PoGroup.fromJson(json.decode(str));
