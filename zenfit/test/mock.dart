import 'package:mockito/annotations.dart';
import 'package:zenfit/db/interfaces/exercise_database_interface.dart';
import 'package:zenfit/db/interfaces/database_helper_interface.dart';
import 'package:zenfit/db/interfaces/sessions_database_interface.dart';

@GenerateMocks([
  ExerciseDatabaseInterface,
  DatabaseHelperInterface,
  SessionDatabaseInterface,
])
void main() {}
