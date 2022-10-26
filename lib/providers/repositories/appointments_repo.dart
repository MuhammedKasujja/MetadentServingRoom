import 'package:metadent_serving_app/infra/models/models.dart';
import 'package:metadent_serving_app/providers/providers.dart';

class AppointmentsRepo {
  final ApiClient apiClient;

  AppointmentsRepo({required this.apiClient});

  Future<ApiResponse<AppointmentData, void>> fetch() async {
    return await apiClient.post(Urls.appointments);
  }

  Future<ApiResponse<List<AppointmentType>, AppointmentType>>
      fetchTypes() async {
    return await apiClient.post(Urls.appointmentsTypes);
  }

  Future<ApiResponse> save(
    int appointmentType,
    String firstName,
    String lastName,
    String dateOfBirth,
    Slot slot,
    int interval,
  ) async {
    return await apiClient.post(Urls.createAppointment, data: <String, dynamic>{
      "appointmentTypeId": appointmentType,
      "first_name": firstName,
      "last_name": lastName,
      "date_of_birth": dateOfBirth,
      "sourceId": 2,
      "periodId": 3,
      "interval": interval,
      "comments": "",
      "slots": [slot.toJson()]
    });
  }

  Future<ApiResponse<Appointment, void>> checkin(String dateOfBirth) async {
    return await apiClient.post(Urls.checkin, data: <String, dynamic>{
      'date_of_birth': dateOfBirth,
    });
  }
}
