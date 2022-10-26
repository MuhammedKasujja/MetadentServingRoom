class Urls {
  Urls._();
  static const baseUrl =
      'https://projectdental.nl/staging-backend/api/patients';

  // static const String baseUrl = "http://10.0.2.2:8000/api/patients";

  // static const appointments = "/appointments/waiting_room";
  static const appointments = "/appointments/waiting_room_new";
  static const appointmentsTypes = "/appointments/appointment_types";
  static const createAppointment = "/appointments/create_appointment_checkin";
  static const invoices = "/invoices/all";
  static const checkin = "/appointments/self_checkin";

  static const freeSlots = "/appointments/get_checkin_patient_slots";
}
