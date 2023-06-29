import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Mixes multiple audio streams together into one.
///
/// This will automatically cut the volume of each input proportional
/// to the number of inputs, e.g., 1/2 volume for 2 inputs, 1/3 volume for 3
/// inputs.
class AMixFilter implements Filter {
  const AMixFilter({
    this.inputCount,
  });

  /// Number of inputs (defaults to 2)
  final int? inputCount;

  @override
  String toCli() {
    return 'amix${(inputCount != null) ? "=inputs=$inputCount" : ""}';
  }
}
