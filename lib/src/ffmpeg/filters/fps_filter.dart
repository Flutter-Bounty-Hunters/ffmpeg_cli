import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';
import 'package:ffmpeg_cli/src/time.dart';

/// Converts the input video stream to the specified constant frame rate
/// by duplicating or dropping frames as necessary.
class FpsFilter implements Filter {
  FpsFilter({
    required this.fps,
    this.startTime,
    this.round,
    this.eofAction,
  })  : assert(fps > 0),
        assert(round == null || const ['zero', 'inf', 'down', 'up', 'near'].contains(round)),
        assert(eofAction == null || const ['round', 'pass'].contains(eofAction));

  final int fps;
  final Duration? startTime;
  final String? round;
  final String? eofAction;

  @override
  String toCli() {
    final properties = <String>[
      'fps=$fps',
      if (startTime != null) "start_time='${startTime!.toSeconds()}'",
      if (round != null) 'round=$round',
      if (eofAction != null) 'eof_action=$eofAction',
    ];

    return 'fps${properties.isNotEmpty ? '=${properties.join(':')}' : ''}';
  }
}
