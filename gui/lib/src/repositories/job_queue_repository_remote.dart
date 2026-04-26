import 'package:flutter_gui/src/repositories/job_queue_repository.dart';
import 'package:flutter_gui/src/rpc_service.dart';
import 'package:result_dart/result_dart.dart';

import '../data/job_queue_entry.dart';

class JobQueueRepositoryRemote implements JobQueueRepository {
  JobQueueRepositoryRemote({
    required RpcService rpcService
  }): _rpcService = rpcService;

  final RpcService _rpcService;

  Future<Result<List<JobQueueEntry>>> getJobQueue() async {
    try {
      var result = await _rpcService.getJobQueue(); 
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void>> addJobQueueEntry() async { return Success(0);}


}