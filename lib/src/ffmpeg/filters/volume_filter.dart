import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Adjusts the volume of a given audio stream.
class VolumeFilter implements Filter {
  const VolumeFilter({
    required this.volume,
  });

  final double volume;

  @override
  String toCli() {
    return 'volume=$volume';
  }
}
