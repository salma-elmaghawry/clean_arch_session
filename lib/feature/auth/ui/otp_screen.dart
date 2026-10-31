import 'package:clean_arch_session/core/routes/routes.dart';
import 'package:clean_arch_session/core/widgets/app_button.dart';
import 'package:clean_arch_session/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verify() {
    context.read<AuthCubit>().verifyOtp(
      email: widget.email,
      otpCode: _otpController.text.trim(),
    );
  }

  void _resend() {
    context.read<AuthCubit>().resendOtp(email: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify code')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerified) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.profile,
              (route) => false,
            );
          } else if (state is AuthOtpSent) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Enter the code we sent to ${widget.email}'),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Verify',
                isLoading: isLoading,
                onPressed: _verify,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: isLoading ? null : _resend,
                child: const Text('Resend code'),
              ),
            ],
          );
        },
      ),
    );
  }
}
