import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/services/network/api_status.dart';
import '../../mains/utils/logger.dart';
import '../service/purchase_order_service.dart';
import 'preview_photo.dart';

class Delivered extends StatefulWidget {
  const Delivered(this.img, this.id, this.poNumber, {super.key});
  final XFile img;
  final int id;
  final String poNumber;

  @override
  State<Delivered> createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  @override
  Widget build(BuildContext context) {
    Loadingstatus loadingStatus = context.watch<PurchaseOrderDriverService>().loadingstatus;
    bool loading = loadingStatus == Loadingstatus.loading;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(121, 121, 121, 0.5),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          margin: EdgeInsets.only(
            left: 1.7.h,
          ),
          width: MediaQuery.of(context).size.width,
          height: 529.54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0XFFFFFFFF),
          ),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.poNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(52, 52, 52, 1),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color.fromRGBO(137, 137, 137, 1),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return PreviewPhoto(img: widget.img);
                  }));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 2.h),
                  width: MediaQuery.of(context).size.width,
                  height: 267.66,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                          File(widget.img.path),
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55.94,
                  margin: EdgeInsets.only(right: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                      Color.fromRGBO(101, 112, 215, 1),
                      Color.fromRGBO(92, 132, 235, 1),
                    ]),
                  ),
                  child: const Center(
                    child: Text(
                      'Retake Picture',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0XFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              GestureDetector(
                onTap: () async {
                  'confirm pressed...'.log();
                  final String imgPath = widget.img.path;
                  File imageFile = File(imgPath);
                  Uint8List imageBytes = imageFile.readAsBytesSync();
                  String imgExtension = imgPath.substring(imgPath.lastIndexOf('.') + 1);
                  'imgExtension: $imgExtension'.log(); // .jpg
                  String base64Image = "data:image/$imgExtension;base64,${base64.encode(imageBytes)}";
                  Map<String, String> body = {
                    'po_delivery_file': base64Image,
                  };
                  context.read<PurchaseOrderDriverService>().setLoading();
                  var status = await context.read<PurchaseOrderDriverService>().uploadImage(body, widget.id, context);
                  if (status) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success...'),
                      ),
                    );
                    Navigator.of(context).pop('success 1');
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Upload Image Error...'),
                      ),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55.94,
                  margin: EdgeInsets.only(right: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                      Color.fromRGBO(67, 110, 220, 1),
                      Color.fromRGBO(44, 54, 145, 1),
                    ]),
                  ),
                  child: Center(
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Color(0XFFFFFFFF),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
