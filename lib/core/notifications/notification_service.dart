import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/enums/reminder_repeat.dart';
import '../../domain/enums/reminder_type.dart';
import '../../domain/models/reminder.dart';
import '../../domain/services/reminder_scheduler.dart';

/// Schedules local notifications for reminders.
///
/// Android 13+ needs POST_NOTIFICATIONS. Exact bill times need
/// SCHEDULE_EXACT_ALARM (see android/app/src/main/AndroidManifest.xml).
/// If that permission is denied, alarms are scheduled inexactly.
/// Web has no local notification plugin here: scheduling is a no-op and the
/// dashboard due list is the reminder surface.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'finance_reminders';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Bill, budget, and daily expense reminders';

  Future<void>? _initializing;
  bool _ready = false;
  bool _exactAlarms = false;
  Future<void> _queue = Future<void>.value();

  /// Initializes time zones, asks for notification and exact-alarm permission
  /// where the platform supports them, and prepares the plugin.
  ///
  /// Safe to call more than once. On web this returns without scheduling.
  Future<void> ensureInitialized() {
    return _initializing ??= _initialize();
  }

  Future<void> rescheduleAll(List<Reminder> reminders) {
    final run = _queue.then((_) => _reschedule(reminders));
    _queue = run.catchError((Object _) {});
    return run;
  }

  Future<void> cancelReminder(String reminderId) {
    final run = _queue.then((_) async {
      await ensureInitialized();
      if (!_ready) return;
      await _plugin.cancel(_notificationId(reminderId));
    });
    _queue = run.catchError((Object _) {});
    return run;
  }

  Future<void> _initialize() async {
    if (kIsWeb) return;
    try {
      tzdata.initializeTimeZones();
      await _setLocalTimeZone();
    } catch (error, stack) {
      debugPrint('Reminder time zone init failed: $error\n$stack');
    }

    await _requestPlatformPermissions();

    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const apple = DarwinInitializationSettings();
      final initialized = await _plugin.initialize(
        const InitializationSettings(
          android: android,
          iOS: apple,
          macOS: apple,
        ),
      );
      _ready = initialized ?? true;
      await _requestPluginPermissions();
    } catch (error, stack) {
      _ready = false;
      debugPrint('Local notifications are unavailable: $error\n$stack');
    }
  }

  Future<void> _setLocalTimeZone() async {
    try {
      final name = (await FlutterTimezone.getLocalTimezone()).trim();
      if (name.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(name));
        return;
      }
    } catch (error) {
      debugPrint('Local time zone lookup failed: $error');
    }
    tz.setLocalLocation(tz.UTC);
  }

  Future<void> _requestPlatformPermissions() async {
    final mobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (!mobile) return;

    try {
      final notifications = await Permission.notification.status;
      if (!notifications.isGranted && !notifications.isLimited) {
        await Permission.notification.request();
      }
    } catch (error) {
      debugPrint('Notification permission request failed: $error');
    }

    if (defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final alarm = await Permission.scheduleExactAlarm.status;
      if (alarm.isGranted) {
        _exactAlarms = true;
      } else {
        final result = await Permission.scheduleExactAlarm.request();
        _exactAlarms = result.isGranted;
      }
    } catch (error) {
      _exactAlarms = false;
      debugPrint('Exact alarm permission request failed: $error');
    }
  }

  Future<void> _requestPluginPermissions() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
      final exact = await android?.requestExactAlarmsPermission();
      if (exact != null) _exactAlarms = exact;
    } catch (error) {
      debugPrint('Android notification plugin permission failed: $error');
    }
  }

  Future<void> _reschedule(List<Reminder> reminders) async {
    await ensureInitialized();
    if (kIsWeb || !_ready) return;
    try {
      await _plugin.cancelAll();
    } catch (error, stack) {
      debugPrint('Cancel reminders failed: $error\n$stack');
    }
    for (final reminder in reminders) {
      if (reminder.isDeleted) continue;
      try {
        await _schedule(reminder);
      } catch (error, stack) {
        debugPrint(
          'Schedule reminder ${reminder.id} failed: $error\n$stack',
        );
      }
    }
  }

  Future<void> _schedule(Reminder reminder) async {
    final fire = ReminderScheduler.nextFireFor(reminder, DateTime.now());
    if (fire == null) return;
    var when = tz.TZDateTime(
      tz.local,
      fire.year,
      fire.month,
      fire.day,
      fire.hour,
      fire.minute,
    );
    final current = tz.TZDateTime.now(tz.local);
    if (!when.isAfter(current)) {
      when = current.add(const Duration(minutes: 1));
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );
    final mode = _exactAlarms
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final id = _notificationId(reminder.id);
    final title = reminder.title;
    final body = _body(reminder);
    final match = _repeatMatch(reminder);
    try {
      await _zonedSchedule(
        id: id,
        title: title,
        body: body,
        when: when,
        details: details,
        mode: mode,
        payload: reminder.id,
        match: match,
      );
    } catch (error) {
      if (mode == AndroidScheduleMode.inexactAllowWhileIdle) rethrow;
      await _zonedSchedule(
        id: id,
        title: title,
        body: body,
        when: when,
        details: details,
        mode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: reminder.id,
      );
      debugPrint('Exact reminder alarm fell back to inexact: $error');
    }
  }

  Future<void> _zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
    required NotificationDetails details,
    required AndroidScheduleMode mode,
    required String payload,
    DateTimeComponents? match,
  }) {
    return _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      details,
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: match,
    );
  }

  DateTimeComponents? _repeatMatch(Reminder reminder) {
    if (reminder.type == ReminderType.dailyExpense) {
      return DateTimeComponents.time;
    }
    return switch (reminder.repeat) {
      ReminderRepeat.daily => DateTimeComponents.time,
      ReminderRepeat.weekly => DateTimeComponents.dayOfWeekAndTime,
      ReminderRepeat.monthly => DateTimeComponents.dayOfMonthAndTime,
      ReminderRepeat.yearly => DateTimeComponents.dateAndTime,
      null => null,
    };
  }

  String _body(Reminder reminder) {
    final note = reminder.note?.trim();
    if (note != null && note.isNotEmpty) return note;
    if (reminder.type == ReminderType.dailyExpense) {
      return "Add today's expenses";
    }
    final due = reminder.dueDate;
    final month = due.month.toString().padLeft(2, '0');
    final day = due.day.toString().padLeft(2, '0');
    return 'Due ${due.year}-$month-$day';
  }

  /// Stable across process restarts. [String.hashCode] is not.
  static int _notificationId(String reminderId) {
    var hash = 0;
    for (final code in reminderId.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }
}
