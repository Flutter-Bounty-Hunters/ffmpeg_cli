import 'package:ffmpeg_cli/src/logging.dart';

import 'ffmpeg_command.dart';

/// Builds an [FfmpegCommand] by accumulating all inputs and filter
/// streams for a given command, and then generates the CLI arguments.
///
/// An [FfmpegCommand] can be constructed directly, but [FfmpegBuilder]
/// helps to ensure that all of your inputs have appropriate flags, and
/// all of your stream IDs match, where expected.
///
/// To build an [FfmpegCommand], first, ddd inputs with [addAsset],
/// [addNullVideo], [addNullAudio], [addVideoVirtualDevice], and
/// [addAudioVirtualDevice].
///
/// Configure the filter graph by creating streams with [createStream], and
/// then combine those [FfmpegStream]s with [Filter]s, into [FilterChain]s,
/// and add the [FilterChain]s with [addFilterChain].
///
/// Once you've added all inputs, and you've configured the filter graph,
/// create the [FfmpegCommand] with [build].
class FfmpegBuilder {
  // FFMPEG command inputs, e.g., assets.
  final Map<FfmpegInput, FfmpegStream> _inputs = <FfmpegInput, FfmpegStream>{};

  // FfmpegBuilder assigns unique IDs to streams by tracking the total
  // number of created streams, and then using the number after that.
  // Using incrementing IDs makes it easier to trace bugs, rather than
  // generate unrelated IDs for every stream.
  int _compositionStreamCount = 0;

  final List<FilterChain> _filterChains = [];

  /// Adds an input asset at the given [assetPath].
  ///
  /// If [hasVideo] is `true`, the asset is processed for video frames.
  /// If [hasAudio] is `true`, the asset is processed for audio streams.
  FfmpegStream addAsset(
    String assetPath, {
    bool hasVideo = true,
    bool hasAudio = true,
  }) {
    final input = FfmpegInput.asset(assetPath);

    // Generate video and audio stream IDs using the format that
    // FFMPEG expects.
    final videoId = hasVideo
        ? hasVideo && hasAudio
            ? '[${_inputs.length}:v]'
            : '[${_inputs.length}]'
        : null;
    final audioId = hasAudio
        ? hasVideo && hasAudio
            ? '[${_inputs.length}:a]'
            : '[${_inputs.length}]'
        : null;

    _inputs.putIfAbsent(
        input,
        () => FfmpegStream(
              videoId: videoId,
              audioId: audioId,
            ));

    return _inputs[input]!;
  }

  /// Adds a virtual video input asset with the given [width] and [height],
  /// which can be used to fill up time when no other video is available.
  FfmpegStream addNullVideo({
    required int width,
    required int height,
  }) {
    final input = FfmpegInput.virtualDevice('nullsrc=s=${width}x$height');
    final stream = _inputs.putIfAbsent(
        input,
        () => FfmpegStream(
              videoId: '[${_inputs.length}]',
              audioId: null,
            ));
    return stream;
  }

  /// Adds a virtual audio input asset, which can be used to fill audio
  /// when no other audio source is available.
  FfmpegStream addNullAudio() {
    final input = FfmpegInput.virtualDevice('anullsrc=sample_rate=48000');
    final stream = _inputs.putIfAbsent(
        input,
        () => FfmpegStream(
              videoId: null,
              audioId: '[${_inputs.length}]',
            ));
    return stream;
  }

  FfmpegStream addVideoVirtualDevice(String device) {
    final input = FfmpegInput.virtualDevice(device);
    final stream = _inputs.putIfAbsent(
        input,
        () => FfmpegStream(
              videoId: '[${_inputs.length}]',
              audioId: null,
            ));
    return stream;
  }

  FfmpegStream addAudioVirtualDevice(String device) {
    final input = FfmpegInput.virtualDevice(device);
    final stream = _inputs.putIfAbsent(
        input,
        () => FfmpegStream(
              videoId: null,
              audioId: '[${_inputs.length}]',
            ));
    return stream;
  }

  FfmpegStream createStream({bool hasVideo = true, bool hasAudio = true}) {
    final stream = FfmpegStream(
      videoId: hasVideo ? '[comp_${_compositionStreamCount}_v]' : null,
      audioId: hasAudio ? '[comp_${_compositionStreamCount}_a]' : null,
    );

    _compositionStreamCount += 1;

    return stream;
  }

  void addFilterChain(FilterChain chain) {
    _filterChains.add(chain);
  }

  /// Accumulates all the input assets and filter chains in this builder
  /// and returns an [FfmpegCommand] that generates a corresponding video,
  /// which is rendered to the given [outputFilepath].
  ///
  /// To run the command, see [FfmpegCommand].
  FfmpegCommand build({
    required List<CliArg> args,
    FfmpegStream? mainOutStream,
    required String outputFilepath,
  }) {
    ffmpegBuilderLog.info('Building command. Filter chains:');
    for (final chain in _filterChains) {
      ffmpegBuilderLog.info(' - ${chain.toCli()}');
    }

    ffmpegBuilderLog.info('Filter chains: $_filterChains');
    return FfmpegCommand.complex(
      inputs: _inputs.keys.toList(),
      args: args,
      filterGraph: FilterGraph(
        chains: _filterChains,
      ),
      outputFilepath: outputFilepath,
    );
  }
}
