import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/pages/splash/presentation/bloc/cubit/background_cubit.dart';
import 'package:get_it/get_it.dart';

class Di {
  final sl = GetIt.I;

  Future<void> init() async {
    // Cubits
    sl.registerLazySingleton<AuthCubit>(() => AuthCubit());
    sl.registerLazySingleton<BackgroundCubit>(() => BackgroundCubit());
  }
}
