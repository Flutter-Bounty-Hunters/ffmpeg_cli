import 'package:ffmpeg_cli/ffmpeg_cli.dart';

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

  /// Effect type (default is in)
  final String? type;

  /// The frame to start the fade effect (default is 0)
  final String? startFrame;

  /// The number of frames that the effect lasts (default is 25)
  final String? nbFrames;

  /// Fade only alpha channel
  final int? alpha;

  /// The timestamp of the frame to start the fade effect (default is 0)
  final Duration? startTime;

  /// The number of seconds for which the fade effect lasts
  final Duration? duration;

  /// The color of the fade (default is black)
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
  const AFadeFilter(
      {required this.type, this.startTime, this.duration, this.curve})
      : assert(type == 'in' || type == 'out');

  /// Effect type (default is in)
  final String type;

  /// The timestamp of the frame to start the fade effect (default is 0)
  final Duration? startTime;

  /// The number of seconds for which the fade effect lasts
  final Duration? duration;

  /// The curve for the fade transition
  final AFadeCurve? curve;

  @override
  String toCli() {
    final argList = <String>[
      'type=$type',
      if (startTime != null) 'start_time=${startTime!.toSeconds()}',
      if (duration != null) 'duration=${duration!.toSeconds()}',
      if (curve != null) 'curve=$curve'
    ];

    return 'afade=${argList.join(':')}';
  }
}
