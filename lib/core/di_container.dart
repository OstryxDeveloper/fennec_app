import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/login_cubit.dart';
import 'package:fennac_app/pages/dashboard/presentation/bloc/cubit/dashboard_cubit.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/cubit/filter_cubit.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/cubit/home_landing_cubit.dart';
import 'package:fennac_app/pages/create_group/presentation/bloc/cubit/create_group_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/splash/presentation/bloc/cubit/background_cubit.dart';
import 'package:get_it/get_it.dart';

import '../bloc/cubit/background_cubit.dart';

class Di {
  final sl = GetIt.I;

  Future<void> init() async {
    // Cubits
    sl.registerLazySingleton<AuthCubit>(() => AuthCubit());
    sl.registerLazySingleton<BackgroundCubit>(() => BackgroundCubit());
    sl.registerLazySingleton<FilterCubit>(() => FilterCubit());
    sl.registerLazySingleton<KycCubit>(() => KycCubit());
    sl.registerLazySingleton<KycPromptCubit>(() => KycPromptCubit());
    sl.registerLazySingleton<ImagePickerCubit>(() => ImagePickerCubit());
    sl.registerLazySingleton<DashboardCubit>(() => DashboardCubit());
    sl.registerLazySingleton<HomeCubit>(() => HomeCubit());
    sl.registerLazySingleton<LoginCubit>(() => LoginCubit());
    sl.registerLazySingleton<HomeLandingCubit>(() => HomeLandingCubit());
    sl.registerLazySingleton<CreateGroupCubit>(() => CreateGroupCubit());
    sl.registerLazySingleton<MoveAbleBackgroundCubit>(
      () => MoveAbleBackgroundCubit(),
    );
  }
}
