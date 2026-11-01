import 'package:clean_arch_session/core/helpers/phone_helper.dart';
import 'package:clean_arch_session/core/widgets/app_button.dart';
import 'package:clean_arch_session/core/widgets/location_button.dart';
import 'package:clean_arch_session/core/widgets/picture_picker.dart';
import 'package:clean_arch_session/feature/profile/cubit/profile_cubit.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:clean_arch_session/feature/profile/data/update_profile_request_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _nameController = TextEditingController(text: widget.profile.name);
  late final _emailController = TextEditingController(
    text: widget.profile.email,
  );
  late final _phoneController = TextEditingController(
    text: PhoneHelper.toLocal(widget.profile.phone),
  );
  late final _addressController = TextEditingController(
    text: widget.profile.address,
  );
  late double? _latitude = widget.profile.latitude;
  late double? _longitude = widget.profile.longitude;
  XFile? _picture;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    final address = _addressController.text.trim();
    context.read<ProfileCubit>().updateProfile(
      UpdateProfileRequestBody(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: PhoneHelper.withCountryCode(_phoneController.text),
        address: address.isEmpty ? null : address,
        latitude: _latitude,
        longitude: _longitude,
        picturePath: _picture?.path,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context, true);
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PicturePicker(
                picture: _picture,
                pictureUrl: widget.profile.pictureUrl,
                onPicked: (picture) => setState(() => _picture = picture),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixText: '${PhoneHelper.countryCode} ',
                  hintText: '01xxxxxxxxx',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              LocationButton(
                latitude: _latitude,
                longitude: _longitude,
                onLocated: (position) => setState(() {
                  _latitude = position.latitude;
                  _longitude = position.longitude;
                }),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Save',
                isLoading: state is ProfileLoading,
                onPressed: _save,
              ),
            ],
          );
        },
      ),
    );
  }
}
