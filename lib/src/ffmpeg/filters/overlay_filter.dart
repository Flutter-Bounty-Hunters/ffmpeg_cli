import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Overlays one video on top of another.
///
/// First video stream is the "main" and the second video stream is the "overlay".
class OverlayFilter implements Filter {
  const OverlayFilter();

  @override
  String toCli() {
    return 'overlay';
  }
}
