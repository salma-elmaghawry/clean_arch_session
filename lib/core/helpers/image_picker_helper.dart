import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum PickImageFailure implements Exception {
  cameraDenied('Camera access is blocked, allow it from the app settings'),
  photosDenied('Photos access is blocked, allow it from the app settings'),
  restricted('Camera access is restricted on this device'),
  noCamera('No camera is available on this device'),
  failed('Could not pick the picture, please try again');

  final String message;

  const PickImageFailure(this.message);

  bool get canOpenSettings => this == cameraDenied || this == photosDenied;
}

class ImagePickerHelper {
  // null means the user closed the picker without choosing a picture,
  // and a PickImageFailure is thrown when the picture can't be picked
  static Future<XFile?> pickImage(ImageSource source) async {
    try {
      return await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 80,
      );
    } on PlatformException catch (error) {
      throw switch (error.code) {
        'camera_access_denied' => PickImageFailure.cameraDenied,
        'photo_access_denied' => PickImageFailure.photosDenied,
        'camera_access_restricted' => PickImageFailure.restricted,
        'no_available_camera' => PickImageFailure.noCamera,
        _ => PickImageFailure.failed,
      };
    } catch (_) {
      throw PickImageFailure.failed;
    }
  }
}
