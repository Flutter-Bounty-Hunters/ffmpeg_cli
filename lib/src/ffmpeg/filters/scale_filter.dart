import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';
import 'package:ffmpeg_cli/src/ffmpeg/video_size.dart';

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

  final int? width;
  final int? height;
  final String? eval;
  final int? interl;
  // TODO: flags
  final String? param0;
  final String? param1;
  final VideoSize? size;
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
