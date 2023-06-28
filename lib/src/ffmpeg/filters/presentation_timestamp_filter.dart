import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Sets the Presentation TimeStamp (PTS) for the given video stream.
///
/// When trimming a video to a subsection, it's important to also set the
/// PTS of the trimmed video to `"PTS-STARTPTS"` to avoid an empty gap
/// before the start of the trimmed video.
class SetPtsFilter implements Filter {
  const SetPtsFilter.startPts() : this(pts: 'PTS-STARTPTS');

  const SetPtsFilter({required this.pts});

  /// The presentation timestamp in input
  final String pts;

  @override
  String toCli() => "setpts=$pts";
}

/// Sets the Presentation TimeStamp (PTS) for the given audio stream.
class ASetPtsFilter implements Filter {
  const ASetPtsFilter.startPts() : this(pts: 'PTS-STARTPTS');

  const ASetPtsFilter({required this.pts});

  /// The presentation timestamp in input
  final String pts;

  @override
  String toCli() => "asetpts=$pts";
}
