import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;    //should add "http: ^0.13.3" in dependencies of pubspec.yaml to work

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppointmentsListScreen(),
    );
  }
}

class AppointmentsListScreen extends StatefulWidget {
  @override
  _AppointmentsListScreenState createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  List<Appointment> appointments = [];

  Future<void> fetchAppointments() async {
    final response = await http.get(Uri.https(
        'raw.githubusercontent.com', '/kkurdaaa/doctor_karim/main/9ba9.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Appointment> loadedAppointments = [];
      jsonData.forEach((appointmentData) {
        loadedAppointments.add(Appointment.fromJson(appointmentData));
      });
      setState(() {
        appointments = loadedAppointments;
      });
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Navigate to details screen when tile is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentDetailsScreen(appointment: appointments[index]),
                ),
              );
            },
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  appointments[index].doctorImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text('Doctor: ${appointments[index].doctorName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Doctor ID: ${appointments[index].doctorId}'),
                  Text('Patient ID: ${appointments[index].patientId}'),
                  Text('Date: ${appointments[index].appointmentDate}'),
                  Text('Time: ${appointments[index].appointmentTime}'),
                  Text('Duration: ${appointments[index].duration}'),
                  Text('Reason: ${appointments[index].reason}'),
                  Text('Status: ${appointments[index].status}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Appointment {
  final String doctorId;
  final String patientId;
  final String appointmentDate;
  final String appointmentTime;
  final String duration;
  final String reason;
  final String status;
  final String doctorImage;
  final String doctorName;

  Appointment({
    required this.doctorId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.duration,
    required this.reason,
    required this.status,
    required this.doctorImage,
    required this.doctorName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      appointmentDate: json['appointment_date'],
      appointmentTime: json['appointment_time'],
      duration: json['duration'],
      reason: json['reason'],
      status: json['status'],
      doctorImage: json['doctor_image'],
      doctorName: json['doctor_name'],
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailsScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display doctor's image at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                appointment.doctorImage,
                width: double.infinity, // Image spans full width
                height: 200, // Set the desired height
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Display appointment details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor: ${appointment.doctorName}'),
                Text('Doctor ID: ${appointment.doctorId}'),
                Text('Patient ID: ${appointment.patientId}'),
                Text('Date: ${appointment.appointmentDate}'),
                Text('Time: ${appointment.appointmentTime}'),
                Text('Duration: ${appointment.duration}'),
                Text('Reason: ${appointment.reason}'),
                Text('Status: ${appointment.status}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

