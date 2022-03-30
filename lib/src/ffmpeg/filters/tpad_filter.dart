import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';
import 'package:ffmpeg_cli/src/time.dart';

/// Adds padding frames to a given video stream.
///
/// `start`   number of frames to add before video content.
///
/// `stop`    number of frames to add after video content.
///
/// `start_mode`  kind of frames added to beginning of stream
///
/// `stop_mode`   kind of frames added to end of stream
///
/// `start_duration`  time delay added before playing the stream
///
/// `stop_duration`   time delay added after end of the stream
///
/// `color`   color of padded frames.
class TPadFilter implements Filter {
  const TPadFilter({
    this.start,
    this.stop,
    this.startDuration,
    this.stopDuration,
    this.startMode,
    this.stopMode,
    this.color,
  })  : assert(startMode == null || startMode == 'add' || startMode == 'clone'),
        assert(stopMode == null || stopMode == 'add' || stopMode == 'clone');

  final int? start;
  final int? stop;
  final Duration? startDuration;
  final Duration? stopDuration;
  final String? startMode;
  final String? stopMode;
  final String? color;

  @override
  String toCli() {
    final argList = <String>[];
    if (start != null) {
      argList.add('start=$start');
    }
    if (stop != null) {
      argList.add('stop=$stop');
    }
    if (startDuration != null) {
      argList.add('start_duration=${startDuration!.toSeconds()}');
    }
    if (stopDuration != null) {
      argList.add('stop_duration=${stopDuration!.toSeconds()}');
    }
    if (startMode != null) {
      argList.add('start_mode=$startMode');
    }
    if (stopMode != null) {
      argList.add('stop_mode=$stopMode');
    }
    if (color != null) {
      argList.add('color=$color');
    }

    return 'tpad=${argList.join(':')}';
  }
}
