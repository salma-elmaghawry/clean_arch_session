import 'package:clean_arch_session/core/di/dependency_injection.dart';
import 'package:clean_arch_session/core/routes/routes.dart';
import 'package:clean_arch_session/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:clean_arch_session/feature/auth/presentation/ui/login_screen.dart';
import 'package:clean_arch_session/feature/auth/presentation/ui/otp_screen.dart';
import 'package:clean_arch_session/feature/auth/presentation/ui/register_screen.dart';
import 'package:clean_arch_session/feature/profile/cubit/profile_cubit.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:clean_arch_session/feature/profile/ui/edit_profile_screen.dart';
import 'package:clean_arch_session/feature/profile/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.otp:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: OtpScreen(email: email),
          ),
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<ProfileCubit>()..getProfile()),
              BlocProvider(create: (_) => getIt<AuthCubit>()),
            ],
            child: const ProfileScreen(),
          ),
        );
      case Routes.editProfile:
        final profile = settings.arguments as ProfileModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: EditProfileScreen(profile: profile),
          ),
        );
      default:
        return null;
    }
  }
}
