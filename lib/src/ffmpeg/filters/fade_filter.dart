import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';
import 'package:ffmpeg_cli/src/time.dart';

/// Fades a given video stream.
class FadeFilter implements Filter {
  const FadeFilter({
    this.type,
    this.startFrame,
    this.nbFrames,
    this.alpha,
    this.startTime,
    this.duration,
    this.color,
  })  : assert(type == 'in' || type == 'out'),
        assert(alpha == null || alpha == 0 || alpha == 1);

  final String? type;
  final String? startFrame;
  final String? nbFrames;
  final int? alpha;
  final Duration? startTime;
  final Duration? duration;
  final String? color;

  @override
  String toCli() {
    final properties = <String>[
      if (type != null) 'type=$type',
      if (alpha != null) 'alpha=$alpha',
      if (startFrame != null) 'start_frame=$startFrame',
      if (nbFrames != null) 'nb_frames=$nbFrames',
      if (startTime != null) 'start_time=${startTime!.toSeconds()}',
      if (duration != null) 'duration=${duration!.toSeconds()}',
      if (color != null) 'color=$color',
    ];

    return 'fade${properties.isNotEmpty ? '=${properties.join(':')}' : ''}';
  }
}

/// Fades a given audio stream.
class AFadeFilter implements Filter {
  const AFadeFilter({
    required this.type,
    this.startTime,
    this.duration,
  }) : assert(type == 'in' || type == 'out');

  final String type;
  final Duration? startTime;
  final Duration? duration;

  @override
  String toCli() {
    final argList = <String>[
      'type=$type',
    ];
    if (startTime != null) {
      argList.add('start_time=${startTime!.toSeconds()}');
    }
    if (duration != null) {
      argList.add('duration=${duration!.toSeconds()}');
    }

    return 'afade=${argList.join(':')}';
  }
}
