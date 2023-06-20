import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:po_project/mains/utils/logger.dart';

class ProfileService extends ChangeNotifier {
  ProfileService({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    required BuildContext context,
  }) async {
    try {
      final XFile? file = await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
      if (file != null) {
        final totalSize = (await file.readAsBytes()).length / 1000; // 1000 bytes => 1KB
        if (totalSize / 1000 > 1) { // 1000 KB => 1MB
          await Future.delayed(const Duration(seconds: 2), () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The file is large, please choose other image...'),
              ),
            );
          });

          return [];
        }

        return [file];
      }
      return [];
    } catch (e) {
      'pickImage exception: $e'.log();
      return [];
    } finally {
      notifyListeners();
    }
  }

  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    try {
      return await _imageCropper.cropImage(
        cropStyle: cropStyle,
        sourcePath: file.path,
        // compressQuality: 100,
        // uiSettings: [
        //   IOSUiSettings(),
        //   AndroidUiSettings(),
        // ],
      );
    } catch (e) {
      'crop exception: $e'.log();
      return null;
    } finally {
      notifyListeners();
    }
  }
}
