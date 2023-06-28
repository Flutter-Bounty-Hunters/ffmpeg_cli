import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Draw subtitles on top of input video
///
/// Requires libass library to be compiled with FFmpeg
class SubtitleFilter implements Filter {
  SubtitleFilter({
    required this.filename,
    this.forceStyle,
  });

  /// Path to where the subtitle file is located
  final String filename;

  /// Override the default style, using ASS style format
  ///
  /// KEY=VALUE seperated by a comma
  final String? forceStyle;

  @override
  String toCli() {
    return (forceStyle != null) ? 'subtitles=$filename:force_style=$forceStyle' : 'subtitles=$filename';
  }
}
