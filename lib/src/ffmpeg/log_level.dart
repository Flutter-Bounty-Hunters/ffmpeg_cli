/// The log level to be used, options include
/// `quiet`
/// `panic`
/// `fatal`
/// `error`
/// `warning`
/// `info`
/// `verbose`
/// `debug`
/// `trace`
enum LogLevel {
  quiet,
  panic,
  fatal,
  error,
  warning,
  info,
  verbose,
  debug,
  trace,
}

extension LogLevelSerialization on LogLevel {
  String toFfmpegString() {
    switch (this) {
      case LogLevel.quiet:
        return 'quiet';
      case LogLevel.panic:
        return 'panic';
      case LogLevel.fatal:
        return 'fatal';
      case LogLevel.error:
        return 'error';
      case LogLevel.warning:
        return 'warning';
      case LogLevel.info:
        return 'info';
      case LogLevel.verbose:
        return 'verbose';
      case LogLevel.debug:
        return 'debug';
      case LogLevel.trace:
        return 'trace';
    }
  }
}
