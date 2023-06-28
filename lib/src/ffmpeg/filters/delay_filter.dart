import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Delays a given audio stream.
class ADelayFilter implements Filter {
  const ADelayFilter({
    required this.delays,
  });

  /// The delay for each audio stream in order
  final List<Duration> delays;

  @override
  String toCli() {
    return 'adelay=${delays.map((delay) => (delay.inMilliseconds)).join('|')}';
  }
}
