// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ffmpeg_cli/ffmpeg_cli.dart';

/// Manually configures an [FfmpegCommand], without using the help
/// of an [FfmpegBuilder].
void main() async {
  // Create the FFMPEG command so we can run it.
  final cliCommand = FfmpegCommand(
    inputs: [
      // These assets are passed to FFMPEG with the input "-i" flag.
      // Each input is auto-assigned stream IDs by FFMPEG, e.g.:
      //  1: "[0:v]" and "[0:a]"
      //  2: "[1:v]" and "[1:a]"
      //  ...
      FfmpegInput.asset("assets/Butterfly-209.mp4"),
      FfmpegInput.asset("assets/bee.mp4"),
    ],
    args: [
      // Set the FFMPEG log level.
      CliArg.logLevel(LogLevel.info),
      // Map the final stream IDs from the filter graph to
      // the output file.
      const CliArg(name: 'map', value: "[comp_0_v]"),
      const CliArg(name: 'map', value: "[comp_0_a]"),
      const CliArg(name: 'y'),
      // TODO: need to generalize knowledge of when to use vsync -2
      const CliArg(name: 'vsync', value: '2'),
    ],
    filterGraph: FilterGraph(
      chains: [
        // We combine the two example videos into one, by using a
        // "concat" filter.
        FilterChain(
          inputs: [
            // The inputs into the "concat" filter are the input IDs
            // for the source videos that FFMPEG generated.
            const FfmpegStream(videoId: "[0:v]", audioId: "[0:a]"),
            const FfmpegStream(videoId: "[1:v]", audioId: "[1:a]"),
          ],
          filters: [
            // Combine the two source videos, one after the other, by
            // using the "concat" filter.
            CropFilter(width: 585, height: 100),
            ConcatFilter(
              segmentCount: 2,
              outputVideoStreamCount: 1,
              outputAudioStreamCount: 1,
            ),
          ],
          outputs: [
            // This "concat" filter will produce a video stream and an
            // audio stream. Here, we give those streams IDs so that we
            // can pass them into other FilterChains, or map them to the
            // output file.
            const FfmpegStream(videoId: "[comp_0_v]", audioId: "[comp_0_a]"),
          ],
        ),
      ],
    ),
    outputFilepath: "output/test_render.mp4",
  );

  print(CropFilter(width: 585, height: 1080).toCli());

  print('');
  print('Expected command input: ');
  print(cliCommand.expectedCliInput());
  print('');

  // Run the FFMPEG command.
  final process = await Ffmpeg().run(cliCommand);

  // Pipe the process output to the Dart console.
  process.stderr.transform(utf8.decoder).listen((data) {
    print(data);
  });

  // Allow the user to respond to FFMPEG queries, such as file overwrite
  // confirmations.
  stdin.pipe(process.stdin);

  await process.exitCode;
  print('DONE');
}
