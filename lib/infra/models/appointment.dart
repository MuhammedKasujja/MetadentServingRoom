import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metadent_serving_app/infra/utils/logger.dart';

import 'models.dart';

const _dateFormat = 'dd-MM-yyyy HH:mm';

class AppointmentData {
  final List<Appointment> appointments;
  final String date;

  AppointmentData({required this.appointments, required this.date});

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      appointments: List<Appointment>.from(
        json["appointments"].map((x) => Appointment.fromJson(x, json['date'])),
      ),
      date: json['date'],
    );
  }
}

class Appointment {
  Appointment({
    required this.id,
    this.periodId,
    required this.date,
    required this.patient,
    required this.slots,
    this.comments,
    required this.status,
    this.type,
    this.treatment,
    this.doctor,
    this.code,
    this.servingTime,
    this.checkinTime,
    required this.currentTime,
  });

  int id;
  int? periodId;
  // List<int> doctors;
  String date;
  List<Slot> slots;
  final Patient patient;
  String? comments;
  Status status;
  AppointmentType? type;
  Treatment? treatment;
  Doctor? doctor;
  final String? code;
  final String? servingTime;
  final String? checkinTime;
  final String currentTime;

  factory Appointment.fromJson(Map<String, dynamic> json, String currentTime) =>
      Appointment(
        id: json["id"],
        // periodId: json["period_id"],
        code: json["appointment_code"]?.toString(),
        // date: DateFormat('dd-MM-yyyy').parse(json["date"]).toString(),
        // .format(DateTime.parse(json["date"])), // json["date"],
        date: DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd-MM-yyyy').parse(json["date"])),
        slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
        servingTime: json["servingtime"],
        checkinTime: json["checkin_time"],
        comments: json["comments"],
        status: Status.fromJson(json["status"]),
        patient: Patient.fromJson(json["patient"]),
        type: json["appointment_type"] != null
            ? AppointmentType.fromJson(json['appointment_type'])
            : null,
        treatment: json["treatment_type"] != null
            ? Treatment.fromJson(json["treatment_type"])
            : null,
        doctor: json['doctors'][0] != null
            ? Doctor.fromJson(json['doctors'][0])
            : null,
        currentTime: currentTime,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "period_id": periodId,
        "date": date,
        "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
        "servingtime": servingTime,
        "comments": comments,
        "status": status.toJson(),
        "appointment_type": type,
        "treatment": treatment?.toJson(),
        "appointment_code": code,
        "checkin_time": checkinTime
      };

  String get title => treatment != null ? treatment!.title : type!.title;

  QueueState get queue => _generateState();

  QueueState _generateState() {
    QueueState state = QueueState(type: QueueType.none, name: '');
    final now = DateTime.parse(currentTime);
    if (now.isAfter(
        DateFormat(_dateFormat).parse('$date ${slots[0].startTime}'))) {
      state = QueueState(type: QueueType.delayed, name: 'Delayed');
    }
    if ((now.isBefore(
            DateFormat(_dateFormat).parse('$date ${slots[0].startTime}')) ||
        now.isAtSameMomentAs(
            DateFormat(_dateFormat).parse('$date ${slots[0].startTime}')))) {
      state = QueueState(type: QueueType.onSchedule, name: 'On schedule');
    }
    if ((servingTime != null &&
        (now.minute - DateFormat(_dateFormat).parse(servingTime!).minute) <=
            3 &&
        (now.hour - DateFormat(_dateFormat).parse(servingTime!).hour == 0))) {
      Logger.debug(key: 'Serving Time', data: {
        'Current': now.toString(),
        'Sering': now.hour - DateFormat(_dateFormat).parse(servingTime!).hour,
        'time': DateFormat(_dateFormat).parse(servingTime!)
      });
      state = QueueState(type: QueueType.doctorComing, name: 'Get Ready');
    }
    if ((servingTime != null &&
        ((now.minute - DateFormat(_dateFormat).parse(servingTime!).minute) >
                3 ||
            (now.hour - DateFormat(_dateFormat).parse(servingTime!).hour >
                0)))) {
      state = QueueState(type: QueueType.serving, name: 'Serving');
      Logger.debug(key: 'Serving Time', data: {
        'Current': now.toString(),
        'Sering': now.hour - DateFormat(_dateFormat).parse(servingTime!).hour,
        'time': DateFormat(_dateFormat).parse(servingTime!)
      });
    }
    return state;
  }
}

class QueueState {
  final QueueType type;
  final String name;

  QueueState({required this.type, required this.name});
}

enum QueueType {
  none,
  delayed,
  onSchedule,
  doctorComing,
  serving,
}

class Status {
  Status({
    required this.id,
    required this.name,
    required this.color,
  });

  int id;
  String name;
  Color color;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["status"],
        color: getColor(json["id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": name,
      };

  static Color getColor(int status) {
    if (status == 1) return Colors.yellow;
    if (status == 2) return Colors.grey;
    if (status == 3) return const Color(0xFFFF782E);
    if (status == 4) return Colors.red;
    if (status == 5) return Colors.red;
    if (status == 6) return Colors.black;
    if (status == 7) return Colors.green;
    return Colors.grey;
  }
}

class Doctor {
  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.address,
    this.photo,
  });

  int id;
  String firstName;
  String lastName;
  String? gender;
  String? address;
  String? photo;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        // gender: json["gender"],
        // address: json["address"],
        // photo: json['photo'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
      };

  String get name => firstName + " " + lastName;
}

class Patient {
  Patient({
    required this.id,
    this.gender,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.country,
    this.city,
  });

  final int id;
  final String? gender;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String? country;
  final String? city;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        gender: json["gender"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        birthDate: json["birth_date"],
        country: json["country"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gender": gender,
        "first_name": firstName,
        "last_name": lastName,
        "birth_date": birthDate,
        "country": country,
        "city": city,
      };

  String get name => '$firstName $lastName';

  String get initials =>
      firstName[0].toUpperCase() + " " + lastName[0].toUpperCase();
}
