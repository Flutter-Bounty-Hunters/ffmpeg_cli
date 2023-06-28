import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Adjusts the volume of a given audio stream based off new `volume` given.
class VolumeFilter implements Filter {
  const VolumeFilter({
    required this.volume,
  });

  /// Set audio volume
  final double volume;

  @override
  String toCli() {
    return 'volume=$volume';
  }
}
