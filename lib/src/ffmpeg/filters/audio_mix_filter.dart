import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Mixes multiple audio streams together into one.
///
/// I think this will automatically cut the volume of each input proportional
/// to the number of inputs, e.g., 1/2 volume for 2 inputs, 1/3 volume for 3
/// inputs.
class AMixFilter implements Filter {
  const AMixFilter({
    required this.inputCount,
  });

  final int inputCount;

  @override
  String toCli() {
    return 'amix=inputs=$inputCount';
  }
}
