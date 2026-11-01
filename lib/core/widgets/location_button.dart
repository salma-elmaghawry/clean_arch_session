import 'package:clean_arch_session/core/helpers/location_helper.dart';
import 'package:clean_arch_session/core/widgets/open_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationButton extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final ValueChanged<Position> onLocated;

  const LocationButton({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onLocated,
  });

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  bool _isLoading = false;

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await LocationHelper.getCurrentPosition();
      if (mounted) widget.onLocated(position);
    } on LocationFailure catch (failure) {
      if (mounted) _showFailure(failure);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showFailure(LocationFailure failure) {
    switch (failure) {
      case LocationFailure.serviceDisabled:
        showOpenSettingsDialog(
          context,
          title: 'Location is off',
          message: failure.message,
          openSettings: Geolocator.openLocationSettings,
        );
      case LocationFailure.deniedForever:
        showOpenSettingsDialog(
          context,
          title: 'Permission needed',
          message: failure.message,
          openSettings: Geolocator.openAppSettings,
        );
      case LocationFailure.denied:
      case LocationFailure.unavailable:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final latitude = widget.latitude;
    final longitude = widget.longitude;
    final hasLocation = latitude != null && longitude != null;
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _getLocation,
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(hasLocation ? Icons.check_circle : Icons.my_location),
      label: Text(
        hasLocation
            ? '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}'
            : 'Use my current location',
      ),
    );
  }
}
