import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:metadent_serving_app/providers/providers.dart';

import 'blocs/blocs.dart';

final sl = GetIt.I;

Future init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  // Repository
  sl.registerLazySingleton(() => AppointmentsRepo(apiClient: sl()));
  sl.registerLazySingleton(() => SlotsRepo(apiClient: sl()));

  // Blocs
  sl.registerFactory(() => AppointmentsBloc(appointmentsRepo: sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}

List<BlocProvider> get blocs => [
      BlocProvider<AppointmentsBloc>(
        create: (context) => sl<AppointmentsBloc>(),
      ),
    ];

Future resetBlocs() async {
  sl<AppointmentsBloc>().add(ResetAppointments());
}
