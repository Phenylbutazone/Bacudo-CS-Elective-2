import 'dart:io' show Platform;

import 'package:cs_elective_2/utils/breakpoints.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Platform helpers for adaptive (native-feel) UI.
class PlatformAdaptive {
  PlatformAdaptive._();

  static bool get isWeb => kIsWeb;

  static bool get isIOS =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Use Cupertino-style chrome on Apple mobile/desktop targets.
  static bool get useCupertino => isIOS;

  /// Web and desktop widths benefit from hover affordances and denser chrome.
  static bool preferMouseInteractions(BuildContext context) {
    return isWeb || Breakpoints.isDesktop(MediaQuery.sizeOf(context).width);
  }
}
