import 'package:ffmpeg_cli/ffmpeg_cli.dart';
import 'package:ffmpeg_cli/src/ffmpeg/video_size.dart';

/// Resize the input video
///
/// Forces the output display ratio to be the same as the input
class ScaleFilter implements Filter {
  ScaleFilter({
    this.width,
    this.height,
    this.eval,
    this.interl,
    this.swsFlags,
    this.param0,
    this.param1,
    this.size,
  })  : assert(width == null || width >= -1),
        assert(height == null || height >= -1),
        assert(eval == null || eval == 'init' || eval == 'frame'),
        assert(interl == null || interl == 1 || interl == 0 || interl == -1);

  /// Width for scale
  final int? width;

  /// Height for scale
  final int? height;

  /// When to evaluate width and height expression (default is init)
  final String? eval;

  /// Set the interlacing mode (default is 0)
  final int? interl;

  /// Scalar flags used to set the scaling algorithm
  final SwsFlag? swsFlags;

  /// Set libswscale parameter
  final String? param0;

  /// Set libswscale parameter
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
      if (width != null && size == null) 'width=$width',
      if (height != null && size == null) 'height=$height',
      if (eval != null) 'eval=$eval',
      if (interl != null) 'interl=$interl',
      if (swsFlags != null) 'sws_flags=${swsFlags!.cliValue}',
      if (param0 != null) 'param0=$param0',
      if (param1 != null) 'param1=$param1',
      if (size != null) 'size=${size!.toCli()}',
    ];

    return 'scale=${properties.join(':')}';
  }
}
