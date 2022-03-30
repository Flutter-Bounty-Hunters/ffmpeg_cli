class FfmpegColor {
  static FfmpegColor parse(String color) => FfmpegColor(int.parse(color));

  const FfmpegColor(this.color);

  final int color;

  bool get isTranslucent => color < 0xFF000000;

  String _computeRGBHex() => (color & 0x00FFFFFF).toRadixString(16).padLeft(6, '0');

  String _computeAlphaHex() => (color >> 24).toRadixString(16).padLeft(2, '0');

  // FFMPEG displays colors as 0xRRGGBB[AA] (as well as some other formats)
  String toCli() => '0x${_computeRGBHex()}${_computeAlphaHex()}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FfmpegColor && runtimeType == other.runtimeType && color == other.color;

  @override
  int get hashCode => color.hashCode;
}
