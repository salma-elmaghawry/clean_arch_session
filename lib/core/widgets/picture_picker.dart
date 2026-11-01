import 'dart:io';

import 'package:clean_arch_session/core/helpers/image_picker_helper.dart';
import 'package:clean_arch_session/core/widgets/open_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class PicturePicker extends StatelessWidget {
  final XFile? picture;
  final String? pictureUrl;
  final ValueChanged<XFile> onPicked;

  const PicturePicker({
    super.key,
    required this.picture,
    required this.onPicked,
    this.pictureUrl,
  });

  Future<void> _pick(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final picked = await ImagePickerHelper.pickImage(source);
      if (!context.mounted) return;
      if (picked != null) onPicked(picked);
    } on PickImageFailure catch (failure) {
      if (!context.mounted) return;
      if (failure.canOpenSettings) {
        showOpenSettingsDialog(
          context,
          title: 'Permission needed',
          message: failure.message,
          // opens this app's page in the system settings, it isn't location specific
          openSettings: Geolocator.openAppSettings,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider? image = picture != null
        ? FileImage(File(picture!.path))
        : pictureUrl != null
        ? NetworkImage(pictureUrl!)
        : null;
    return Center(
      child: GestureDetector(
        onTap: () => _pick(context),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: image,
              child: image == null
                  ? const Icon(Icons.add_a_photo, size: 32)
                  : null,
            ),
            if (image != null)
              const Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.edit, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
