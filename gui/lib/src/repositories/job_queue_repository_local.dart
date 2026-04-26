import 'dart:math';

import 'package:flutter_gui/src/repositories/job_queue_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';

import '../data/job_queue_entry.dart';

class JobQueueRepositoryLocal implements JobQueueRepository {
  List<JobQueueEntry> _data = <JobQueueEntry>[];

  final List<String> states = ["complete", "pending", "issue", "active"];

  JobQueueRepositoryLocal() {
    _data.add(_generateEntry());
  }

  String _generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89),
    );
  }

  JobQueueEntry _generateEntry() {
    var r = Random();
    return JobQueueEntry(
      id: Uuid().v4(),
      dur: r.nextInt(255),
      name: _generateRandomString(255),
      path: _generateRandomString(255),
      progress: r.nextDouble(),
      size: r.nextInt(255),
      status: states[r.nextInt(4)],
    );
  }

  @override
  Future<Result<List<JobQueueEntry>>> getJobQueue() async {
    try {
      return Success(_data);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<int>> addJobQueueEntry() async {
    try {
      _data.add(_generateEntry());

      return Success(0);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
