import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Sets the Sample Aspect Ratio for the filter output video.
class SetSarFilter implements Filter {
  SetSarFilter({
    required this.sar,
  }) : assert(sar.isNotEmpty);

  final String sar;

  @override
  String toCli() {
    return 'setsar=$sar';
  }
}
