import 'package:result_dart/result_dart.dart';

import '../data/job_queue_entry.dart';

abstract class JobQueueRepository {
  Future<Result<List<JobQueueEntry>>> getJobQueue();
  Future<Result<void>> addJobQueueEntry();
}