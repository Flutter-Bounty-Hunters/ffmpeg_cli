import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Routes the input video stream to the output video stream
/// without any modifications.
class NullFilter implements Filter {
  const NullFilter();

  @override
  String toCli() {
    return 'null';
  }
}

/// Routes the input audio stream to the output audio stream
/// without any modifications.
class ANullFilter implements Filter {
  const ANullFilter();

  @override
  String toCli() {
    return 'anull';
  }
}
