class VideoSize {
  const VideoSize({
    required this.width,
    required this.height,
  });

  final num width;
  final num height;

  @override
  String toString() => '[Size]: ${width}x$height';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSize &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}
