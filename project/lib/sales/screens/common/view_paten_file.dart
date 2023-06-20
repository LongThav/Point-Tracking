import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';

import '../../../mains/utils/logger.dart';
import '../../service/customer_service.dart';

class ViewPatenFile extends StatefulWidget {
  const ViewPatenFile({
    Key? key,
    this.title = "View Paten",
    this.isAsset = false,
    this.patenName,
    this.patenBytes,
    this.patenFileUrl,
  }) : super(key: key);
  final String title;
  final bool isAsset;
  final String? patenName;
  final List<int>? patenBytes;
  final String? patenFileUrl;

  @override
  State<ViewPatenFile> createState() => _ViewPatenFileState();
}

class _ViewPatenFileState extends State<ViewPatenFile> {
  /// PDF view handle
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        /// processing view paten
        'paten file: ${widget.patenFileUrl}'.log();

        if ((widget.patenFileUrl != '' && widget.patenFileUrl != null) || (widget.patenName != null && widget.patenBytes != null)) {
          String patenFileExtension = '';
          if (widget.patenFileUrl == null) {
            patenFileExtension = widget.patenName!.substring(widget.patenName!.lastIndexOf('.') + 1);
          } else {
            patenFileExtension = widget.patenFileUrl!.substring(widget.patenFileUrl!.lastIndexOf('.') + 1);
          }
          'paten file extension: $patenFileExtension'.log();

          /// processing view with image
          if (patenFileExtension != 'pdf') {
            'processing view image file...'.log();

            File? localFile;
            if (widget.patenFileUrl == null) {
              localFile = context.read<CustomerService>().localFile;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ViewImagePaten(
                    isAsset: widget.isAsset,
                    localFile: localFile,
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ViewImagePaten(
                    isAsset: widget.isAsset,
                    imagePath: widget.patenFileUrl,
                  ),
                ),
              );
            }
          } else {
            /// processing view with pdf
            'processing view pdf file'.log();
            final File file = widget.isAsset
                ? await context.read<CustomerService>().loadAsset(
                      widget.patenName!,
                      widget.patenBytes!,
                    )
                : await context.read<CustomerService>().loadNetwork(
                      widget.patenFileUrl!,
                    );
            if (!mounted) return;
            await showDialog(
                context: context,
                builder: (context) {
                  return PDFView(
                    filePath: file.path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                    onRender: (pageNums) {
                      setState(() {
                        pages = pageNums;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      'onError: ${error.toString()}'.log();
                    },
                    onPageError: (page, error) {
                      'onPageError: ${error.toString()}'.log();
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    onPageChanged: (page, total) {
                      'onPageChanged: $page/$total'.log();
                    },
                  );
                });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You don\'t have any paten yet'),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color.fromRGBO(89, 133, 245, 1),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0XFFFFFFFF)),
          ),
        ),
      ),
    );
  }
}

class ViewImagePaten extends StatelessWidget {
  const ViewImagePaten({
    Key? key,
    this.isAsset = false,
    this.imagePath,
    this.localFile,
  }) : super(key: key);
  final bool isAsset;
  final String? imagePath;
  final File? localFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PinchZoom(
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: () {
          'Start zooming'.log();
        },
        onZoomEnd: () {
          'Stop zooming'.log();
        },
        child: isAsset
            ? Image.file(
                localFile!,
                fit: BoxFit.contain,
              )
            : Image.network(
                imagePath!,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
