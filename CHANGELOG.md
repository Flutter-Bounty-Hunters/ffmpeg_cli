## [0.2.0] - Oct, 2023
New runner, new filters, filter updates

 * Split single command into `FfmpegCommand.simple` and `FfmpegCommand.complex`, per FFMPEG documentation
   * A simple command has a single pipe of filters
   * A complex command has an entire graph of filters
 * New filters
   * `SubtitleFilter`
 * Adjusted filters
   * Renamed `RawFilter` to `CustomFilter`
   * A number of filters had properties added or adjusted

## [0.1.0] - April, 2022: Initial release

 * `Ffmpeg` and `FfmpegCommand` - executes FFMPEG CLI commands from Dart
 * `FfmpegBuilder` - (optional) builder that constructs `FfmpegCommand`s, making it easier to correlate stream IDs
 * `Ffprobe` - partial support for the `ffprobe` CLI.