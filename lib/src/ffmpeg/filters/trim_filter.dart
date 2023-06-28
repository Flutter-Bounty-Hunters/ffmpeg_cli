import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';
import 'package:ffmpeg_cli/src/time.dart';

/// Reduces a given video stream to the segment between `start` and `end`.
class TrimFilter implements Filter {
  const TrimFilter({
    this.start,
    this.end,
    this.duration,
  });

  /// The time of the start of the kept section
  final Duration? start;

  /// The time of the first frame that will be dropped
  final Duration? end;

  /// The maximum duration of the output in seconds
  final Duration? duration;

  @override
  String toCli() {
    final properties = <String>[];
    if (start != null) {
      properties.add("start='${start!.toSeconds()}'");
    }
    if (end != null) {
      properties.add("end='${end!.toSeconds()}'");
    }
    if (duration != null) {
      properties.add("duration='${duration!.toSeconds()}'");
    }
    return "trim=${properties.join(':')}";
  }
}

/// Reduces a given audio stream to the segment between `start` and `end`.
class ATrimFilter implements Filter {
  const ATrimFilter({
    this.start,
    this.end,
    this.duration,
  });

  /// The time of the start of the kept section
  final Duration? start;

  /// The time of the first frame that will be dropped
  final Duration? end;

  /// The maximum duration of the output in seconds
  final Duration? duration;

  @override
  String toCli() {
    final properties = <String>[];
    if (start != null) {
      properties.add("start='${start!.toSeconds()}'");
    }
    if (end != null) {
      properties.add("end='${end!.toSeconds()}'");
    }
    if (duration != null) {
      properties.add("duration='${duration!.toSeconds()}'");
    }
    return "atrim=${properties.join(':')}";
  }
}
