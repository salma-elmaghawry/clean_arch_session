import 'dart:io';

import 'package:clean_arch_session/core/helpers/location_helper.dart';
import 'package:clean_arch_session/core/routes/routes.dart';
import 'package:clean_arch_session/core/widgets/app_button.dart';
import 'package:clean_arch_session/feature/auth/cubit/auth_cubit.dart';
import 'package:clean_arch_session/feature/auth/data/register_request_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _addressController = TextEditingController();
  XFile? _picture;
  Position? _position;
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String get _phoneWithCountryCode {
    final phone = _phoneController.text.trim();
    return '+20${phone.startsWith('0') ? phone.substring(1) : phone}';
  }

  Future<void> _pickPicture() async {
    final picture = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (picture != null) setState(() => _picture = picture);
  }

  Future<void> _getLocation() async {
    setState(() => _isGettingLocation = true);
    final result = await LocationHelper.getCurrentPosition();
    if (!mounted) return;
    setState(() => _isGettingLocation = false);
    result.fold(
      (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error))),
      (position) => setState(() => _position = position),
    );
  }

  void _register() {
    final address = _addressController.text.trim();
    context.read<AuthCubit>().register(
      RegisterRequestBody(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneWithCountryCode,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        address: address.isEmpty ? null : address,
        latitude: _position?.latitude,
        longitude: _position?.longitude,
        picturePath: _picture?.path,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            Navigator.pushNamed(context, Routes.otp, arguments: state.email);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickPicture,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: _picture != null
                        ? FileImage(File(_picture!.path))
                        : null,
                    child: _picture == null
                        ? const Icon(Icons.add_a_photo, size: 32)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Profile picture (optional)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
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
                  prefixText: '+20 ',
                  hintText: '01xxxxxxxxx',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordConfirmationController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                ),
              ),
              const SizedBox(height: 24),
              Text('Optional', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isGettingLocation ? null : _getLocation,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: _isGettingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _position == null
                            ? Icons.my_location
                            : Icons.check_circle,
                      ),
                label: Text(
                  _position == null
                      ? 'Use my current location'
                      : '${_position!.latitude.toStringAsFixed(4)}, '
                            '${_position!.longitude.toStringAsFixed(4)}',
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Register',
                isLoading: state is AuthLoading,
                onPressed: _register,
              ),
            ],
          );
        },
      ),
    );
  }
}
