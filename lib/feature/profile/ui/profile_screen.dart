import 'package:clean_arch_session/core/routes/routes.dart';
import 'package:clean_arch_session/feature/auth/cubit/auth_cubit.dart';
import 'package:clean_arch_session/feature/profile/cubit/profile_cubit.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return _ProfileDetails(profile: state.profile);
            } else if (state is ProfileFailure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    TextButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().getProfile(),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final ProfileModel profile;

  const _ProfileDetails({required this.profile});

  @override
  Widget build(BuildContext context) {
    final picture = profile.pictureUrl;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: picture != null ? NetworkImage(picture) : null,
          child: picture == null ? const Icon(Icons.person, size: 48) : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListTile(leading: const Icon(Icons.email), title: Text(profile.email)),
        ListTile(leading: const Icon(Icons.phone), title: Text(profile.phone)),
        if (profile.address != null)
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(profile.address!),
          ),
      ],
    );
  }
}
