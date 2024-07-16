class VideoSizeAbbreviation {
  static const ntsc = VideoSizeAbbreviation._('ntsc');
  static const pal = VideoSizeAbbreviation._('pal');
  static const qntsc = VideoSizeAbbreviation._('qntsc');
  static const qpal = VideoSizeAbbreviation._('qpal');
  static const sntsc = VideoSizeAbbreviation._('sntsc');
  static const spal = VideoSizeAbbreviation._('spal');
  static const film = VideoSizeAbbreviation._('film');
  static const ntscFilm = VideoSizeAbbreviation._('ntsc-film');
  static const sqcif = VideoSizeAbbreviation._('sqcif');
  static const qcif = VideoSizeAbbreviation._('qcif');
  static const cif = VideoSizeAbbreviation._('cif');
  static const cif4 = VideoSizeAbbreviation._('4cif');
  static const cif16 = VideoSizeAbbreviation._('16cif');
  static const qqvga = VideoSizeAbbreviation._('qqvga');
  static const qvga = VideoSizeAbbreviation._('qvga');
  static const vga = VideoSizeAbbreviation._('vga');
  static const svga = VideoSizeAbbreviation._('svga');
  static const xga = VideoSizeAbbreviation._('xga');
  static const uxga = VideoSizeAbbreviation._('uxga');
  static const qxga = VideoSizeAbbreviation._('qxga');
  static const sxga = VideoSizeAbbreviation._('sxga');
  static const qsxga = VideoSizeAbbreviation._('qsxga');
  static const hsxga = VideoSizeAbbreviation._('hsxga');
  static const wvga = VideoSizeAbbreviation._('wvga');
  static const wxga = VideoSizeAbbreviation._('wxga');
  static const wsxga = VideoSizeAbbreviation._('wsxga');
  static const wuxga = VideoSizeAbbreviation._('wuxga');
  static const woxga = VideoSizeAbbreviation._('woxga');
  static const wqsxga = VideoSizeAbbreviation._('wqsxga');
  static const wquxga = VideoSizeAbbreviation._('wquxga');
  static const whsxga = VideoSizeAbbreviation._('whsxga');
  static const whuxga = VideoSizeAbbreviation._('whuxga');
  static const cga = VideoSizeAbbreviation._('cga');
  static const ega = VideoSizeAbbreviation._('ega');
  static const hd480 = VideoSizeAbbreviation._('hd480');
  static const hd720 = VideoSizeAbbreviation._('hd720');
  static const hd1080 = VideoSizeAbbreviation._('hd1080');
  static const resolution2k = VideoSizeAbbreviation._('2k');
  static const flat2k = VideoSizeAbbreviation._('2kflat');
  static const scope2k = VideoSizeAbbreviation._('2kscope');
  static const resolution4k = VideoSizeAbbreviation._('4k');
  static const flat4k = VideoSizeAbbreviation._('4kflat');
  static const scope4k = VideoSizeAbbreviation._('4kscope');
  static const nhd = VideoSizeAbbreviation._('nhd');
  static const hqvga = VideoSizeAbbreviation._('hqvga');
  static const wqvga = VideoSizeAbbreviation._('wqvga');
  static const fwqvga = VideoSizeAbbreviation._('fwqvga');
  static const hvga = VideoSizeAbbreviation._('hvga');
  static const qhd = VideoSizeAbbreviation._('qhd');
  static const dci2k = VideoSizeAbbreviation._('2kdci');
  static const dci4k = VideoSizeAbbreviation._('4kdci');
  static const uhd2160 = VideoSizeAbbreviation._('uhd2160');
  static const uhd4320 = VideoSizeAbbreviation._('uhd4320');

  const VideoSizeAbbreviation._(this.cliValue);
  final String cliValue;

  String toCli() => cliValue;
}
