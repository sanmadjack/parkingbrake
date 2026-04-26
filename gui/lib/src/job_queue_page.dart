import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gui/src/data/job_queue_entry.dart';
import 'package:flutter_gui/src/job_page.dart';
import 'package:flutter_gui/src/repositories/job_queue_repository.dart';
import 'package:provider/provider.dart';

class JobQueuePage extends StatefulWidget {
  const JobQueuePage({super.key, required this.title});

  final String title;

  @override
  State<JobQueuePage> createState() => _JobQueuePageState();
}

class _JobQueuePageState extends State<JobQueuePage> {
  List<JobQueueEntry> _jobQueue = [];

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _addEntry() async {
    final JobQueueRepository repo = context.read();
    await repo.addJobQueueEntry();
  }

  Future<void> _refresh() async {
    final JobQueueRepository repo = context.read();
    var result = await repo.getJobQueue();
    setState(() {
      _jobQueue = result.getOrDefault([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ListView.separated(
        itemCount: _jobQueue.length,
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            color: (_jobQueue[index].status == "active"
                ? Colors.amber
                : (_jobQueue[index].status == "complete"
                      ? Colors.green
                      : (_jobQueue[index].status == "issue"
                            ? Colors.red
                            : Colors.white))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Entry ${_jobQueue[index].name}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JobPage(entry: _jobQueue[index]),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info),
                    ),
                  ],
                ),
                LinearProgressIndicator(value: _jobQueue[index].progress),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
