import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import '../../mains/constants/colors.dart';
import '../../mains/utils/common.dart';
import '../../mains/services/network/network_api_service.dart';
import '../../mains/constants/api_urls.dart';
import '../../mains/utils/logger.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/route/route_name.dart';
import '../models/address_list_model.dart';
import '../screens/customer/pin_location_page.dart';
import '../../auths/services/user_local_service.dart';

class LocationService extends ChangeNotifier {
  final _serviceName = 'Location Service';
  final NetworkApiService _networkApiService = NetworkApiService();

  int? _userID;
  int? get userID => _userID;
  void setUserID(int value) {
    _userID = value;
  }

  int _type = 0;
  int get type => _type;
  void setType(int value) {
    _type = value;
  }

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  Loadingstatus _loadingStatus = Loadingstatus.none;
  Loadingstatus get loadingStatus => _loadingStatus;
  void setLoadingStatus(Loadingstatus newValue) {
    _loadingStatus = newValue;
  }

  void setLoadingLocationService() {
    _loadingStatus = Loadingstatus.loading;
    notifyListeners();
  }

  /// temporary address
  Address? _tmpAddress;
  Address? get tmpAddress => _tmpAddress;
  void setTmpAddress(Address? value) {
    _tmpAddress = value;
  }

  /// temporary address status
  Loadingstatus _tmpAddressStatus = Loadingstatus.none;
  Loadingstatus get tmpAddressStatus => _tmpAddressStatus;
  void setTmpAddressStatus() {
    _tmpAddressStatus = Loadingstatus.loading;
    notifyListeners();
  }

  /// show dialog: to enable location and allowed app access location
  Future<void> _showCustomAlert({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmTitle,
    required VoidCallback onConfirmPressed,
  }) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // if user deny again, we do nothing
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appBarColor,
            ),
            onPressed: onConfirmPressed,
            child: Text(confirmTitle),
          ),
        ],
      ),
    );
  }

  /// update select address
  Future<void> updateSelectedAddress() async {
    setTmpAddressStatus();
    await Future.delayed(const Duration(milliseconds: 100), () {});
    _tmpAddressStatus = Loadingstatus.complete;
  }

  /// pin location(type: 0)
  Future<bool> pinLocationAddress(BuildContext context, Map<String, dynamic> requestBody) async {
    '$_serviceName pinLocation called...'.log();
    try {
      List<dynamic> lists = await UserLocalService().getUser();

      var userId = lists[0].data.user.id;
      'userId: $userId'.log();

      final body = json.encode(requestBody);
      'body : $body'.log();

      // {{URL}}/api/customer/userId/pin
      var url = '$kHost$kCustomer/$userId/pin';
      'url: $url'.log();

      var response = await _networkApiService.postApiResponse(url, body, headers: getHeaders(lists[0].data.access_token.toString()));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        return true;
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
        return false;
      } else {
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'exception ${response.body}';
        return false;
      }
    } catch (e) {
      '$_serviceName pinLocation exception: $e'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'exception $e';
      return false;
    } finally {
      '$_serviceName pinLocation finally'.log();
      notifyListeners();
    }
  }

  /// post location(type: 1)
  Future<bool> postLocationAddress(BuildContext context, Map<String, dynamic> requestBody) async {
    '$_serviceName postLocationAddress called...'.log();
    try {
      List<dynamic> lists = await UserLocalService().getUser();
      var body = json.encode(requestBody);
      'body : $body'.log();

      var userId = lists[0].data.user.id;
      'userId: $userId'.log();

      // {{URL}}/api/customer/6/address
      final url = '$kHost$kCustomer/$userId/address';
      'url: $url'.log();

      await Future.delayed(const Duration(seconds: 3), () {});
      _loadingStatus = Loadingstatus.complete;

      /// I comment for temporary - Testing purpose
      // var res =
      //     "{\"id\":38,\"home_address\":\"#25\",\"street\":\"Street 186\",\"sangkat\":{\"id\":40,\"name\":\"Tuek L'ak II\"},\"khan\":{\"id\":3,\"name\":\"Tuol Kouk\"},\"province\":{\"id\":2,\"name\":\"Phnom Penh\"},\"log\":\"11.5633219\",\"lat\":\"104.8956266\",\"is_main\":0,\"type\":\"Direct\"}";
      // _tmpAddress = Address.fromJson(jsonDecode(res));
      // return true;

      var response = await _networkApiService.postApiResponse(url, body, headers: getHeaders(lists[0].data.access_token.toString()));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        var tmpLists = List<dynamic>.from(jsonDecode(response.body)["data"]).map((address) => Address.fromJson(address)).toList();
        _tmpAddress = tmpLists[tmpLists.length - 1];
        return true;
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
        return false;
      } else {
        'error: ${response.body}'.log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'exception ${response.body}';
        return false;
      }
    } catch (e) {
      '$_serviceName postLocationAddress exception: $e'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'exception $e';
      return false;
    } finally {
      '$_serviceName postLocationAddress finally'.log();
      notifyListeners();
    }
  }

  /// update location(type: 2)
  Future<bool> updateLocationAddress(BuildContext context, Map<String, dynamic> requestBody, int addressID) async {
    '$_serviceName updateLocationAddress called...'.log();
    try {
      List<dynamic> lists = await UserLocalService().getUser();
      var body = json.encode(requestBody);
      'body: $body'.log();

      var userId = lists[0].data.user.id;
      'userId: $userId'.log();

      // {{URL}}/api/customer/6/address/35
      final url = '$kHost$kCustomer/$userId/address/$addressID';
      'url: $url'.log();

      var response = await _networkApiService.putApiResponse(url, body, headers: getHeaders(lists[0].data.access_token.toString()));
      _loadingStatus = Loadingstatus.complete;
      if (response.statusCode == 200) {
        return true;
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
        return false;
      } else {
        'error: ${response.body}'.log();
        _loadingStatus = Loadingstatus.error;
        _errorMsg = 'exception ${response.body}';
        return false;
      }
    } catch (e) {
      '$_serviceName updateLocationAddress exception: $e'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = 'exception $e';
      return false;
    } finally {
      '$_serviceName updateLocationAddress finally'.log();
      notifyListeners();
    }
  }

  /// get the position latlng
  Future<Position?> _determinePosition(BuildContext context) async {
    // Test if location services are enabled.
    var serviceEnable = await Geolocator.isLocationServiceEnabled();
    'serviceEnable status: [$serviceEnable]'.log();

    if (serviceEnable) {
      var permission = await Geolocator.checkPermission();
      'permission status: [$permission]'.log();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        'retry request permission status: [$permission]'.log();

        if (permission == LocationPermission.deniedForever) {
          if (context.mounted) {
            await _showCustomAlert(
                context: context,
                title: 'Allow your location',
                content: 'You need to allow location in permission for the app',
                confirmTitle: 'Open App Settings',
                onConfirmPressed: () async {
                  await Geolocator.openAppSettings().then((_) {
                    Navigator.of(context).pop();
                  });
                });
          }
        }
        return null;
      } else if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          await _showCustomAlert(
              context: context,
              title: 'Allow your location',
              content: 'You need to allow location in permission for the app',
              confirmTitle: 'Open App Settings',
              onConfirmPressed: () async {
                await Geolocator.openLocationSettings().then((_) {
                  Navigator.of(context).pop();
                });
              });
        }
        return null;
      } else {
        setLoadingLocationService();

        // When we reach here, permissions are granted and we can
        // continue accessing the position of the device.
        var currPos = await Geolocator.getCurrentPosition();
        await Future.delayed(const Duration(milliseconds: 100));
        _loadingStatus = Loadingstatus.complete;

        return currPos;
      }
    } else {
      if (context.mounted) {
        await _showCustomAlert(
            context: context,
            title: 'Location Service not enabled',
            content: 'Please enable location service in settings',
            confirmTitle: 'Open Location Settings',
            onConfirmPressed: () async {
              await Geolocator.openLocationSettings().then((_) {
                Navigator.of(context).pop();
              });
            });
      }
      return null;
    }
  }

  /// On Pin Delivery Location Tapped
  Future<void> onPinDeliveryLocationTap(BuildContext context) async {
    '$_serviceName onPinDeliveryLocationTap called'.log();
    try {
      var position = await _determinePosition(context);
      'position: [$position]'.log();

      if (position != null && context.mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PinLocationPage(
              title: 'Delivery Location',
              latitude: position.latitude,
              longitude: position.longitude,
              userId: _userID!,
              type: _type,
              addressType: 'Direct',
            ),
          ),
        );
      }
    } catch (e) {
      '$_serviceName onPinDeliveryLocationTap error:: $e'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = e.toString();
    } finally {
      '$_serviceName onPinDeliveryLocationTap finally'.log();
      notifyListeners();
    }
  }

  /// verify all the permission before access google map
  Future<bool?> verifyAppAccess(BuildContext context) async {
    '$_serviceName verifyAppAccess called'.log();
    try {
      // Test if location services are enabled.
      var serviceEnable = await Geolocator.isLocationServiceEnabled();
      'serviceEnable status: [$serviceEnable]'.log();

      if (serviceEnable) {
        var permission = await Geolocator.checkPermission();
        'permission status: [$permission]'.log();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          'retry request permission status: [$permission]'.log();

          if (permission == LocationPermission.deniedForever) {
            if (context.mounted) {
              await _showCustomAlert(
                  context: context,
                  title: 'Allow your location',
                  content: 'You need to allow location in permission for the app',
                  confirmTitle: 'Open App Settings',
                  onConfirmPressed: () async {
                    await Geolocator.openAppSettings().then((_) {
                      Navigator.of(context).pop();
                    });
                  });
            }
          }

          return null;
        } else if (permission == LocationPermission.deniedForever) {
          if (context.mounted) {
            await _showCustomAlert(
                context: context,
                title: 'Allow your location',
                content: 'You need to allow location in permission for the app',
                confirmTitle: 'Open App Settings',
                onConfirmPressed: () async {
                  await Geolocator.openAppSettings().then((_) {
                    Navigator.of(context).pop();
                  });
                });
          }
          return null;
        } else {
          return true;
        }
      } else {
        if (context.mounted) {
          await _showCustomAlert(
              context: context,
              title: 'Location Service not enabled',
              content: 'Please enable location service in settings',
              confirmTitle: 'Open Location Settings',
              onConfirmPressed: () async {
                await Geolocator.openLocationSettings().then((_) {
                  Navigator.of(context).pop();
                });
              });
        }
        return null;
      }
    } catch (e) {
      '$_serviceName verifyAppAccess error:: $e'.log();
      _loadingStatus = Loadingstatus.error;
      _errorMsg = e.toString();
      return null;
    } finally {
      '$_serviceName verifyAppAccess finally'.log();
      notifyListeners();
    }
  }
}
