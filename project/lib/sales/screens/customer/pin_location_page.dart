import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../../../sales/service/customer_service.dart';
import '../../../mains/services/network/api_status.dart';
import '../../../mains/constants/colors.dart';
import '../../../sales/service/location_service.dart';
import '../../../mains/utils/logger.dart';
import '../../widgets/save_btn.dart';

class PinLocationPage extends StatefulWidget {
  const PinLocationPage({
    Key? key,
    this.title = 'Pin Location',
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.type,
    required this.addressType,
    this.addressId,
  }) : super(key: key);
  final String title;
  final double latitude;
  final double longitude;
  final int userId;
  final int type;
  final String addressType;
  final int? addressId;

  @override
  State<PinLocationPage> createState() => _PinLocationPageState();
}

class _PinLocationPageState extends State<PinLocationPage> {
  late final LocationService _locationService;
  late final CustomerService _customerService;
  final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();

  double _height = 0;
  double _width = 0;
  final Set<Marker> _markers = {}; // display red point in the map
  late final LatLng _defaultLatLngPosition;
  late final CameraPosition _cameraPosition;
  String _draggedAddress = "";
  late LatLng _draggedLatLng;
  Placemark? _placemark;

  void _init() async {
    _locationService = context.read<LocationService>();
    _customerService = context.read<CustomerService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;

      await _customerService.readFrmDetail(context);
    });

    _defaultLatLngPosition = LatLng(widget.latitude, widget.longitude);
    _draggedLatLng = _defaultLatLngPosition;
    _cameraPosition = CameraPosition(
      target: _defaultLatLngPosition,
      zoom: 17.5,
    );
  }

  Future<String> _getAddress(LatLng position) async {
    var listPlaceMarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    _placemark = listPlaceMarks[0];
    '_placemark:: $_placemark'.log();

    return '${_placemark?.street ?? ''}, ${_placemark?.subLocality ?? ''}, ${_placemark?.administrativeArea ?? ''}';
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.appBarColor,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              onTap: (latLngValue) async {
                _draggedLatLng = LatLng(latLngValue.latitude, latLngValue.longitude);
                _markers.clear();
                final Marker newMarker = Marker(
                  markerId: const MarkerId('address_1'),
                  draggable: true,
                  onDragEnd: (value) {
                    value.latitude.log();
                    value.longitude.log();
                  },
                  position: _draggedLatLng,
                  infoWindow: const InfoWindow(
                    title: 'New Location',
                    snippet: 'place',
                  ),
                );
                final address = await _getAddress(_draggedLatLng);
                setState(() {
                  _draggedAddress = address;
                  _markers.add(newMarker);
                });
              },
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              onCameraIdle: () async {
                final address = await _getAddress(_draggedLatLng);
                setState(() {
                  _draggedAddress = address;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                _googleMapController.complete(controller);
                final Marker marker = Marker(
                  markerId: const MarkerId('address_2'),
                  position: _defaultLatLngPosition,
                  infoWindow: InfoWindow(
                    title: _draggedAddress,
                    snippet: 'place',
                  ),
                );

                setState(() {
                  _markers.add(marker);
                });
              },
              markers: _markers,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: _height * 0.16,
                width: _width * 0.73,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _placemark?.administrativeArea ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _draggedAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildPinLocation(),
          ],
        ),
      ),
    );
  }

  Widget _buildPinLocation() {
    var loadingStatus = context.watch<LocationService>().loadingStatus;
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: _width * 0.73,
        child: SaveBtn(
          loading: loadingStatus == Loadingstatus.loading,
          title: 'Pin This Location',
          onPress: () async {
            'Pin This Location pressed...'.log();
            'Lat: ${_draggedLatLng.latitude}'.log();
            'Long: ${_draggedLatLng.longitude}'.log();

            Map<String, dynamic> requestBody = {};
            bool result = false;

            /// * All types: 0, 1, 2
            /// - type: 0 Pin
            /// - type: 1 Post
            /// - type: 2 Update
            if (widget.type == 0) {
              /// type: 0
              /// pin location address processing
              requestBody = {
                'lat': _draggedLatLng.longitude.toString(),
                'log': _draggedLatLng.latitude.toString(),
              };
              result = await _locationService.pinLocationAddress(context, requestBody);
              if (!mounted) return;
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success pin location')));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pin location failed')));
              }
            } else if (widget.type == 1) {
              /// type: 1
              /// post location address processing
              var provinces = _customerService.frmDetailModel.data.provinces;
              var khans = _customerService.frmDetailModel.data.khan;
              int? provinceID;
              int? khanID;
              var khanName1 = '';
              var khanName2 = '';
              if (_placemark != null) {
                if (_placemark!.subLocality != null) {
                  khanName1 = _placemark!.subLocality!.toLowerCase();
                  for (int i = 0; i < khans.length; i++) {
                    khanName2 = khans[i].name.toLowerCase().replaceAll(' ', '');
                    'khanName compare: [$khanName1 - $khanName2]'.log();
                    if (khanName1.indexOf(khanName2) > -1) {
                      khanID = khans[i].id;
                      break;
                    }
                  }
                  'khan_id: $khanID'.log();
                  for (int j = 0; j < provinces.length; j++) {
                    if (_placemark!.administrativeArea! == provinces[j].name) {
                      provinceID = provinces[j].id;
                      break;
                    }
                  }
                  'province_id: $provinceID'.log();
                }
              }

              var homeAddress = '';
              var street = _draggedAddress;
              // if (_draggedAddress.indexOf('St') > -1) {
              //   homeAddress = _draggedAddress.substring(0, _draggedAddress.indexOf('St'));
              //   street = _draggedAddress.substring(_draggedAddress.indexOf('St'), _draggedAddress.indexOf(','));
              // }
              // 'homeAddress: $homeAddress'.log();
              'street: $street'.log();

              requestBody = {
                'home_address': homeAddress,
                'street': street,
                'province_id': provinceID,
                'khan_id': khanID,
                'sangkat_id': null, // set to null default
                'type': 'Direct',
                'lat': _draggedLatLng.latitude,
                'log': _draggedLatLng.longitude,
              };

              /// set loading to display CircularProgressIndicator
              _locationService.setLoadingLocationService();
              result = await _locationService.postLocationAddress(context, requestBody);
              if (!mounted) return;
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success create location')));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create location failed')));
              }
            } else if (widget.type == 2) {
              /// type: 2
              /// update location address processing
              var provinces = _customerService.frmDetailModel.data.provinces;
              var khans = _customerService.frmDetailModel.data.khan;
              int? provinceID;
              int? khanID;
              var khanName1 = '';
              var khanName2 = '';
              if (_placemark != null) {
                if (_placemark!.subLocality != null) {
                  khanName1 = _placemark!.subLocality!.toLowerCase();
                  for (int i = 0; i < khans.length; i++) {
                    khanName2 = khans[i].name.toLowerCase().replaceAll(' ', '');
                    'khanName compare: [$khanName1 - $khanName2]'.log();
                    if (khanName1.indexOf(khanName2) > -1) {
                      khanID = khans[i].id;
                      break;
                    }
                  }
                  'khan_id: $khanID'.log();
                  for (int j = 0; j < provinces.length; j++) {
                    if (_placemark!.administrativeArea! == provinces[j].name) {
                      provinceID = provinces[j].id;
                      break;
                    }
                  }
                  'province_id: $provinceID'.log();
                }
              }

              var homeAddress = '';
              var street = _draggedAddress;
              // if (_draggedAddress.indexOf('St') > -1) {
              //   homeAddress = _draggedAddress.substring(0, _draggedAddress.indexOf('St'));
              //   street = _draggedAddress.substring(_draggedAddress.indexOf('St'), _draggedAddress.indexOf(','));
              // }
              // 'homeAddress: $homeAddress'.log();

              'street: $street'.log();
              requestBody = {
                'home_address': homeAddress,
                'street': street,
                'province_id': provinceID,
                'khan_id': khanID,
                'sangkat_id': null, // set to null default
                'type': widget.addressType, // address type: Direct or link
                'lat': _draggedLatLng.latitude,
                'log': _draggedLatLng.longitude,
              };
              result = await _locationService.updateLocationAddress(context, requestBody, widget.addressId!);
              if (!mounted) return;
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success update location')));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update location failed')));
              }
            }
          },
        ),
      ),
    );
  }
}
