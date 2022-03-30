class SwsFlag {
  static const fastBilinear = SwsFlag._('fast_bilinear');
  static const bilinear = SwsFlag._('bilinear');
  static const bicubic = SwsFlag._('bicubic');
  static const experimental = SwsFlag._('experimental');
  static const neighbor = SwsFlag._('neighbor');
  static const area = SwsFlag._('area');
  static const bicublin = SwsFlag._('bicublin');
  static const gauss = SwsFlag._('gauss');
  static const sinc = SwsFlag._('sinc');
  static const lanczos = SwsFlag._('lanczos');
  static const spline = SwsFlag._('spline');
  static const printInfo = SwsFlag._('print_info');
  static const accurateRnd = SwsFlag._('accurate_rnd');
  static const fullChromaInt = SwsFlag._('full_chroma_int');
  static const fullChromaInp = SwsFlag._('full_chroma_inp');
  static const bitexact = SwsFlag._('bitexact');

  const SwsFlag._(this.cliValue);

  final String cliValue;

  String toCli() => cliValue;
}
