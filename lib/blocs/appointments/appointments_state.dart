part of 'appointments_bloc.dart';

@immutable
class AppointmentsState extends Equatable {
  final String? error;
  final String? message;
  final AppState status;
  final List<Appointment>? data;
  final bool success;
  const AppointmentsState({
    this.error,
    this.message,
    required this.status,
    this.data,
    required this.success,
  });

  AppointmentsState copyWith({
    String? error,
    String? message,
    required AppState status,
    List<Appointment>? data,
    bool? success,
  }) {
    return AppointmentsState(
      error: error,
      message: message,
      status: status,
      data: data ?? this.data,
      success: success ?? false,
    );
  }

  @override
  List<Object?> get props => [
        error,
        message,
        status,
        data,
        success,
      ];
}
