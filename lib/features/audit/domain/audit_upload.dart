import 'package:migraine_tracker/features/audit/domain/self_audit.dart';

/// What leaves the phone when the person shares their audit: five counts
/// and the model version. No dates, no places, no log entries, no account
/// id. The server stamps the month from its own clock.
abstract final class AuditUpload {
  static const keys = {
    'attacks',
    'hits',
    'misses',
    'highDays',
    'falseAlarms',
    'modelVersion',
  };

  static Map<String, Object> payload(AuditCounts c, String modelVersion) => {
    'attacks': c.attacks,
    'hits': c.hits,
    'misses': c.misses,
    'highDays': c.highDays,
    'falseAlarms': c.falseAlarms,
    'modelVersion': modelVersion,
  };
}

/// Sends a payload to the server.
abstract interface class AuditGateway {
  bool get available;
  Future<void> send(Map<String, Object> payload);
}

class UnavailableAuditGateway implements AuditGateway {
  const UnavailableAuditGateway();

  @override
  bool get available => false;

  @override
  Future<void> send(Map<String, Object> payload) async {}
}
