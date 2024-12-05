import 'package:zenfit/models/session_model.dart';

abstract class SessionDatabaseInterface {
  Future<int> createSession(Session session);
  Future<List<Session>> readAllSessions();
  Future<int> updateSession(Session session);
  Future<int> deleteSession(int sessionId);
}
