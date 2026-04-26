import 'package:flutter/material.dart';

import 'job_queue_page.dart';

class ParkingbrakeApp extends StatelessWidget {
  const ParkingbrakeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkingbrake',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      home: const JobQueuePage(title: 'Parkingbrake'),
    );
  }
}
