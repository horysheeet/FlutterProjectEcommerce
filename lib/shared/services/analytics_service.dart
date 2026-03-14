import 'dart:convert';
import 'dart:developer' as developer;

class AnalyticsService {
  static final Map<String, int> _eventCounts = <String, int>{};

  static void track(
    String eventName, {
    Map<String, Object?> params = const <String, Object?>{},
  }) {
    _eventCounts[eventName] = (_eventCounts[eventName] ?? 0) + 1;

    final payload = <String, Object?>{
      'event': eventName,
      'count': _eventCounts[eventName],
      'timestamp': DateTime.now().toIso8601String(),
      'params': params,
    };

    developer.log(
      jsonEncode(payload),
      name: 'microbot.analytics',
    );
  }
}
