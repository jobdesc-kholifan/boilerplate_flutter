import 'package:shared_preferences/shared_preferences.dart';

import '../models/session_model.dart';

class SessionManager {
  static Future<bool> setLogin(SessionModel sessionModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('jwtToken', sessionModel.jwtToken!);
    sharedPreferences.setInt('userid', sessionModel.userid!);

    return isLogged();
  }

  static Future<SessionModel> current() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return SessionModel(jwtToken: sharedPreferences.getString('jwtToken'));
  }

  static Future<bool> isLogged() async {
    SessionModel session = await current();
    return session.jwtToken != null;
  }

  static Future destroy() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('jwtToken');
    sharedPreferences.remove('userid');
  }
}
