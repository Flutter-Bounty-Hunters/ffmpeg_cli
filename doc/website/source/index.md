---
layout: layouts/homepage.jinja
contentRenderers: 
  - markdown
  - jinja
---
## What is FFMPEG?
[FFMPEG](https://ffmpeg.org/) is a collection of powerful and complicated video and audio processing tools. These tools are 
written in C++. Due to the complexity of building and coding for these tools, FFMPEG is primarily 
utilized through command-line (CLI) scripts.

### FFMPEG scripts are cryptic!
FFMPEG CLI scripts are notoriously difficult to read and write. It’s very easy to accidentally break a script.

```bash
ffmpeg \
   -f lavfi -i testsrc \
   -f lavfi -i testsrc \
   -f lavfi -i testsrc \
   -f lavfi -i testsrc \
   -filter_complex \
"[0:v]  pad=iw*2:ih*2 [a]; \
 [1:v]  negate        [b]; \
 [2:v]  hflip         [c]; \
 [3:v]  edgedetect    [d]; \
 [a] [b] overlay=w   [x]; \
 [x] [c] overlay=0:h [y]; \
 [y] [d] overlay=w:h [out]" \
  -map "[out]" \
  -c:v ffv1   -t 5   multiple_input_grid.avi
```

FFMPEG filter graphs are inherently complex - there’s no getting around that. However, that 
complexity doesn’t need to be compounded by trying to work with shell scripts. The `ffmpeg_cli` 
package makes it possible to compose these commands in Dart.

--- 

## FFMPEG commands in Dart
FFMPEG supports two styles of commands. FFMPEG calls them “simple” and “complex”. The difference is 
that a “simple” command has a single pipeline of steps from input to out. A “complex” command 
contains an entire graph of steps. The ffmpeg_cli packages supports both.

### Compose a simple command

```dart
final command = FfmpegCommand.simple(
  inputs: [
    // The input video is "raw-video.mov".
    FfmpegInput.asset(“raw-video.mov”),
  ],
  args: [
    // Cut the first 2 minutes and 30 seconds off the video.
    CliArg("ss", "2:30")
  ],
  // Transcode and output to a file called "my-video.mp4".
  outputFilepath: “my-video.mp4”,
);
```

### Compose a complex command

```dart
final command = FfmpegCommand.complex(
  // Take three inputs: an intro, some primary content, and an outro.
  inputs: [
    FfmpegInput.asset("assets/intro.mp4"),
    FfmpegInput.asset("assets/content.mp4"),
    FfmpegInput.asset("assets/outro.mov"),
  ],
  args: [
    // Send typical mapping args to send the result of the filter graph to
    // the output file.
    CliArg(name: 'map', value: outputStream.videoId!),
    CliArg(name: 'map', value: outputStream.audioId!),
    // A couple additional settings that seem to be necessary in some cases
    // to get the expected output. Play with these as needed.
    const CliArg(name: 'y'),
    const CliArg(name: 'vsync', value: '2'),
  ],
  // Configure the whole FFMPEG filter graph.
  filterGraph: FilterGraph(
    chains: [
      // Add a filter to the graph.
      FilterChain(
        // Send all three of our input videos into this filter.
        inputs: [
          const FfmpegStream(videoId: "[0:v]", audioId: "[0:a]"),
          const FfmpegStream(videoId: "[1:v]", audioId: "[1:a]"),
          const FfmpegStream(videoId: "[2:v]", audioId: "[2:a]"),
        ],
        // Apply a concatenation filter, which plays each input back-to-back.
        filters: [
          ConcatFilter(segmentCount: 3, outputVideoStreamCount: 1, outputAudioStreamCount: 1),
        ],
        // Send the result to the final output file.
        outputs: [
          outputStream,
        ],
      ),
    ],
  ),
  outputFilepath: "/my/output/file.mp4",
);
```

---

## Run the command
Once you've assembled an `FfmpegCommand`, you can execute it from Dart. Behind the scenes, the
`ffmpeg_cli` package takes your Dart object, converts it to a standard FFMPEG CLI command, and then
runs that command in an invisible shell.

```dart
// Create the command.
final command = createMyCommand();

// Execute command.
final process = await Ffmpeg().run(command: command);
```

---

## Built by the<br>Flutter Bounty Hunters
This package was built by the [Flutter Bounty Hunters (FBH)](https://flutterbountyhunters.com). 
The Flutter Bounty Hunters is a development agency that works exclusively on open source Flutter 
and Dark packages.

With funding from corporate clients, the goal of the Flutter Bounty Hunters is to solve 
common problems for The Last Time™. If your team gets value from Flutter Bounty Hunter 
packages, please consider funding further development. 

### Other FBH packages
Other packages that the Flutter Bounty Hunters brought to the community...

[Super Editor, Super Text, Attributed Text](https://github.com/superlistapp/super_editor), [Static Shock](https://staticshock.io), 
[Follow the Leader](https://github.com/flutter-bounty-hunters/follow_the_leader), [Overlord](https://github.com/flutter-bounty-hunters/overlord),
[Flutter Test Robots](https://github.com/flutter-bounty-hunters/dart_rss), and more.

## Contributors
The `{{ package.name }}` package was built by...

{{ components.contributors() }}