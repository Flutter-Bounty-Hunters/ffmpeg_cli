import 'ffmpeg_cli.dart';
import 'time.dart';

/// Reduces a given video stream to the segment between `start` and `end`.
class TrimFilter implements Filter {
  const TrimFilter({
    this.start,
    this.end,
    this.duration,
  });

  final Duration start;
  final Duration end;
  final Duration duration;

  @override
  String toCli() {
    final properties = <String>[];
    if (start != null) {
      properties.add("start='${FfmpegTimeDuration(start).toSeconds()}'");
    }
    if (end != null) {
      properties.add("end='${FfmpegTimeDuration(end).toSeconds()}'");
    }
    if (duration != null) {
      properties.add("duration='${FfmpegTimeDuration(duration).toSeconds()}'");
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

  final Duration start;
  final Duration end;
  final Duration duration;

  @override
  String toCli() {
    final properties = <String>[];
    if (start != null) {
      properties.add("start='${FfmpegTimeDuration(start).toSeconds()}'");
    }
    if (end != null) {
      properties.add("end='${FfmpegTimeDuration(end).toSeconds()}'");
    }
    if (duration != null) {
      properties.add("duration='${FfmpegTimeDuration(duration).toSeconds()}'");
    }
    return "atrim=${properties.join(':')}";
  }
}

/// Converts the input video stream to the specified constant frame rate
/// by duplicating or dropping frames as necessary.
class FpsFilter implements Filter {
  FpsFilter({
    this.fps,
    this.startTime,
    this.round,
    this.eofAction,
  })  : assert(fps != null && fps > 0),
        assert(round == null || const ['zero', 'inf', 'down', 'up', 'near'].contains(round)),
        assert(eofAction == null || const ['round', 'pass'].contains(eofAction));

  final int fps;
  final FfmpegTimeDuration startTime;
  final String round;
  final String eofAction;

  @override
  String toCli() {
    final properties = <String>[
      'fps=$fps',
      if (startTime != null) "start_time='${startTime.toSeconds()}'",
      if (round != null) 'round=$round',
      if (eofAction != null) 'eof_action=$eofAction',
    ];

    return 'fps${properties.isNotEmpty ? '=${properties.join(':')}' : ''}';
  }
}

/// Sets the Sample Aspect Ratio for the filter output video.
class SetSarFilter implements Filter {
  SetSarFilter({
    this.sar,
  }) : assert(sar != null && sar.isNotEmpty);

  final String sar;

  @override
  String toCli() {
    return 'setsar=$sar';
  }
}

class ScaleFilter implements Filter {
  ScaleFilter({
    this.width,
    this.height,
    this.eval,
    this.interl,
    this.param0,
    this.param1,
    this.size,
  })  : assert(width == null || width >= -1),
        assert(height == null || height >= -1);

  final int width;
  final int height;
  final String eval;
  final int interl;
  // TODO: flags
  final String param0;
  final String param1;
  final VideoSize size;
  // TODO: in_color_matrix
  // TODO: out_color_matrix
  // TODO: in_range
  // TODO: out_range
  // TODO: force_original_aspect_ratio
  // TODO: force_divisible_by

  @override
  String toCli() {
    final properties = [
      if (width != null) 'width=$width',
      if (height != null) 'height=$height',
      if (eval != null) 'eval=$eval',
      if (interl != null) 'interl=$interl',
      if (param0 != null) 'param0=$param0',
      if (param1 != null) 'param1=$param1',
      if (size != null) 'size=$size',
    ];

    return 'scale=${properties.join(':')}';
  }
}

class SwsFlag {
  static const fastBilinear = SwsFlag._('fast_bilinear');
  static const bilinear = SwsFlag._('bilinear');
  static const bicubic = SwsFlag._('bicubic');
  static const experimental = SwsFlag._('experimental');
  static const neighbor = SwsFlag._('neighbor');
  static const area = SwsFlag._('area');
  static const bicublin = SwsFlag._('bicublin');
  static const gauss = SwsFlag._('gauss');
  static const sinc = SwsFlag._('sinc');
  static const lanczos = SwsFlag._('lanczos');
  static const spline = SwsFlag._('spline');
  static const printInfo = SwsFlag._('print_info');
  static const accurateRnd = SwsFlag._('accurate_rnd');
  static const fullChromaInt = SwsFlag._('full_chroma_int');
  static const fullChromaInp = SwsFlag._('full_chroma_inp');
  static const bitexact = SwsFlag._('bitexact');

  const SwsFlag._(this.cliValue);

  final String cliValue;

  String toCli() => cliValue;
}

class CropFilter implements Filter {
  const CropFilter({
    this.width,
    this.height,
  });

  final int width;
  final int height;
  // TODO: x
  // TODO: y
  // TODO: keep_aspect
  // TODO: exact

  @override
  String toCli() {
    return 'crop=out_w=$width:out_h=$height';
  }
}

/// Sets the Presentation TimeStamp (PTS) for the given video stream.
///
/// When trimming a video to a subsection, it's important to also set the
/// PTS of the trimmed video to `"PTS-STARTPTS"` to avoid an empty gap
/// before the start of the trimmed video.
class SetPtsFilter implements Filter {
  const SetPtsFilter.startPts() : this(pts: 'PTS-STARTPTS');

  const SetPtsFilter({this.pts});

  final String pts;

  @override
  String toCli() => "setpts=$pts";
}

/// Sets the Presentation TimeStamp (PTS) for the given audio stream.
class ASetPtsFilter implements Filter {
  const ASetPtsFilter.startPts() : this(pts: 'PTS-STARTPTS');

  const ASetPtsFilter({this.pts});

  final String pts;

  @override
  String toCli() => "asetpts=$pts";
}

/// Combines a list of video and audio streams in series into a single set of
/// video and audio output streams.
class ConcatFilter implements Filter {
  ConcatFilter({
    this.segmentCount,
    this.outputVideoStreamCount,
    this.outputAudioStreamCount,
  })  : assert(segmentCount != null && segmentCount > 0),
        assert(outputVideoStreamCount != null && outputVideoStreamCount >= 0),
        assert(outputAudioStreamCount != null && outputAudioStreamCount >= 0);

  final int segmentCount;
  final int outputVideoStreamCount;
  final int outputAudioStreamCount;

  @override
  String toCli() {
    return 'concat=n=$segmentCount:v=$outputVideoStreamCount:a=$outputAudioStreamCount';
  }
}

/// Adds padding frames to a given video stream.
///
/// `start`   number of frames to add before video content.
///
/// `stop`    number of frames to add after video content.
///
/// `start_mode`  kind of frames added to beginning of stream
///
/// `stop_mode`   kind of frames added to end of stream
///
/// `start_duration`  time delay added before playing the stream
///
/// `stop_duration`   time delay added after end of the stream
///
/// `color`   color of padded frames.
class TPadFilter implements Filter {
  const TPadFilter({
    this.start,
    this.stop,
    this.startDuration,
    this.stopDuration,
    this.startMode,
    this.stopMode,
    this.color,
  })  : assert(startMode == null || startMode == 'add' || startMode == 'clone'),
        assert(stopMode == null || stopMode == 'add' || stopMode == 'clone');

  final int start;
  final int stop;
  final FfmpegTimeDuration startDuration;
  final FfmpegTimeDuration stopDuration;
  final String startMode;
  final String stopMode;
  final String color;

  @override
  String toCli() {
    final argList = <String>[];
    if (start != null) {
      argList.add('start=$start');
    }
    if (stop != null) {
      argList.add('stop=$stop');
    }
    if (startDuration != null) {
      argList.add('start_duration=${startDuration.toSeconds()}');
    }
    if (stopDuration != null) {
      argList.add('stop_duration=${stopDuration.toSeconds()}');
    }
    if (startMode != null) {
      argList.add('start_mode=$startMode');
    }
    if (stopMode != null) {
      argList.add('stop_mode=$stopMode');
    }
    if (color != null) {
      argList.add('color=$color');
    }

    return 'tpad=${argList.join(':')}';
  }
}

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

/// Delays a given audio stream.
class ADelayFilter implements Filter {
  const ADelayFilter({
    this.delay,
  });

  final FfmpegTimeDuration delay;

  @override
  String toCli() {
    return 'adelay=${delay.duration.inMilliseconds}|${delay.duration.inMilliseconds}';
  }
}

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

  final String type;
  final String startFrame;
  final String nbFrames;
  final int alpha;
  final FfmpegTimeDuration startTime;
  final FfmpegTimeDuration duration;
  final String color;

  @override
  String toCli() {
    final properties = <String>[
      if (type != null) 'type=$type',
      if (alpha != null) 'alpha=$alpha',
      if (startFrame != null) 'start_frame=$startFrame',
      if (nbFrames != null) 'nb_frames=$nbFrames',
      if (startTime != null) 'start_time=${startTime.toSeconds()}',
      if (duration != null) 'duration=${duration.toSeconds()}',
      if (color != null) 'color=$color',
    ];

    return 'fade${properties.isNotEmpty ? '=${properties.join(':')}' : ''}';
  }
}

/// Fades a given audio stream.
class AFadeFilter implements Filter {
  const AFadeFilter({
    this.type,
    this.startTime,
    this.duration,
  }) : assert(type == 'in' || type == 'out');

  final String type;
  final FfmpegTimeDuration startTime;
  final FfmpegTimeDuration duration;

  @override
  String toCli() {
    final argList = <String>[
      'type=$type',
    ];
    if (startTime != null) {
      argList.add('start_time=${startTime.toSeconds()}');
    }
    if (duration != null) {
      argList.add('duration=${duration.toSeconds()}');
    }

    return 'afade=${argList.join(':')}';
  }
}

/// Mixes multiple audio streams together into one.
///
/// I think this will automatically cut the volume of each input proportional
/// to the number of inputs, e.g., 1/2 volume for 2 inputs, 1/3 volume for 3
/// inputs.
class AMixFilter implements Filter {
  const AMixFilter({
    this.inputs,
  });

  final int inputs;

  @override
  String toCli() {
    return 'amix=inputs=$inputs';
  }
}

/// Adjusts the volume of a given audio stream.
class VolumeFilter implements Filter {
  const VolumeFilter({
    this.volume,
  });

  final double volume;

  @override
  String toCli() {
    return 'volume=$volume';
  }
}

/// Copies the input video stream to the output video stream.
class CopyFilter implements Filter {
  const CopyFilter();

  @override
  String toCli() {
    return 'copy';
  }
}

/// Copies the input audio stream to the output audio stream.
class ACopyFilter implements Filter {
  const ACopyFilter();

  @override
  String toCli() {
    return 'acopy';
  }
}

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

/// Uses the `cliValue` as a literal representation of an FFMPEG
/// CLI filter, in the case that such a filter is not currently
/// available as a `Filter` in this package.
class RawFilter implements Filter {
  RawFilter(this.cliValue);

  final String cliValue;

  @override
  String toCli() => cliValue;
}

class VideoSize {
  const VideoSize({
    this.width,
    this.height,
  });

  final num width;
  final num height;

  @override
  String toString() => '[Size]: ${width}x$height';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSize && runtimeType == other.runtimeType && width == other.width && height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}
