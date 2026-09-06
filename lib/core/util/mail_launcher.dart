import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the device's email app at the inbox (not a compose window).
/// Never throws — returns false if nothing could be opened.
Future<bool> openMailApp() async {
  try {
    if (Platform.isAndroid) {
      try {
        // Android's "pick an email app" chooser.
        const intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
          flags: <int>[268435456], // FLAG_ACTIVITY_NEW_TASK
        );
        await intent.launch();
        return true;
      } catch (_) {
        return await _fallbackMailto();
      }
    }

    if (Platform.isIOS) {
      // Undocumented but works: opens Apple Mail inbox.
      final uri = Uri.parse('message://');
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return await _fallbackMailto();
    }

    return await _fallbackMailto();
  } catch (_) {
    return false;
  }
}

Future<bool> _fallbackMailto() async {
  try {
    final uri = Uri(scheme: 'mailto', path: '');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (_) {
    // channel not ready / no handler — fall through
  }
  return false;
}
