import 'package:ffmpeg_cli/src/ffmpeg/ffmpeg_command.dart';

/// Uses the `cliValue` as a literal representation of an FFMPEG
/// CLI filter, in the case that such a filter is not currently
/// available as a `Filter` in this package.
class RawFilter implements Filter {
  RawFilter(this.cliValue);

  final String cliValue;

  @override
  String toCli() => cliValue;
}
