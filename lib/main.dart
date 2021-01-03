import 'dart:convert';
import 'dart:io';

import 'package:superdeclarative_ffmpeg/src/ffprobe.dart';
import 'package:superdeclarative_ffmpeg/src/ffprobe_json.dart';

Future<void> main() async {
  print('Running ffprobe');
  // final result = await Process.run('ffprobe', [
  //   '-v',
  //   'quiet',
  //   '-print_format',
  //   'json',
  //   '-show_format',
  //   '-show_streams',
  //   './assets/test_video.mp4',
  // ]);

  // print('Done running ffprobe: $result');
  // print(' - exit code: ${result.exitCode}');
  // print(' - stdout: ${result.stdout}');
  // print(' - stderr: ${result.stderr}');

  // print(result.stdout);
  // print('');
  // print('');

  // final resultJson = jsonDecode(result.stdout);
  // final ffprobeResult = FfprobeResult.fromJson(resultJson);
  // print(ffprobeResult.format.filename);
  // print('');

  final result = await Ffprobe.run('./assets/test_video.mp4');
  print(result.toString());

  print('DONE');
}
