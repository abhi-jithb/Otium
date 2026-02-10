import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// OverlayService: Platform channel for Android system overlay.
///
/// Enables Otium to show breathing intervention OVER other apps.
/// This is critical for detecting fragmentation when user is
/// doom-scrolling Instagram, Twitter, etc.
///
/// Requires SYSTEM_ALERT_WINDOW permission on Android.
class OverlayService {
  static const MethodChannel _channel = MethodChannel('com.otium/intervention');

  static OverlayService? _instance;
  static OverlayService get instance => _instance ??= OverlayService._();

  OverlayService._();

  /// Check if overlay permission is granted
  Future<bool> hasPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'checkOverlayPermission',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ Error checking overlay permission: $e');
      return false;
    }
  }

  /// Request overlay permission from user
  /// Opens system settings for manual grant
  Future<void> requestPermission() async {
    try {
      await _channel.invokeMethod('requestOverlayPermission');
      debugPrint('📱 Overlay permission requested');
    } on PlatformException catch (e) {
      debugPrint('❌ Error requesting overlay permission: $e');
    }
  }

  /// Show breathing intervention overlay over all apps
  Future<bool> showIntervention() async {
    try {
      final result = await _channel.invokeMethod<bool>('showIntervention');
      if (result == true) {
        debugPrint('🫁 Intervention overlay shown');
      }
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ Error showing intervention: $e');
      return false;
    }
  }

  /// Hide intervention overlay
  Future<bool> hideIntervention() async {
    try {
      final result = await _channel.invokeMethod<bool>('hideIntervention');
      debugPrint('✅ Intervention overlay hidden');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ Error hiding intervention: $e');
      return false;
    }
  }

  /// Check and request permission if needed, then show overlay
  Future<bool> showInterventionWithPermissionCheck() async {
    final hasPermission = await this.hasPermission();

    if (!hasPermission) {
      debugPrint('⚠️ Overlay permission not granted');
      return false;
    }

    return showIntervention();
  }
}
