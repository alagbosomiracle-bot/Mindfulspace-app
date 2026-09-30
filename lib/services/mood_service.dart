import 'package:supabase_flutter/supabase_flutter.dart';

class MoodService {
  final supabase = Supabase.instance.client;

  Future<void> saveMood(String mood) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('moods').insert({
      'user_id': user.id,
      'mood': mood,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<String?> getLatestMood() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final data = await supabase
        .from('moods')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1);

    if (data.isEmpty) return null;

    return data.first['mood'] as String?;
  }

  Future<List<Map<String, dynamic>>> getMoodHistory() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('moods')
        .select('mood, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<Map<String, int>> getMoodCounts() async {
    final history = await getMoodHistory();

    final Map<String, int> counts = {};

    for (final record in history) {
      final mood = record['mood']?.toString();

      if (mood == null || mood.isEmpty) continue;

      counts[mood] = (counts[mood] ?? 0) + 1;
    }

    return counts;
  }
}