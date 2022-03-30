import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';
import 'package:ffmpeg_cli/src/time.dart';

/// Delays a given audio stream.
class ADelayFilter implements Filter {
  const ADelayFilter({
    required this.delay,
  });

  final Duration delay;

  @override
  String toCli() {
    return 'adelay=${delay.inMilliseconds}|${delay.inMilliseconds}';
  }
}
