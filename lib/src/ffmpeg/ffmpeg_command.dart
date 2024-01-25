import 'dart:io';

import 'package:ffmpeg_cli/src/ffmpeg/log_level.dart';

/// Dart wrappers for FFMPEG CLI commands, arguments, flags, and filters.

/// Executes FFMPEG commands from Dart.
class Ffmpeg {
  /// Executes the given [command].
  ///
  /// Provide a [ffmpegPath] to customize the path of the ffmpeg cli.
  /// If `null`, the "ffmpeg" from path is used.
  Future<Process> run(FfmpegCommand command, {String? ffmpegPath}) {
    return Process.start(
      ffmpegPath ?? 'ffmpeg',
      command.toCli(),
    );
  }
}

/// FFMPEG CLI command.
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
  const FfmpegCommand.complex({
    this.inputs = const [],
    this.args = const [],
    required this.filterGraph,
    required this.outputFilepath,
  });

  const FfmpegCommand.simple({
    this.inputs = const [],
    this.args = const [],
    required this.outputFilepath,
  }) : filterGraph = null;

  /// FFMPEG command inputs, such as assets and virtual devices.
  final List<FfmpegInput> inputs;

  /// All non-input arguments for the FFMPEG command, such as "map".
  final List<CliArg> args;

  /// The graph of filters that produce the final video.
  final FilterGraph? filterGraph;

  /// The file path for the rendered video.
  final String outputFilepath;

  /// Converts this command to a series of CLI arguments, which can be
  /// passed to a `Process` for execution.
  List<String> toCli() {
    return [
      for (final input in inputs) ...input.args,
      for (final arg in args) ...["-${arg.name}", if (arg.value != null) arg.value!],
      if (filterGraph != null) ...[
        '-filter_complex',
        filterGraph!.toCli(),
      ],
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
    for (final input in inputs) {
      buffer.writeln('  ${input.toCli()}');
    }
    for (final arg in args) {
      buffer.writeln('  ${arg.toCli()}');
    }
    if (filterGraph != null) {
      buffer.writeln('  -filter_complex ');
      buffer.writeln(filterGraph!.toCli(indent: '    '));
    }
    buffer.writeln('  $outputFilepath');

    return buffer.toString();
  }
}

/// An input into an FFMPEG filter graph.
///
/// An input might refer to a video file, audio file, or virtual device.
class FfmpegInput {
  /// Configures an FFMPEG input for an asset at the given [assetPath].
  FfmpegInput.asset(assetPath) : args = ['-i', assetPath];

  /// Configures an FFMPEG input for a virtual device.
  //
  /// See the FFMPEG docs for more information.
  FfmpegInput.virtualDevice(String device) : args = ['-f', 'lavfi', '-i', device];

  const FfmpegInput(this.args);

  /// List of CLI arguments that configure a single FFMPEG input.
  final List<String> args;

  /// Returns this input in a form that can be added to a CLI string.
  ///
  /// Example: "-i /videos/vid1.mp4"
  String toCli() => args.join(' ');

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FfmpegInput && runtimeType == other.runtimeType && toCli() == other.toCli();

  @override
  int get hashCode => toCli().hashCode;
}

/// An argument that is passed to the FFMPEG CLI command.
class CliArg {
  CliArg.logLevel(LogLevel level) : this(name: 'loglevel', value: level.toFfmpegString());

  const CliArg({
    required this.name,
    this.value,
  });

  final String name;
  final String? value;

  String toCli() => '-$name ${(value != null) ? value : ""}';
}

/// A filter graph that describes how FFMPEG should compose various assets
/// to form a final, rendered video.
///
/// FFMPEG filter graph syntax reference:
/// http://ffmpeg.org/ffmpeg-filters.html#Filtergraph-syntax-1
class FilterGraph {
  const FilterGraph({
    required this.chains,
  });

  final List<FilterChain> chains;

  /// Returns this filter graph in a form that can be run in a CLI command.
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
    this.inputs = const [],
    required this.filters,
    this.outputs = const [],
  });

  /// Streams that flow into the [filters].
  final List<FfmpegStream> inputs;

  /// Filters that apply to the [inputs], and generate the [outputs].
  final List<Filter> filters;

  /// New streams that flow out of the [filters], after applying those
  /// [filters] to the [inputs].
  final List<FfmpegStream> outputs;

  /// Formats this filter chain for the FFMPEG CLI.
  ///
  /// Format:
  /// [in1] [in2] [in3] filter1, filter2, [out1] [out2] [out3]
  ///
  /// Example:
  /// [0:0] trim=start='10':end='15' [out_v]
  String toCli() {
    return '${(inputs).map((stream) => stream.toString()).join(' ')} ${filters.map((filter) => filter.toCli()).join(', ')} ${(outputs).join(' ')}';
  }
}

/// A single video/audio stream pair within an FFMPEG filter graph.
///
/// A stream might include a video ID, or an audio ID, or both.
///
/// Every filter chain in an FFMPEG filter graph requires one or more
/// input streams, and produces one or more output streams. From a CLI
/// perspective, these streams are just string names within the filter
/// graph configuration. However, these string names need to match, as
/// outputs from one filter chain are used as inputs in another filter
/// chain. To that end, these streams are represented by this class.
class FfmpegStream {
  const FfmpegStream({
    this.videoId,
    this.audioId,
  }) : assert(videoId != null || audioId != null, "FfmpegStream must include a videoId, or an audioId.");

  /// Handle to a video stream, e.g., "[0:v]".
  final String? videoId;

  /// Handle to an audio stream, e.g., "[0:a]".
  final String? audioId;

  /// Returns a copy of this stream with just the video stream handle.
  ///
  /// If this stream only includes video, then this stream is returned.
  FfmpegStream get videoOnly {
    return audioId == null ? this : FfmpegStream(videoId: videoId);
  }

  /// Returns a copy of this stream with just the audio stream handle.
  ///
  /// If this stream only includes audio, then this stream is returned.
  FfmpegStream get audioOnly {
    return videoId == null ? this : FfmpegStream(audioId: audioId);
  }

  /// Returns the video and audio handles for this stream in a list,
  /// to pass into a filter graph as filter inputs or outputs, e.g.,
  /// "[0:v] [0:a]".
  List<String> toCliList() {
    final streams = <String>[];
    if (videoId != null) {
      streams.add(videoId!);
    }
    if (audioId != null) {
      streams.add(audioId!);
    }
    return streams;
  }

  @override
  String toString() => toCliList().join(" ");
}

/// An individual FFMPEG CLI filter, which can be composed within a filter
/// chain, within a broader filter graph.
///
/// Filters are the workhorse of FFMPEG. Any change or effect to a given
/// asset happens by way of a filter, e.g., trim, fade, concatenation, etc.
abstract class Filter {
  String toCli();
}
