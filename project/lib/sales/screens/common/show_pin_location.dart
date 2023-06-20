import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../mains/constants/colors.dart';
import '../../../sales/service/location_service.dart';
import '../../../mains/services/network/api_status.dart';
// import '../../../mains/utils/logger.dart';

class ShowPinLocation extends StatefulWidget {
  const ShowPinLocation({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.currentAddress,
  });

  final double latitude;
  final double longitude;
  final String currentAddress;

  @override
  State<ShowPinLocation> createState() => _ShowPinLocationState();
}

class _ShowPinLocationState extends State<ShowPinLocation> {
  late final LocationService _locationService;
  late final CameraPosition _initialCamera;
  late final LatLng _position;
  late final Completer<GoogleMapController> _googleMapController;
  final Set<Marker> _markers = {};
  bool _isAllowed = false;
  bool _isNoText = false;

  Future<bool?> _checkAppStatus() async {
    return await _locationService.verifyAppAccess(context);
  }

  void _init() {
    _locationService = context.read<LocationService>();
    _googleMapController = Completer<GoogleMapController>();
    _position = LatLng(widget.latitude, widget.longitude);
    _initialCamera = CameraPosition(
      target: _position,
      zoom: 17.5,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _locationService.setLoadingLocationService();
      var result = await _checkAppStatus();
      await Future.delayed(const Duration(seconds: 3), () {});
      _locationService.setLoadingStatus(Loadingstatus.complete);
      if (!mounted) return;
      setState(() {
        _isAllowed = result ?? false;
      });
    });
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
        title: const Text('View Location'),
        backgroundColor: AppColors.appBarColor,
      ),
      body: _getBody,
    );
  }

  Widget get _getBody {
    var status = context.watch<LocationService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Center(
        child: !_isAllowed ? _handledAllowed : _handledDisplayMap,
      ),
    );
  }

  Widget get _handledAllowed {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Please allowed location and try again'),
        ElevatedButton(
          onPressed: () async {
            _locationService.setLoadingLocationService();
            var result = await _checkAppStatus();
            await Future.delayed(const Duration(seconds: 3), () {});
            _locationService.setLoadingStatus(Loadingstatus.complete);
            setState(() {
              _isAllowed = result ?? false;
            });
          },
          child: const Text('Allowed'),
        ),
      ],
    );
  }

  Widget get _handledDisplayMap {
    String? title;
    String? snippet;
    if (widget.currentAddress.indexOf(',') > -1) {
      title = widget.currentAddress.substring(0, widget.currentAddress.indexOf(','));
      snippet = widget.currentAddress.substring(widget.currentAddress.indexOf(',') + 1);
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCamera,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _googleMapController.complete(controller);
        var marker = Marker(
            markerId: const MarkerId('current_address'),
            position: _position,
            infoWindow: _isNoText
                ? InfoWindow.noText
                : InfoWindow(
                    title: title,
                    snippet: snippet,
                  ),
            onTap: () {
              setState(() {
                _isNoText = !_isNoText;
              });
            });

        setState(() {
          _markers.add(marker);
        });
      },
    );
  }
}
