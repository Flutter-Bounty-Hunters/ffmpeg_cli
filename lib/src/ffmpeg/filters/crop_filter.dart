import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

class CropFilter implements Filter {
  const CropFilter(
      {required this.width,
      required this.height,
      this.x = double.infinity,
      this.y = double.infinity});

  final int width;
  final int height;
  final num x;
  final num y;
  // TODO: keep_aspect
  // TODO: exact

  @override
  String toCli() {
    return 'crop=$width:$height${x.isFinite ? ':$x' : ''}${y.isFinite ? ':$y' : ''}';
  }
}
