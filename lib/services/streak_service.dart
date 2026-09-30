import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('streak') ?? 0;
  }

  Future<void> increaseStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final streak = prefs.getInt('streak') ?? 0;

    await prefs.setInt('streak', streak + 1);
  }

  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', 0);
  }
}