import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:clean_arch_session/feature/auth/data/auth_repo.dart';
import 'package:clean_arch_session/feature/profile/cubit/profile_cubit.dart';
import 'package:clean_arch_session/feature/profile/data/profile_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt()));

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
}
