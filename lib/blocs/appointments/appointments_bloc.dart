import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:metadent_serving_app/infra/models/models.dart';
import 'package:metadent_serving_app/providers/providers.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentsRepo appointmentsRepo;
  Timer? _timer;

  AppointmentsBloc({required this.appointmentsRepo})
      : super(
          const AppointmentsState(
            status: AppState.init,
            success: false,
          ),
        ) {
    on<FetchAppointments>((event, emit) async {
      _timer?.cancel();
      emit(state.copyWith(status: AppState.loading));
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
        final res = await appointmentsRepo.fetch();
        add(UpdateAppointments(res));
      });
    });

    on<UpdateAppointments>((event, emit) {
      final res = event.response;
      emit(
        state.copyWith(
          data: res.data?.appointments,
          success: res.success,
          status: res.status,
          message: res.message,
          error: res.error,
        ),
      );
    });

    on<ResetAppointments>((event, emit) {
      _timer?.cancel();
      emit(
        const AppointmentsState(
          status: AppState.init,
          success: false,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
