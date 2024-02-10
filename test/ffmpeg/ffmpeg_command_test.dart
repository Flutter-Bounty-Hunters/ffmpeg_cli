import 'package:ffmpeg_cli/ffmpeg_cli.dart';
import 'package:test/test.dart';

void main() {
  group("FFMPEG", () {
    group("command", () {
      test("serializes to CLI arguments", () {
        const outputStream = FfmpegStream(videoId: "[final_v]", audioId: "[final_a]");

        final command = FfmpegCommand.complex(
          inputs: [
            FfmpegInput.asset("assets/intro.mp4"),
            FfmpegInput.asset("assets/content.mp4"),
            FfmpegInput.asset("assets/outro.mov"),
          ],
          args: [
            CliArg(name: 'map', value: outputStream.videoId!),
            CliArg(name: 'map', value: outputStream.audioId!),
            const CliArg(name: 'y'),
            const CliArg(name: 'vsync', value: '2'),
          ],
          filterGraph: FilterGraph(
            chains: [
              FilterChain(
                inputs: [
                  const FfmpegStream(videoId: "[0:v]", audioId: "[0:a]"),
                  const FfmpegStream(videoId: "[1:v]", audioId: "[1:a]"),
                  const FfmpegStream(videoId: "[2:v]", audioId: "[2:a]"),
                ],
                filters: [
                  ConcatFilter(segmentCount: 3, outputVideoStreamCount: 1, outputAudioStreamCount: 1),
                ],
                outputs: [
                  outputStream,
                ],
              ),
            ],
          ),
          outputFilepath: "/my/output/file.mp4",
        );

        expect(
          command.toCli(),
          const CliCommand(
            executable: 'ffmpeg',
            args: [
              "-i", "assets/intro.mp4", //
              "-i", "assets/content.mp4", //
              "-i", "assets/outro.mov", //
              "-map", "[final_v]", //
              "-map", "[final_a]", //
              "-y",
              "-vsync", "2", //
              "-filter_complex",
              "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] concat=n=3:v=1:a=1 [final_v] [final_a]",
              "/my/output/file.mp4",
            ],
          ),
        );
      });

      test("allows custom ffmpeg path for simple commands", () {
        const command = FfmpegCommand.simple(
          ffmpegPath: '/opt/homebrew/bin/ffmpeg',
          outputFilepath: '/my/output/file.mp4',
        );

        expect(
          command.toCli(),
          const CliCommand(
            executable: '/opt/homebrew/bin/ffmpeg',
            args: ['/my/output/file.mp4'],
          ),
        );
      });

      test("allows custom ffmpeg path for complex commands", () {
        final commandBuilder = FfmpegBuilder();

        final inputStream = commandBuilder.addAsset("assets/bee.mp4");
        final outputStream = commandBuilder.createStream(hasVideo: true, hasAudio: true);

        commandBuilder.addFilterChain(
          FilterChain(
            inputs: [inputStream],
            filters: [],
            outputs: [outputStream],
          ),
        );

        final command = commandBuilder.build(
          ffmpegPath: '/opt/homebrew/bin/ffmpeg',
          args: [
            CliArg(name: 'map', value: outputStream.videoId!),
            CliArg(name: 'map', value: outputStream.audioId!),
            const CliArg(name: 'vsync', value: '2'),
          ],
          outputFilepath: '/output/test_render.mp4',
        );

        expect(
          command.toCli(),
          const CliCommand(
            executable: '/opt/homebrew/bin/ffmpeg',
            args: [
              '-i', 'assets/bee.mp4', //
              '-map', '[comp_0_v]', //
              '-map', '[comp_0_a]', //
              '-vsync', '2', //
              '-filter_complex', '[0:v] [0:a]  [comp_0_v] [comp_0_a]', //
              '/output/test_render.mp4',
            ],
          ),
        );
      });

      test("converts a group of images to a video", () {
        final command = FfmpegCommand.simple(
          inputs: [
            // file%d.png represents images named like file0.png, file1.png, file2.png, etc.
            FfmpegInput.asset("assets/images/file%d.png"),

            FfmpegInput.asset("assets/audio/audio.mp3"),
          ],
          args: [
            const CliArg(name: 'y'),
            const CliArg(name: 'c:a', value: 'aac'),
            const CliArg(name: 'qscale:v', value: '1'),
          ],
          outputFilepath: 'assets/output/file.mp4',
        );

        expect(
          command.toCli(),
          const CliCommand(
            executable: 'ffmpeg',
            args: [
              "-i",
              "assets/images/file%d.png",
              "-i",
              "assets/audio/audio.mp3",
              "-y",
              "-c:a",
              "aac",
              "-qscale:v",
              "1",
              "assets/output/file.mp4"
            ],
          ),
        );
      });
    });
  });
}
