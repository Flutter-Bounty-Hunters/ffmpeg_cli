import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

class CropFilter implements Filter {
  const CropFilter({
    required this.width,
    required this.height,
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
