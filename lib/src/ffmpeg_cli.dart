import 'dart:io';

import 'package:superdeclarative_ffmpeg/flutter_ffmpeg.dart';

/// Dart wrappers for FFMPEG CLI commands, arguments, flags, and filters.

/// Orchestrates FFMPEG CLI execution.
class Ffmpeg {
  Future<Process> runWithFilterGraph({
    FfmpegCommand command,
  }) {
    return Process.start(
      'ffmpeg',
      command.toCli(),
    );
  }
}

/// FFMPEG CLI primary command.
///
/// The `ffmpeg` CLI command is the primary CLI tool for FFMPEG. This class
/// is a Dart wrapper around that command.
///
/// `inputs`          should include all video, audio, image, and other assets
///                   that are referenced in the desired command.
///
/// `args`            should include all CLI arguments for the desired command.
///
/// `filterGraph`     describes how the assets should be composed to form the
///                   final video.
///
/// `outputFilepath`  is the path to where the final video should be stored
class FfmpegCommand {
  FfmpegCommand({
    this.inputs = const [],
    this.args = const [],
    this.filterGraph,
    this.outputFilepath,
  });

  final List<String> inputs;
  final List<CliArg> args;
  final FilterGraph filterGraph;
  final String outputFilepath;

  List<String> toCli() {
    return [
      for (final input in inputs) ...[
        '-i',
        input,
      ],
      for (final arg in args) ...[
        '-${arg.name}',
        arg.value,
      ],
      '-filter_complex', filterGraph.toCli(), // filter graph
      outputFilepath,
    ];
  }

  /// Returns a string that represents what this command is expected to
  /// look like when run by a `Process`.
  ///
  /// This method is provided for debugging purposes because we can't see
  /// what command is actually running in the `Process`.
  String expectedCliInput() {
    final buffer = StringBuffer('ffmpeg\n');
    for (String input in inputs) {
      buffer.writeln('  -i $input');
    }
    for (final arg in args) {
      buffer.writeln('  ${arg.toCli()}');
    }
    buffer.writeln('  -filter_complex ');
    buffer.writeln(filterGraph.toCli(indent: '    '));
    buffer.writeln('  $outputFilepath');

    return buffer.toString();
  }
}

/// An argument that is passed the FFMPEG CLI command.
class CliArg {
  CliArg.logLevel(LogLevel level) : this(name: 'loglevel', value: level.toFfmpegString());

  const CliArg({
    this.name,
    this.value,
  });

  final String name;
  final String value;

  String toCli() => '-$name $value';
}

/// A filter graph that describes how FFMPEG should compose various assets
/// to form a final, rendered video.
///
/// FFMPEG filter graph syntax reference:
/// http://ffmpeg.org/ffmpeg-filters.html#Filtergraph-syntax-1
class FilterGraph {
  const FilterGraph({
    this.chains,
  });

  final List<FilterChain> chains;

  String toCli({indent = ''}) {
    return chains.map((chain) => indent + chain.toCli()).join('; \n');
  }
}

/// A single pipeline of operations within a larger filter graph.
///
/// A filter chain has some number of input streams, those streams then
/// have some number of filters applied to them in the given order, and
/// those filters then produce some number of output streams.
class FilterChain {
  const FilterChain({
    this.inputs,
    this.filters,
    this.outputs,
  });

  final List<String> inputs;
  final List<Filter> filters;
  final List<String> outputs;

  /// Formats this filter chain for the FFMPEG CLI.
  ///
  /// Format:
  /// [in1] [in2] [in3] filter1, filter2, [out1] [out2] [out3]
  ///
  /// Example:
  /// [0:0] trim=start='10':end='15' [out_v]
  String toCli() => '${inputs.join(' ')} ${filters.map((filter) => filter.toCli()).join(', ')} ${outputs.join(' ')}';
}

/// An individual FFMPEG CLI filter, which can be composed within a filter
/// chain, within a broader filter graph.
///
/// Filters are the workhorse of FFMPEG. Any change or effect to a given
/// asset happens by way of a filter, e.g., trim, fade, concatenation, etc.
abstract class Filter {
  String toCli();
}

/// Reduces a given video stream to the segment between `start` and `end`.
class TrimFilter implements Filter {
  const TrimFilter({
    this.start,
    this.end,
  });

  final Duration start;
  final Duration end;

  @override
  String toCli() =>
      "trim=start='${FfmpegTimeDuration(start).toSeconds()}':end='${FfmpegTimeDuration(end).toSeconds()}'";
}

/// Reduces a given audio stream to the segment between `start` and `end`.
class ATrimFilter implements Filter {
  const ATrimFilter({
    this.start,
    this.end,
  });

  final Duration start;
  final Duration end;

  @override
  String toCli() =>
      "atrim=start='${FfmpegTimeDuration(start).toSeconds()}':end='${FfmpegTimeDuration(end).toSeconds()}'";
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
/// `color`   color of padded frames.
class TPadFilter implements Filter {
  const TPadFilter({
    this.start,
    this.stop,
    this.color,
  });

  final FfmpegTimeDuration start;
  final FfmpegTimeDuration stop;
  final String color;

  @override
  String toCli() {
    final argList = <String>[];
    if (start != null) {
      argList.add('start_duration=${start.toSeconds()}');
    }
    if (stop != null) {
      argList.add('stop_duration=${stop.toSeconds()}');
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

/// Fades a given audio stream.
class AFade implements Filter {
  const AFade({
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

enum LogLevel {
  quiet,
  panic,
  fatal,
  error,
  warning,
  info,
  verbose,
  debug,
  trace,
}

extension on LogLevel {
  String toFfmpegString() {
    switch (this) {
      case LogLevel.quiet:
        return 'quiet';
      case LogLevel.panic:
        return 'panic';
      case LogLevel.fatal:
        return 'fatal';
      case LogLevel.error:
        return 'error';
      case LogLevel.warning:
        return 'warning';
      case LogLevel.info:
        return 'info';
      case LogLevel.verbose:
        return 'verbose';
      case LogLevel.debug:
        return 'debug';
      case LogLevel.trace:
        return 'trace';
    }
  }
}
