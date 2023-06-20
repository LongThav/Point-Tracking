import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../sales/widgets/save_btn.dart';
import '../../../mains/services/network/api_status.dart';
import '../../../sales/models/address_list_model.dart';
import '../../../mains/constants/colors.dart';
import '../../models/form_detail_model.dart';
import '../../service/customer_service.dart';
import '../../../mains/utils/logger.dart';
import 'pin_location_page.dart';
import '../../../sales/service/location_service.dart';
import '../../widgets/common_text_form_field.dart';

class BuildLocation extends StatefulWidget {
  final int customerId;

  const BuildLocation({
    super.key,
    required this.customerId,
  });

  @override
  State<BuildLocation> createState() => _BuildLocationState();
}

class _BuildLocationState extends State<BuildLocation> {
  /// TextEditingController
  late final TextEditingController _streetCtrl;
  late final TextEditingController _homeCtrl;
  late final TextEditingController _khanCtrl;
  late final TextEditingController _sangkatCtrl;
  late final TextEditingController _provinceCtrl;
  // late final TextEditingController _statusCtrl;

  /// services
  late final CustomerService _customerService;
  late final LocationService _locationService;

  /// other states
  // var _width = 0.0;
  var _height = 0.0;
  List<Address> _listsAddress = [];
  String _khan = '';
  int _khanID = 0;
  String _sangkat = ' ';
  int _sangkatId = 0;
  String _province = ' ';
  int _provinceId = 0;
  int? addressId;
  Address? _mainAddress;

  /// google map requirement
  late final Completer<GoogleMapController> _googleMapController;
  CameraPosition? _initialCameraPosition;
  final Set<Marker> _markers = {}; // display red point in the map
  String _draggedAddress = "";
  LatLng? _draggedLatLng;
  bool? _verifyStatus = false;
  Placemark? _placemark;

  Future<void> updateLocation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          insetPadding: const EdgeInsets.all(15),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFFFFFFF),
            ),
            child: _updateLocationForm(),
          ),
        );
      },
    );
  }

  /// go to current location
  Future<void> _gotoUserCurrentPosition() async {
    'go to current location'.log();

    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    /// update draggedLatLng
    setState(() {
      _draggedLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
      _initialCameraPosition = CameraPosition(
        target: _draggedLatLng!,
        zoom: 17.5,
      );
    });
    await _gotoSpecificPosition(_draggedLatLng!);
  }

  /// go to specific location
  Future<void> _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 17.5),
      ),
    );
    final String address = await _getAddress(position);

    // clear marker
    _markers.clear();
    Marker newMarker = Marker(
      markerId: const MarkerId('address_0'),
      position: position,
      infoWindow: InfoWindow(
        title: _draggedAddress,
        snippet: 'place',
      ),
    );

    setState(() {
      _draggedAddress = address;
      _markers.add(newMarker);
    });
  }

  Future<String> _getAddress(LatLng position) async {
    var listPlaceMarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    _placemark = listPlaceMarks[0];
    '_placemark:: $_placemark'.log();

    var addressStr = '${_placemark?.street ?? ''}, ${_placemark?.subLocality ?? ''}, ${_placemark?.administrativeArea ?? ''}';

    return addressStr;
  }

  void _init() async {
    /// services
    _customerService = context.read<CustomerService>();
    _locationService = context.read<LocationService>();

    /// TextEditingController
    _streetCtrl = TextEditingController();
    _homeCtrl = TextEditingController();
    _khanCtrl = TextEditingController();
    _sangkatCtrl = TextEditingController();
    _provinceCtrl = TextEditingController();
    // _statusCtrl = TextEditingController();

    /// google map
    _googleMapController = Completer<GoogleMapController>();

    /// Schedule a callback for the end of this frame. (usually related to async & await, rebuild UI state)
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;

      _customerService.setLoadingCustomerService();
      // _customerService.setUserID(widget.userId);
      await Future.wait([
        _customerService.readLocation(context, widget.customerId.toString()),
        _customerService.readFrmDetail(context),
      ]);

      _mainAddress = _customerService.addressModel?.getMainAddress();
      'mainAddress: $_mainAddress'.log();
      'mainAddress: lat[${_mainAddress?.lat}] log[${_mainAddress?.log}]'.log();

      if (!mounted) return;

      /// check service enable & app access location
      var result = await _locationService.verifyAppAccess(context);
      'verify result: [$result]'.log();

      setState(() {
        _listsAddress = _customerService.addressModel?.data ?? [];
        _verifyStatus = result;
      });

      if (_verifyStatus == true) {
        if (_mainAddress != null && _mainAddress!.lat != null && _mainAddress!.log != null) {
          setState(() {
            _draggedLatLng = LatLng(_mainAddress!.lat!, _mainAddress!.log!);
            _initialCameraPosition = CameraPosition(
              target: _draggedLatLng!,
              zoom: 17.5,
            );
          });

          await _gotoSpecificPosition(_draggedLatLng!);
        } else {
          /// getting current location
          await _gotoUserCurrentPosition();
        }
      }
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _homeCtrl.dispose();
    _khanCtrl.dispose();
    _sangkatCtrl.dispose();
    _provinceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
    );
  }

  Widget get _buildBody {
    Loadingstatus loadingstatus = context.watch<CustomerService>().loadingStatus;
    'loading status:: $loadingstatus'.log();

    switch (loadingstatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(child: CircularProgressIndicator());
      case Loadingstatus.error:
        return Center(
          child: Text(
            _customerService.errorMsg,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        );
      case Loadingstatus.complete:
        return _buildLocationData();
    }
  }

  Widget _buildLocationData() {
    int itemCount = _listsAddress.length;
    if (itemCount == 0) {
      return const Center(
        child: Text(
          'No location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: List.generate(
              itemCount >= 3 ? 3 : itemCount,
              (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(85, 75, 186, 0.14),
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _listsAddress[index].street ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              height: 1.3,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 13, 13, 1),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final dataLocation = _listsAddress[index];
                            _streetCtrl = TextEditingController(text: dataLocation.street);
                            _homeCtrl = TextEditingController(text: dataLocation.homeAddress);
                            _khanCtrl = TextEditingController(text: dataLocation.khan.toString());
                            _sangkatCtrl = TextEditingController(text: dataLocation.sangkat.toString());
                            _provinceCtrl = TextEditingController(text: dataLocation.province.toString());
                            setState(() {
                              addressId = dataLocation.id;
                            });
                            await updateLocation(context);
                          },
                          icon: const Icon(
                            Icons.edit_note,
                            color: AppColors.textColor,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: _displayMapOrRequestAllow,
        ),
      ],
    );
  }

  Widget get _displayMapOrRequestAllow {
    if (_verifyStatus == true && _initialCameraPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_verifyStatus == true) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.33,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition!,
              onCameraIdle: () async {
                final address = await _getAddress(_draggedLatLng!);
                setState(() {
                  _draggedAddress = address;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                if (_googleMapController.isCompleted == false) {
                  _googleMapController.complete(controller);
                }

                // clear marker
                _markers.clear();
                Marker marker = Marker(
                  markerId: const MarkerId('address_1'),
                  position: _draggedLatLng!,
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
          ),
          SaveBtn(
            title: 'Update Location',
            onPress: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PinLocationPage(
                    latitude: _draggedLatLng!.latitude,
                    longitude: _draggedLatLng!.longitude,
                    userId: widget.customerId,
                    type: 2,
                    addressType: 'link',
                    addressId: _mainAddress!.id,
                  ),
                ),
              );

              await Future.delayed(const Duration(milliseconds: 100), () {});
              setState(() {});
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        const Text('Please allowed location and try again'),
        ElevatedButton(
          onPressed: () async {
            var verifyStatus = await _locationService.verifyAppAccess(context);
            setState(() {
              _verifyStatus = verifyStatus;
            });
          },
          child: const Text('Allowed'),
        ),
      ],
    );
  }

  Widget _updateLocationForm() {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Update Location",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                size: 25,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        CommonTextFormField(
          text: 'Street',
          isRequired: true,
          ctr: _streetCtrl,
          hintText: 'Street Address',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Input Street';
            }
            return null;
          },
        ),
        SizedBox(
          height: _height * 0.02,
        ),
        CommonTextFormField(
          text: 'Home',
          isRequired: true,
          ctr: _homeCtrl,
          hintText: 'Home No',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Input Home';
            }
            return null;
          },
        ),
        SizedBox(
          height: _height * 0.02,
        ),
        _buildKhan(),
        SizedBox(
          height: _height * 0.02,
        ),
        _buildSangkat(),
        SizedBox(
          height: _height * 0.02,
        ),
        _buildprovice(),
        SizedBox(
          height: _height * 0.02,
        ),
        SaveBtn(
            title: 'Update Location',
            onPress: () async {
              Map<String, dynamic> map = {
                'home_listsAddress': _homeCtrl.text,
                'street': _streetCtrl.text,
                'khan_id': _khanID,
                'province_id': _provinceId,
                'sangkat_id': _sangkatId,
              };
              "Home::${_homeCtrl.text}".log();
              "Street::${_streetCtrl.text}".log();
              "Province::$_provinceId".log();
              "khan_id::$_khanID".log();
              "sangkat_id::$_sangkatId".log();

              // close dialog popup
              Navigator.of(context).pop();

              _customerService.setLoadingCustomerService();

              await Future.delayed(const Duration(milliseconds: 500), () {});

              if (!mounted) return;
              final result = await _customerService.updateLocation(context, map, addressId!);
              if (!mounted) return;
              if (result) {
                await _customerService.readLocation(context, widget.customerId.toString());
                final List<Address> addressUpdate = _customerService.addressModel?.data ?? [];

                setState(() {
                  _listsAddress = addressUpdate;
                });

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Update location success'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Update location fail'),
                  ),
                );
              }
            }),
      ],
    );
  }

  Widget _buildKhan() {
    final List<Khan> listkhan = _customerService.frmDetailModel.data.khan;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listkhan.isEmpty) {
        return const CircularProgressIndicator();
      }
      _khan = listkhan[0].name;
      _khanID = listkhan[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Khan',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _khan,
            items: List.generate(listkhan.length, (index) {
              return DropdownMenuItem(
                value: listkhan[index].name,
                child: Text(listkhan[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                _khan = value ?? '';
              });
              final khanObj = listkhan.where((element) => element.name == value).toList();
              _khanID = khanObj[0].id;
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSangkat() {
    final List<Sangkat> listsangkat = _customerService.frmDetailModel.data.sangkat;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listsangkat.isEmpty) {
        return const CircularProgressIndicator();
      }
      _sangkat = listsangkat[0].name;
      _sangkatId = listsangkat[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'SangKat',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _sangkat,
            items: List.generate(listsangkat.length, (index) {
              return DropdownMenuItem(
                value: listsangkat[index].name,
                child: Text(listsangkat[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                _sangkat = value ?? '';
              });
              final paymentObj = listsangkat.where((element) => element.name == value).toList();
              _sangkatId = paymentObj[0].id;
              "ProvinceId::$_sangkatId".log();
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildprovice() {
    final List<Provinces> listprovince = _customerService.frmDetailModel.data.provinces;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listprovince.isEmpty) {
        return const CircularProgressIndicator();
      }
      _province = listprovince[0].name;
      _provinceId = listprovince[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'City',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _province,
            items: List.generate(listprovince.length, (index) {
              return DropdownMenuItem(
                value: listprovince[index].name,
                child: Text(listprovince[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                _province = value ?? '';
              });
              final paymentObj = listprovince.where((element) => element.name == value).toList();
              _provinceId = paymentObj[0].id;
              "ProvinceId::$_provinceId".log();
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ],
      );
    }
  }
}
