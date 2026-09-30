import 'package:supabase_flutter/supabase_flutter.dart';

class JournalService {
  final supabase = Supabase.instance.client;

  Future<void> addEntry(
    String text,
    String mood,
  ) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('journal_entries').insert({
      'content': text,
      'mood': mood,
      'created_at': DateTime.now().toIso8601String(),
      'user_id': user.id,
    });
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('journal_entries')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> deleteEntry(int id) async {
    await supabase
        .from('journal_entries')
        .delete()
        .eq('id', id);
  }
}