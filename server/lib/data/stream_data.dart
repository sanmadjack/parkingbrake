import '../enums/stream_types.dart';
//import 'package:logging/logging.dart';

class StreamData {
  //static final Logger _log = Logger('StreamData');
  int? index;
  String? codec, profile;
  int? width, height;
  StreamTypes? type;
  String? language;
  int? channels;
  String? duration;

  Map toJson() => {
        'index': index,
        'codec': codec,
        'type': type.toString().split(".")[1],
        'width': width,
        'height': height,
        'language': language,
        'channels': channels
      };
}

