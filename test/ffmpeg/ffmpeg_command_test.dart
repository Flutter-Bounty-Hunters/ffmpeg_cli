import 'package:ffmpeg_cli/ffmpeg_cli.dart';
import 'package:test/test.dart';

void main() {
  group("FFMPEG", () {
    group("command", () {
      test("serializes to CLI arguments", () {
        const outputStream = FfmpegStream(videoId: "[final_v]", audioId: "[final_a]");

        final command = FfmpegCommand(
          inputs: [
            FfmpegInput.asset("assets/intro.mp4"),
            FfmpegInput.asset("assets/content.mp4"),
            FfmpegInput.asset("assets/outro.mov"),
          ],
          args: [
            CliArg(name: 'map', value: outputStream.videoId!),
            CliArg(name: 'map', value: outputStream.audioId!),
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
          [
            "-i", "assets/intro.mp4", //
            "-i", "assets/content.mp4", //
            "-i", "assets/outro.mov", //
            "-map", "[final_v]", //
            "-map", "[final_a]", //
            "-vsync", "2", //
            "-filter_complex",
            "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] concat=n=3:v=1:a=1 [final_v] [final_a]",
            "/my/output/file.mp4",
          ],
        );
      });
    });
  });
}
