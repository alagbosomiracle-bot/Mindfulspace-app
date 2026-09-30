import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final supabase = Supabase.instance.client;

  Future<int> getJournalCount() async {
    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final data = await supabase
        .from('journal_entries')
        .select('id')
        .eq('user_id', user.id);

    return data.length;
  }

  Future<String> getLatestMood() async {
    final user = supabase.auth.currentUser;

    if (user == null) return "No Mood";

    final data = await supabase
        .from('moods')
        .select('mood')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1);

    if (data.isEmpty) return "No Mood";

    return data.first['mood']?.toString() ?? "No Mood";
  }

  Future<int> getMeditationMinutes() async {
    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final data = await supabase
        .from('meditation_sessions')
        .select('minutes')
        .eq('user_id', user.id);

    int total = 0;

    for (final session in data) {
      final minutes = session['minutes'];

      if (minutes is num) {
        total += minutes.toInt();
      }
    }

    return total;
  }

  Future<int> getDayStreak() async {
    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final journalData = await supabase
        .from('journal_entries')
        .select('created_at')
        .eq('user_id', user.id);

    final moodData = await supabase
        .from('moods')
        .select('created_at')
        .eq('user_id', user.id);

    final meditationData = await supabase
        .from('meditation_sessions')
        .select('created_at')
        .eq('user_id', user.id);

    final Set<String> activeDates = {};

    void addDates(List<dynamic> data) {
      for (final entry in data) {
        final createdAt = entry['created_at'];

        if (createdAt == null) continue;

        final date = DateTime.parse(
          createdAt.toString(),
        ).toLocal();

        activeDates.add(
          '${date.year}-${date.month}-${date.day}',
        );
      }
    }

    addDates(journalData);
    addDates(moodData);
    addDates(meditationData);

    if (activeDates.isEmpty) return 0;

    DateTime currentDate = DateTime.now();

    DateTime today = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    final todayKey =
        '${today.year}-${today.month}-${today.day}';

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final yesterdayKey =
        '${yesterday.year}-${yesterday.month}-${yesterday.day}';

    // If the user has no activity today or yesterday,
    // their current streak has ended.
    if (!activeDates.contains(todayKey) &&
        !activeDates.contains(yesterdayKey)) {
      return 0;
    }

    // Start counting from today if active,
    // otherwise continue from yesterday.
    if (activeDates.contains(todayKey)) {
      currentDate = today;
    } else {
      currentDate = yesterday;
    }

    int streak = 0;

    while (true) {
      final key =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';

      if (!activeDates.contains(key)) {
        break;
      }

      streak++;

      currentDate = currentDate.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }
}