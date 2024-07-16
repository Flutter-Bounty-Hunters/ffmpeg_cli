import 'package:ffmpeg_cli/src/ffmpeg/video_size_abbreviation.dart';

class VideoSize {
  const VideoSize({this.width, this.height, this.abbreviation})
      : assert(width != null && height != null || abbreviation != null);

  final num? width;
  final num? height;
  final VideoSizeAbbreviation? abbreviation;

  String toCli() => abbreviation?.cliValue ?? '${width}x$height';

  @override
  String toString() => '[Size]: ${width}x$height';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSize && runtimeType == other.runtimeType && width == other.width && height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}
