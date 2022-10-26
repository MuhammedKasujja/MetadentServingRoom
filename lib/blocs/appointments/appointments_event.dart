part of 'appointments_bloc.dart';

@immutable
abstract class AppointmentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAppointments extends AppointmentsEvent {}

class UpdateAppointments extends AppointmentsEvent {
  final ApiResponse<AppointmentData, void> response;

  UpdateAppointments(this.response);

  @override
  List<Object?> get props => [response];
}

class ResetAppointments extends AppointmentsEvent {}
