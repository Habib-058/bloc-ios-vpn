import '../strings.dart';
import 'shared_preferences_repository.dart';

class UserPreferencesRepository {
  // Private constructor to prevent instantiation
  UserPreferencesRepository._();

  static Future<bool?> getAcceptedPolicy() async {
    return await SharedPreferencesRepository.getBool(Strings.acceptedPolicy);
  }

  static Future<void> setAcceptedPolicy(bool acceptedPolicy) async {
     await SharedPreferencesRepository.saveBool(Strings.acceptedPolicy, acceptedPolicy);
  }

}

