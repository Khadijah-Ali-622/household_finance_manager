import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String newId() => _uuid.v4();

int nowMillis() => DateTime.now().toUtc().millisecondsSinceEpoch;

DateTime fromMillis(int millis) =>
    DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();

int toMillis(DateTime dt) => dt.toUtc().millisecondsSinceEpoch;
