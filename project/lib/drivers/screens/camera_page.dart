import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

import '../../mains/utils/logger.dart';
import '../../mains/constants/colors.dart';
import 'delivered.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.id,
    required this.cameras,
    required this.poNumber,
  });

  final int id;
  final String poNumber;
  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late final XFile picture;
  bool _isRearCameraSelected = true;

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras[0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    try {
      _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() {});
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (_cameraController.value.isTakingPicture) {
      return;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      if (!mounted) return;
      String? status = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Delivered(picture, widget.id, widget.poNumber),
        ),
      );
      if (status == 'success 1') {
        'success 1'.log();
        if (!mounted) return;
        Navigator.of(context).pop('success 2');
      }
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: SafeArea(
        child: Stack(children: [
          (_cameraController.value.isInitialized)
              ? SizedBox(width: MediaQuery.of(context).size.width, child: CameraPreview(_cameraController))
              : Container(color: Colors.black, child: const Center(child: Text(''))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 30,
                      icon: Icon(_isRearCameraSelected ? CupertinoIcons.switch_camera : CupertinoIcons.switch_camera_solid, color: Colors.white),
                      onPressed: () {
                        setState(() => _isRearCameraSelected = !_isRearCameraSelected);
                        initCamera(widget.cameras[_isRearCameraSelected ? 0 : 1]);
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: takePicture,
                      iconSize: 50,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.circle, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Confirm Delivery',
        style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: 22),
      ),
      titleSpacing: -12,
    );
  }
}
