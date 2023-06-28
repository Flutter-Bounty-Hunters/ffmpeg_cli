import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Copies the input video stream (unchanged) to the output video stream.
class CopyFilter implements Filter {
  const CopyFilter();

  @override
  String toCli() {
    return 'copy';
  }
}

/// Copies the input audio stream (unchanged) to the output audio stream.
class ACopyFilter implements Filter {
  const ACopyFilter();

  @override
  String toCli() {
    return 'acopy';
  }
}
