<p align="center">
  <img src="https://github.com/Flutter-Bounty-Hunters/ffmpeg_cli/assets/7259036/6dfdca02-9add-45c3-b253-efd15ebd9066" alt="FFMPEG CLI - Run FFMPEG CLI commands from Dart">
</p>

<p align="center">
  <a href="https://flutterbountyhunters.com" target="_blank">
    <img src="https://github.com/Flutter-Bounty-Hunters/flutter_test_robots/assets/7259036/1b19720d-3dad-4ade-ac76-74313b67a898" alt="Built by the Flutter Bounty Hunters">
  </a>
</p>

---
## What is FFMPEG?
[FFMPEG](https://ffmpeg.org/ffmpeg.html) is a very popular, longstanding tool for reading, writing, and streaming audio and video content. Most developers use FFMPEG through its command-line interface (CLI), because that's much easier than interfacing with the C code upon which FFMPEG is built.

## What is `ffmpeg_cli`
This package allows you to configure FFMPEG CLI commands with Dart code.

`ffmpeg_cli` purposefully retains the complexity of FFMPEG commands so that anything the FFMPEG CLI can do, the `ffmpeg_cli` package can do.

## Quickstart
First, make sure that `ffmpeg` is installed on your device, and is available on your system path.

Compose an FFMPEG command with Dart:

```dart
// Define an output stream, which will map the filter
// graph to the video file. The ID names can be whatever
// you'd like.
const outputStream = FfmpegStream(
  videoId: "[final_v]", 
  audioId: "[final_a]",
);

// Compose your desired FFMPEG command, with inputs, filters, arguments,
// and an output location.
final command = FfmpegCommand(
  inputs: [
    FfmpegInput.asset("assets/intro.mp4"),
    FfmpegInput.asset("assets/content.mp4"),
    FfmpegInput.asset("assets/outro.mov"),
  ],
  args: [
    // Map the filter graph to the video file output.
    CliArg(name: 'map', value: outputStream.videoId!),
    CliArg(name: 'map', value: outputStream.audioId!),
    const CliArg(name: 'vsync', value: '2'),
  ],
  filterGraph: FilterGraph(
    chains: [
      FilterChain(
        inputs: [
          // Send all 3 video assets into the concat filter.
          const FfmpegStream(videoId: "[0:v]", audioId: "[0:a]"),
          const FfmpegStream(videoId: "[1:v]", audioId: "[1:a]"),
          const FfmpegStream(videoId: "[2:v]", audioId: "[2:a]"),
        ],
        filters: [
          // Concatenate 3 segments.
          ConcatFilter(
            segmentCount: 3, 
            outputVideoStreamCount: 1, 
            outputAudioStreamCount: 1,
          ),
        ],
        outputs: [
          // Give the output stream the given audio/video IDs
          outputStream,
        ],
      ),
    ],
  ),
  outputFilepath: "/my/output/file.mp4",
);

// Execute command
final process = await Ffmpeg().run(command: command);
```

## How ffprobe support is managed
There are a lot of properties in `ffprobe`. Many of these properties can present in
varying formats, which are not effectively documented.

The approach to `ffprobe` is to add missing result parameters as they are discovered
and to add parsing functionality per property as the various possible formats are
discovered. In other words, only do what is necessary in the given moment because
the overall scope is too large and difficult to discover.
