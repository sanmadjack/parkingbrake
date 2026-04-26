import 'package:flutter/material.dart';
import 'package:flutter_gui/src/repositories/job_queue_repository.dart';
import 'package:flutter_gui/src/repositories/job_queue_repository_local.dart';
import 'package:flutter_gui/src/repositories/job_queue_repository_remote.dart';
import 'package:flutter_gui/src/rpc_service.dart';
import 'package:provider/provider.dart';

import 'src/parkingbrake_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => RpcService()),
        Provider<JobQueueRepository>(
          create: (context) {
            if (true) {
              // This means we're running through the server
              return JobQueueRepositoryRemote(rpcService: context.read());
            }
            return JobQueueRepositoryLocal();
          },
        ),
      ],
      child: const ParkingbrakeApp(),
    ),
  );
}
