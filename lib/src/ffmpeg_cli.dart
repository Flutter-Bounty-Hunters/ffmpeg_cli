import 'dart:io';

import 'package:superdeclarative_ffmpeg/flutter_ffmpeg.dart';

/// Dart wrappers for FFMPEG CLI commands, arguments, flags, and filters.

/// Orchestrates FFMPEG CLI execution.
class Ffmpeg {
  Future<Process> runWithFilterGraph({
    required FfmpegCommand command,
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
    required this.filterGraph,
    required this.outputFilepath,
  });

  final List<FfmpegInput> inputs;
  final List<CliArg> args;
  final FilterGraph filterGraph;
  final String outputFilepath;

  List<String> toCli() {
    if (filterGraph.chains.isEmpty) {
      throw Exception('Filter graph doesn\'t have any filter chains. Can\'t create CLI command. If you want to make a'
          ' direct copy of an asset, you\'ll need a different tool.');
    }

    return [
      for (final input in inputs) ...input.args,
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
    for (final input in inputs) {
      buffer.writeln('  ${input.toCli()}');
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

class FfmpegInput {
  FfmpegInput.asset(assetPath) : args = ['-i', assetPath];

  FfmpegInput.virtualDevice(String device) : args = ['-f', 'lavfi', '-i', device];

  FfmpegInput(this.args);

  final List<String> args;

  String toCli() => args.join(' ');

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FfmpegInput && runtimeType == other.runtimeType && toCli() == other.toCli();

  @override
  int get hashCode => toCli().hashCode;
}

/// An argument that is passed the FFMPEG CLI command.
class CliArg {
  CliArg.logLevel(LogLevel level) : this(name: 'loglevel', value: level.toFfmpegString());

  const CliArg({
    required this.name,
    required this.value,
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
    required this.chains,
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
    required this.inputs,
    required this.filters,
    required this.outputs,
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
