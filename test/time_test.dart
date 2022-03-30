import 'package:ffmpeg_cli/ffmpeg_cli.dart';
import 'package:test/test.dart';

void main() {
  group('ffmpeg duration', () {
    group('input parsing', () {
      test('parse "55"', () {
        expect(
          parseFfmpegTimeDuration('55'),
          const Duration(seconds: 55),
        );
      });

      test('parse "0.2"', () {
        expect(
          parseFfmpegTimeDuration('0.2'),
          const Duration(milliseconds: 200),
        );
      });

      test('parse "12:03:45"', () {
        expect(
          parseFfmpegTimeDuration('12:03:45'),
          const Duration(hours: 12, minutes: 3, seconds: 45),
        );
      });

      test('parse "23.189"', () {
        expect(
          parseFfmpegTimeDuration('23.189'),
          const Duration(seconds: 23, milliseconds: 189),
        );
      });

      test('parse "-23.189"', () {
        expect(
          parseFfmpegTimeDuration('-23.189'),
          const Duration(seconds: -23, milliseconds: -189),
        );
      });

      test('parse "200ms"', () {
        expect(
          parseFfmpegTimeDuration('200ms'),
          const Duration(milliseconds: 200),
        );
      });

      test('parse "200000us"', () {
        expect(
          parseFfmpegTimeDuration('200000us'),
          const Duration(microseconds: 200000),
        );
      });

      test('parse "45+.123s"', () {
        expect(
          parseFfmpegTimeDuration('45+.123s'),
          const Duration(seconds: 45, milliseconds: 123),
        );
      });

      test('parse "-45+.123s"', () {
        expect(
          parseFfmpegTimeDuration('-45+.123s'),
          const Duration(seconds: -45, milliseconds: -123),
        );
      });
    });

    group('output format', () {
      test('standard format spot checks', () {
        const duration = Duration(
          hours: 3,
          minutes: 4,
          seconds: 5,
          milliseconds: 6,
          microseconds: 7,
        );

        expect(duration.toStandardFormat(), '03:04:05.006007');
      });

      test('standard format: "55"', () {
        const duration = Duration(
          seconds: 55,
        );
        expect(duration.toStandardFormat(), '55');
      });

      test('standard format: "12:03:45"', () {
        const duration = Duration(
          hours: 12,
          minutes: 3,
          seconds: 45,
        );
        expect(duration.toStandardFormat(), '12:03:45');
      });

      test('standard format: "12:03:45"', () {
        const duration = Duration(
          seconds: 23,
          milliseconds: 189,
        );
        expect(duration.toStandardFormat(), '23.189');
      });

      test('standard format: "0.2"', () {
        const duration = Duration(
          milliseconds: 200,
        );
        expect(duration.toStandardFormat(), '0.2');
      });

      test('unit-specific: 23.189', () {
        const duration = Duration(
          seconds: 23,
          milliseconds: 189,
        );
        expect(duration.toStandardFormat(), '23.189');
      });

      test('unit-specific: -23.189', () {
        const duration = Duration(
          seconds: -23,
          milliseconds: -189,
        );
        expect(duration.toStandardFormat(), '-23.189');
      });

      test('unit-specific spot checks', () {
        const duration = Duration(
          seconds: 5,
          milliseconds: 6,
          microseconds: 7,
        );

        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.seconds), '5+.006007s');
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.milliseconds), '5006+.007ms');
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.microseconds), '5006007us');
      });

      test('unit-specific: 200ms', () {
        const duration = Duration(
          milliseconds: 200,
        );
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.milliseconds), '200ms');
      });

      test('unit-specific: 200000us', () {
        const duration = Duration(
          milliseconds: 200,
        );
        expect(duration.toUnitSpecifiedFormat(FfmpegTimeUnit.microseconds), '200000us');
      });

      test('seconds: 23.456', () {
        expect(
            const Duration(
              seconds: 23,
              milliseconds: 456,
            ).toSeconds(),
            '23.456');
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
