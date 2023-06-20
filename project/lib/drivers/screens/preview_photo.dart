import 'dart:io';

import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:photo_view/photo_view.dart';

class PreviewPhoto extends StatefulWidget {
  final XFile img;
  const PreviewPhoto({super.key, required this.img});

  @override
  State<PreviewPhoto> createState() => _PreviewPhotoState();
}

class _PreviewPhotoState extends State<PreviewPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              enableRotation: true,
              imageProvider: FileImage(
                File(widget.img.path),
              ),
            ),
          ),
        ));
  }
}
