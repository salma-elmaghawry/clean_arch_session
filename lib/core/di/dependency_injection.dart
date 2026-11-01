import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/auth/data/auth_repo_impl.dart';
import 'package:clean_arch_session/feature/auth/domain/repositories/auth_repo.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/login_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/register_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:clean_arch_session/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:clean_arch_session/feature/profile/cubit/profile_cubit.dart';
import 'package:clean_arch_session/feature/profile/data/profile_repo_impl.dart';
import 'package:clean_arch_session/feature/profile/domain/repositories/profile_repo.dart';
import 'package:clean_arch_session/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:clean_arch_session/feature/profile/domain/usecases/update_profile_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt()));

  // registered as the domain contract, so whoever asks for AuthRepo gets the
  // data implementation without knowing it exists
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(getIt()),
  );
  getIt.registerLazySingleton<ResendOtpUseCase>(
    () => ResendOtpUseCase(getIt()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt(), getIt(), getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(getIt()));
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt()),
  );
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt(), getIt()));
}
