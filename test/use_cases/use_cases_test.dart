import 'package:ffmpeg_cli/ffmpeg_cli.dart';
import 'package:test/test.dart';

void main() {
  group("FFMPEG", () {
    group("use cases", () {
      test("converts a group of screenshots to a video", () {
        final command = FfmpegCommand.simple(
          inputs: [
            // screenshot%d.png represents images named in format screenshot0.png, screenshot1.png, screenshot2.png, etc.
            FfmpegInput.asset("assets/images/screenshot%d.png"),

            FfmpegInput.asset("assets/audio/audio.mp3"),
          ],
          args: [
            const CliArg(name: 'y'),
            const CliArg(name: 'c:a', value: 'aac'),
            const CliArg(name: 'qscale:v', value: '1'),
          ],
          outputFilepath: 'assets/output/generated_video.mp4',
        );

        expect(
          command.toCli(),
          const CliCommand(
            executable: 'ffmpeg',
            args: [
              "-i",
              "assets/images/screenshot%d.png",
              "-i",
              "assets/audio/audio.mp3",
              "-y",
              "-c:a",
              "aac",
              "-qscale:v",
              "1",
              "assets/output/generated_video.mp4"
            ],
          ),
        );
      });
    });
  });
}
