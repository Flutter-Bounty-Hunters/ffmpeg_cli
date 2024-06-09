import 'package:ffmpeg_cli/ffmpeg_cli.dart';
import 'package:test/test.dart';

void main() {
  group("FFMPEG", () {
    group("use cases", () {
      test("create a video from a group of screenshots", () {
        final command = FfmpegCommand.simple(
          inputs: [
            // screenshot%d.png represents images named in format screenshot0.png,
            // screenshot1.png, etc.
            FfmpegInput.asset("assets/images/screenshot%d.png"),
          ],
          args: [
            // Used to overwrite an existing output file without asking for
            // confirmation.
            const CliArg(name: 'y'),

            // Sets the video quality scale used while video encoding.
            const CliArg(name: 'qscale:v', value: '1'),

            // Sets the pixel format for the video frames.
            //
            // Note: Not always necessary but may need to provide for generated video to
            // be compatible with QuickTime and most other players.
            // More info here, https://trac.ffmpeg.org/wiki/Encode/H.264#Encodingfordumbplayers
            const CliArg(name: 'pix_fmt', value: 'yuv420p'),
          ],
          outputFilepath: 'assets/output/movie.mp4',
        );

        expect(
          command.toCli(),
          const CliCommand(
            executable: 'ffmpeg',
            args: [
              "-i",
              "assets/images/screenshot%d.png",
              "-y",
              "-qscale:v",
              "1",
              "-pix_fmt",
              "yuv420p",
              "assets/output/movie.mp4",
            ],
          ),
        );
      });

      test("create a video from a group of screenshots and an audio file", () {
        final command = FfmpegCommand.simple(
          inputs: [
            // screenshot%d.png represents images named in format screenshot0.png,
            // screenshot1.png, etc.
            FfmpegInput.asset("assets/images/screenshot%d.png"),

            FfmpegInput.asset("assets/audio/audio.mp3"),
          ],
          args: [
            // Used to overwrite an existing output file without asking for
            // confirmation.
            const CliArg(name: 'y'),

            // Sets the video quality scale used while video encoding.
            const CliArg(name: 'qscale:v', value: '1'),

            // Sets the pixel format for the video frames.
            //
            // Note: Not always necessary but may need to provide for generated video to
            // be compatible with QuickTime and most other players.
            // More info here, https://trac.ffmpeg.org/wiki/Encode/H.264#Encodingfordumbplayers
            const CliArg(name: 'pix_fmt', value: 'yuv420p'),
          ],
          outputFilepath: 'assets/output/movie.mp4',
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
              "-qscale:v",
              "1",
              "-pix_fmt",
              "yuv420p",
              "assets/output/movie.mp4"
            ],
          ),
        );
      });
    });
  });
}
