import 'dart:developer' as dev;

/// Logger مركزي للتطبيق
/// يوفر مستويات منظمة: info, warning, error, debug
class AppLogger {
  AppLogger._();

  static const String _tag = '[Driver]';

  static void info(String message, {String? tag}) {
    dev.log('$_tag [INFO] ${tag ?? ''} $message');
  }

  static void warning(String message, {String? tag}) {
    dev.log('$_tag [WARN] ${tag ?? ''} $message');
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    dev.log(
      '$_tag [ERROR] ${tag ?? ''} $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void debug(String message, {String? tag}) {
    assert(() {
      dev.log('$_tag [DEBUG] ${tag ?? ''} $message');
      return true;
    }());
  }
}
