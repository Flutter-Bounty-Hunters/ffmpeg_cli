import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Crops the input video to given dimensions.
class CropFilter implements Filter {
  const CropFilter({
    required this.width,
    required this.height,
    this.x,
    this.y,
  });

  /// Width of the output rectangle
  final int width;

  /// Height of the output rectangle
  final int height;

  /// x-position of the top left corner of the output rectangle
  final int? x;

  /// y-position of the top left corner of the output rectangle
  final int? y;

  // TODO: keep_aspect

  // TODO: exact

  @override
  String toCli() {
    return 'crop=$width:$height${x != null ? ':$x' : ''}${y != null ? ':$y' : ''}';
  }
}
