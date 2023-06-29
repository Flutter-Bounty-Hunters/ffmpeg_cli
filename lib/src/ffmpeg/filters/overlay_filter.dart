import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Overlays one video on top of another.
///
/// First video stream is the "main" and the second video stream is the "overlay".
class OverlayFilter implements Filter {
  OverlayFilter({
    this.x,
    this.y,
    this.eofAction,
    this.shortest,
    this.overlayW,
    this.overlayH,
    this.inputFrameCount,
    this.timestamp,
  })  : assert(shortest == null || shortest == 1 || shortest == 0),
        assert(eofAction == null || const ['repeat', 'endall', 'pass'].contains(eofAction));

  /// x-position of the image taken from the top left corner
  final int? x;

  /// y-position of the image taken from the top left corner
  final int? y;

  /// The action to take when EOF is encountered on the secondary input
  final String? eofAction;

  /// Force the output to terminate when the shortest input terminates
  final int? shortest;

  /// Overlay width
  final int? overlayW;

  /// Overlay height
  final int? overlayH;

  /// The number of input frames
  final int? inputFrameCount;

  /// The timestamp of when the overlay is displayed
  final Duration? timestamp;

  @override
  String toCli() {
    final properties = <String>[
      if (x != null) "$x",
      if (y != null) "$y",
      if (eofAction != null) "eof_action=$eofAction",
      if (shortest != null) "shortest=$shortest",
      if (overlayW != null) "overlay_w=$overlayW",
      if (overlayH != null) "overlay_h=$overlayH",
      if (inputFrameCount != null) "n=$inputFrameCount",
      if (timestamp != null) "t=${timestamp!.inSeconds}"
    ];
    return 'overlay=${properties.join(":")}';
  }
}
