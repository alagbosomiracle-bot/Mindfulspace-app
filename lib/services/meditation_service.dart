import 'package:supabase_flutter/supabase_flutter.dart';

class MeditationService {
  final supabase = Supabase.instance.client;

  Future<void> saveSession(int minutes) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('meditation_sessions').insert({
      'user_id': user.id,
      'minutes': minutes,
      'duration': minutes,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getTotalMinutes() async {
    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final data = await supabase
        .from('meditation_sessions')
        .select('minutes')
        .eq('user_id', user.id);

    int total = 0;

    for (final row in data) {
      total += (row['minutes'] as num).toInt();
    }

    return total;
  }

  Future<List<Map<String, dynamic>>> getMeditationHistory() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('meditation_sessions')
        .select('minutes, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}