enum Encoders {
  svt_av1,
  svt_av1_10bit,
  ffv1,
  x264,
  x264_10bit,
  vce_h264,
  nvenc_h264,
  x265,
  x265_10bit,
  x265_12bit,
  vce_h265,
  vce_h265_10bit,
  nvenc_h265,
  nvenc_h265_10bit,
  mpeg4,
  mpeg2,
  VP8,
  VP9,
  VP9_10bit,
  theora
}

Encoders parseEncoder(String input) => Encoders.values
    .firstWhere((Encoders e) => e.toString().split(".")[1] == input);

List<String> getEncoders() => new List<String>.from(
    Encoders.values.map((Encoders e) => e.toString().split(".")[1]),
    growable: false);
