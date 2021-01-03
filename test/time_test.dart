import 'package:superdeclarative_ffmpeg/flutter_ffmpeg.dart';
import 'package:test/test.dart';

void main() {
  group('ffmpeg duration', () {
    group('input parsing', () {
      test('parse "55"', () {
        expect(
          FfmpegTimeDuration.parse('55'),
          FfmpegTimeDuration(const Duration(seconds: 55)),
        );
      });

      test('parse "0.2"', () {
        expect(
          FfmpegTimeDuration.parse('0.2'),
          FfmpegTimeDuration(const Duration(milliseconds: 200)),
        );
      });

      test('parse "12:03:45"', () {
        expect(
          FfmpegTimeDuration.parse('12:03:45'),
          FfmpegTimeDuration(
              const Duration(hours: 12, minutes: 3, seconds: 45)),
        );
      });

      test('parse "23.189"', () {
        expect(
          FfmpegTimeDuration.parse('23.189'),
          FfmpegTimeDuration(const Duration(seconds: 23, milliseconds: 189)),
        );
      });

      test('parse "-23.189"', () {
        expect(
          FfmpegTimeDuration.parse('-23.189'),
          FfmpegTimeDuration(const Duration(seconds: -23, milliseconds: -189)),
        );
      });

      test('parse "200ms"', () {
        expect(
          FfmpegTimeDuration.parse('200ms'),
          FfmpegTimeDuration(const Duration(milliseconds: 200)),
        );
      });

      test('parse "200000us"', () {
        expect(
          FfmpegTimeDuration.parse('200000us'),
          FfmpegTimeDuration(const Duration(microseconds: 200000)),
        );
      });

      test('parse "45+.123s"', () {
        expect(
          FfmpegTimeDuration.parse('45+.123s'),
          FfmpegTimeDuration(const Duration(seconds: 45, milliseconds: 123)),
        );
      });

      test('parse "-45+.123s"', () {
        expect(
          FfmpegTimeDuration.parse('-45+.123s'),
          FfmpegTimeDuration(const Duration(seconds: -45, milliseconds: -123)),
        );
      });
    });

    group('output format', () {
      test('standard format spot checks', () {
        final duration = FfmpegTimeDuration(const Duration(
          hours: 3,
          minutes: 4,
          seconds: 5,
          milliseconds: 6,
          microseconds: 7,
        ));

        expect(duration.toStandardFormat(), '03:04:05.006007');
      });

      test('standard format: "55"', () {
        final duration = FfmpegTimeDuration(const Duration(
          seconds: 55,
        ));
        expect(duration.toStandardFormat(), '55');
      });

      test('standard format: "12:03:45"', () {
        final duration = FfmpegTimeDuration(const Duration(
          hours: 12,
          minutes: 3,
          seconds: 45,
        ));
        expect(duration.toStandardFormat(), '12:03:45');
      });

      test('standard format: "12:03:45"', () {
        final duration = FfmpegTimeDuration(const Duration(
          seconds: 23,
          milliseconds: 189,
        ));
        expect(duration.toStandardFormat(), '23.189');
      });

      test('standard format: "0.2"', () {
        final duration = FfmpegTimeDuration(const Duration(
          milliseconds: 200,
        ));
        expect(duration.toStandardFormat(), '0.2');
      });

      test('unit-specific: 23.189', () {
        final duration = FfmpegTimeDuration(const Duration(
          seconds: 23,
          milliseconds: 189,
        ));
        expect(duration.toStandardFormat(), '23.189');
      });

      test('unit-specific: -23.189', () {
        final duration = FfmpegTimeDuration(const Duration(
          seconds: -23,
          milliseconds: -189,
        ));
        expect(duration.toStandardFormat(), '-23.189');
      });

      test('unit-specific spot checks', () {
        final duration = FfmpegTimeDuration(const Duration(
          seconds: 5,
          milliseconds: 6,
          microseconds: 7,
        ));

        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.seconds),
            '5+.006007s');
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.milliseconds),
            '5006+.007ms');
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.microseconds),
            '5006007us');
      });

      test('unit-specific: 200ms', () {
        final duration = FfmpegTimeDuration(const Duration(
          milliseconds: 200,
        ));
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.milliseconds),
            '200ms');
      });

      test('unit-specific: 200000us', () {
        final duration = FfmpegTimeDuration(const Duration(
          milliseconds: 200,
        ));
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.microseconds),
            '200000us');
      });
    });
  });

  group('ffmpeg time base', () {
    // TODO:
  });

  group('ffmpeg timestamp', () {
    // TODO:
  });
}
