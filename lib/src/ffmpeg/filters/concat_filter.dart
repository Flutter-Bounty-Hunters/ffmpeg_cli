import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Combines a list of video and audio streams in series into a single set of
/// video and audio output streams.
class ConcatFilter implements Filter {
  ConcatFilter({
    required this.segmentCount,
    required this.outputVideoStreamCount,
    required this.outputAudioStreamCount,
  })  : assert(segmentCount > 0),
        assert(outputVideoStreamCount >= 0),
        assert(outputAudioStreamCount >= 0);

  /// Number of segments (defaults to 2)
  final int segmentCount;

  /// Number of output video streams
  final int outputVideoStreamCount;

  /// Number of output audio streams
  final int outputAudioStreamCount;

  @override
  String toCli() {
    return 'concat=n=$segmentCount:v=$outputVideoStreamCount:a=$outputAudioStreamCount';
  }
}
