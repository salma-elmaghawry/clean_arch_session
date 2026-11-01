import 'package:clean_arch_session/core/helpers/phone_helper.dart';
import 'package:clean_arch_session/core/routes/routes.dart';
import 'package:clean_arch_session/core/widgets/app_button.dart';
import 'package:clean_arch_session/core/widgets/location_button.dart';
import 'package:clean_arch_session/core/widgets/picture_picker.dart';
import 'package:clean_arch_session/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:clean_arch_session/feature/auth/domain/entities/register_entity.dart';
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

  void _register() {
    final address = _addressController.text.trim();
    context.read<AuthCubit>().register(
      RegisterEntity(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: PhoneHelper.withCountryCode(_phoneController.text),
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
              PicturePicker(
                picture: _picture,
                onPicked: (picture) => setState(() => _picture = picture),
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
                  prefixText: '${PhoneHelper.countryCode} ',
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
              LocationButton(
                latitude: _position?.latitude,
                longitude: _position?.longitude,
                onLocated: (position) => setState(() => _position = position),
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
