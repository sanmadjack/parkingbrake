import 'package:parkingbrake_server/enums/audio_encoders.dart';
import 'package:parkingbrake_server/enums/mixdowns.dart';

import 'enums/encoders.dart';

class EncodingSettings {
  Encoders encoder = Encoders.x264;
  String preset = "medium";

  AudioEncoders audioEncoder = AudioEncoders.opus;
  Mixdowns mixdown = Mixdowns.s7point1;

  bool multiPass = true;
  bool decomb = true;
  bool detelecine = true;
  bool autoAnamorphic = true;
  bool autoCrop = true;

  int width = 0, height = 0, quality = 24, audioQuality = 8;

  EncodingSettings();

  EncodingSettings.fromJson(Map data) {
    applySettings(data);
  }

  void applySettings(Map data) {
    for (String key in data.keys) {
      switch (key) {
        case "encoder":
          encoder = parseEncoder(data[key]);
          break;
        case "preset":
          preset = data[key];
          break;
        case "quality":
          quality = int.parse(data[key].toString());
          break;
        case "multi_pass":
          multiPass = data[key].toString() == "true";
          break;
        case "decomb":
          decomb = data[key].toString() == "true";
          break;
        case "detelecine":
          detelecine = data[key].toString() == "true";
          break;
        case "height":
          height = int.parse(data[key].toString());
          break;
        case "width":
          width = int.parse(data[key].toString());
          break;
        case "audio_encoder":
          audioEncoder = parseAudioEncoder(data[key].toString());
          break;
        case "audio_quality":
          audioQuality = int.parse(data[key].toString());
          break;
        case "mixdown":
          mixdown = parseMixdown(data[key].toString());
          break;
        case "auto_anamorphic":
          autoAnamorphic = data[key].toString() == "true";
          break;
        case "auto_crop":
          autoCrop = data[key].toString() == "true";
          break;
      }
    }
  }

  Map toJson() {
    Map<String, dynamic> output = <String, dynamic>{};
    output["encoder"] = encoder.toString().split(".")[1];

    return output;
  }

  @override
  String toString() => toProcessArgs().join(" ");

  List<String> toProcessArgs() {
    List<String> output = <String>[];

    String mixdownString = mixdown.toString().split(".")[1];
    if (mixdownString.startsWith("s")) {
      // Enums can't start with a number, so I prefixed the surround mixes with s,
      // this strips that s out before sending it to handbrake
      mixdownString = mixdownString.substring(1);
    }

    output.addAll([
      '--min-duration',
      '0',
      '--format',
      'av_mkv',
      '--markers',
      '--encoder',
      encoder.toString().split(".")[1],
      '--encoder-preset',
      preset,
      '--encoder-profile',
      'auto',
      '--quality',
      quality.toString(),
      '--vfr',
      '--aencoder',
      audioEncoder.toString().split(".")[1],
      '--mixdown',
      mixdownString,
      '--aq',
      audioQuality.toString(),
      '--no-hqdn3d',
      '--no-nlmeans',
      '--no-unsharp',
      '--no-lapsharp',
      '--no-deblock',
    ]);

    if (!autoCrop) {
      output.addAll(['--crop', '0:0:0:0']);
    }

    if (autoAnamorphic) {
      output.add('--auto-anamorphic');
    }

    if (decomb) {
      output.add('--decomb');
    }
    if (detelecine) {
      output.add('--comb-detect');
      output.add('--detelecine');
    }

    if (multiPass) {
      output.add('--multi-pass');
    }

    if (width > 0) {
      output.addAll(["--width", width.toString()]);
    }
    if (height > 0) {
      output.addAll(["--height", height.toString()]);
    }

    return output;
  }
}

class AudioTrackEncodingSettings {
  Encoders encoder = Encoders.x265;
}
