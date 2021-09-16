import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:superdeclarative_ffmpeg/flutter_ffmpeg.dart';

part 'ffprobe_json.g.dart';

FfmpegTimeDuration? _durationFromJson(String? durationString) =>
    durationString != null ? FfmpegTimeDuration.parse(durationString) : null;

String? _durationToJson(FfmpegTimeDuration? duration) => duration != null ? duration.toStandardFormat() : null;

@JsonSerializable()
class FfprobeResult {
  factory FfprobeResult.fromJson(Map<String, dynamic> json) => _$FfprobeResultFromJson(json);

  FfprobeResult({
    this.streams,
    this.format,
  });

  final List<Stream>? streams;
  final Format? format;

  Map<String, dynamic> toJson() => _$FfprobeResultToJson(this);

  @override
  String toString() {
    return 'FfprobeResult:\n' + JsonEncoder.withIndent('  ').convert(toJson());
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Stream {
  factory Stream.fromJson(Map<String, dynamic> json) => _$StreamFromJson(json);

  Stream({
    this.index,
    this.codeName,
    this.codecLongName,
    this.profile,
    this.codecType,
    this.codecTimeBase,
    this.codecTagString,
    this.codecTag,
    this.width,
    this.height,
    this.codecWidth,
    this.codecHeight,
    this.closedCaptions,
    this.hasBFrames,
    this.pixFmt,
    this.level,
    this.colorRange,
    this.colorSpace,
    this.colorTransfer,
    this.colorPrimaries,
    this.chromaLocation,
    this.refs,
    this.isAvc,
    this.nalLengthSize,
    this.rFrameRate,
    this.avgFrameRate,
    this.timeBase,
    this.startPts,
    this.startTime,
    this.durationTs,
    this.duration,
    this.bitRate,
    this.bitsPerRawSample,
    this.maxBitRate,
    this.nbFrames,
    this.disposition,
    this.tags,
    this.sampleFmt,
    this.sampleRate,
    this.channels,
    this.channelLayout,
    this.bitsPerSample,
  });

  final int? index;
  final String? codeName;
  final String? codecLongName;
  final String? profile;
  final String? codecType;
  final String? codecTimeBase;
  final String? codecTagString;
  final String? codecTag;
  final int? width;
  final int? height;
  final int? codecWidth;
  final int? codecHeight;
  final int? closedCaptions;
  final int? hasBFrames;
  final String? pixFmt;
  final int? level;
  final String? colorRange;
  final String? colorSpace;
  final String? colorTransfer;
  final String? colorPrimaries;
  final String? chromaLocation;
  final int? refs;
  final String? isAvc;
  final String? nalLengthSize;
  final String? rFrameRate;
  final String? avgFrameRate;
  final String? timeBase;
  final int? startPts;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final FfmpegTimeDuration? startTime;
  final int? durationTs;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final FfmpegTimeDuration? duration;
  final String? bitRate;
  final String? bitsPerRawSample;
  final String? maxBitRate;
  final String? nbFrames;
  final Disposition? disposition;
  final Tags? tags;

  final String? sampleFmt;
  final String? sampleRate;
  final int? channels;
  final String? channelLayout;
  final int? bitsPerSample;

  Map<String, dynamic> toJson() => _$StreamToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Disposition {
  factory Disposition.fromJson(Map<String, dynamic> json) => _$DispositionFromJson(json);

  Disposition({
    this.defaultCount,
    this.dub,
    this.original,
    this.comment,
    this.lyrics,
    this.karaoke,
    this.forced,
    this.hearingImpaired,
    this.visualImpaired,
    this.cleanEffects,
    this.attachedPic,
    this.timedThumbnails,
  });

  @JsonKey(name: 'default')
  final int? defaultCount;
  final int? dub;
  final int? original;
  final int? comment;
  final int? lyrics;
  final int? karaoke;
  final int? forced;
  final int? hearingImpaired;
  final int? visualImpaired;
  final int? cleanEffects;
  final int? attachedPic;
  final int? timedThumbnails;

  Map<String, dynamic> toJson() => _$DispositionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Format {
  factory Format.fromJson(Map<String, dynamic> json) => _$FormatFromJson(json);

  Format({
    this.filename,
    this.nbStreams,
    this.nbPrograms,
    this.formatName,
    this.formatLongName,
    this.startTime,
    this.duration,
    this.size,
    this.bitRate,
    this.probeScore,
    this.tags,
  });

  final String? filename;

  final int? nbStreams;
  final int? nbPrograms;

  final String? formatName;
  final String? formatLongName;

  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final FfmpegTimeDuration? startTime;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final FfmpegTimeDuration? duration;
  final String? size;
  final String? bitRate;
  final int? probeScore;

  final Tags? tags;

  Map<String, dynamic> toJson() => _$FormatToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Tags {
  factory Tags.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);

  Tags({
    this.majorBrand,
    this.minorVersion,
    this.compatibleBrands,
    this.creationTime,
    this.language,
    this.handlerName,
    this.encoder,
  });

  final String? majorBrand;
  final String? minorVersion;
  final String? compatibleBrands;
  final String? creationTime;
  final String? language;
  final String? handlerName;
  final String? encoder;

  Map<String, dynamic> toJson() => _$TagsToJson(this);
}

// "format": {
//         "filename": "./assets/test_video.mp4",
//         "nb_streams": 2,
//         "nb_programs": 0,
//         "format_name": "mov,mp4,m4a,3gp,3g2,mj2",
//         "format_long_name": "QuickTime / MOV",
//         "start_time": "0.000000",
//         "duration": "6.549333",
//         "size": "2982109",
//         "bit_rate": "3642641",
//         "probe_score": 100,
//         "tags": {
//             "major_brand": "mp42",
//             "minor_version": "0",
//             "compatible_brands": "mp42mp41",
//             "creation_time": "2020-12-22T05:22:33.000000Z"
//         }
//     }
