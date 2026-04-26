import 'dart:convert';

class JobQueueEntry {
  String id = "";
  String path = "";
  String name = "";
  String status = "";
  double progress = 0;
  Duration? duration;
  int size = 0;

  Map rawData = {};

  int get percent => (progress * 100).round();

  JobQueueEntry({
    required this.id,
    required this.path,
    required this.name,
    required this.status,
    required this.progress,
    required this.size,
    required num dur,
  }) {
    rawData = {};
    duration = Duration(milliseconds: dur.toInt() * 1000);
  }

  JobQueueEntry.fromJson(Map data) {
    id = data['id'];
    path = data['path'];
    name = data['name'];
    status = data['status'];
    progress = data["progress"];
    num dur = data["duration"];
    duration = Duration(milliseconds: dur.toInt() * 1000);
    size = data["size"];
    rawData = data;
  }

  final JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  @override
  String toString() =>
      (rawData.isEmpty ? "No raw data" : _encoder.convert(rawData));

  static const Map<String, int> _conversions = <String, int>{
    "GB": 1073741824,
    "MB": 1048576,
    "KB": 1024,
    "B": 1,
  };

  String get sizeString {
    for (String key in _conversions.keys) {
      if (size >= _conversions[key]!) {
        return "${(size / _conversions[key]!).toStringAsFixed(2)}$key";
      }
    }
    return "${size}B";
  }
}
