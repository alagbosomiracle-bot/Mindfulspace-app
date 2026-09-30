import 'package:supabase_flutter/supabase_flutter.dart';

class AffirmationService {
  final supabase = Supabase.instance.client;

  Future<List<String>> getFavorites() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('affirmation_favorites')
        .select('affirmation')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return data
        .map<String>((row) => row['affirmation'] as String)
        .toList();
  }

  Future<void> addFavorite(String affirmation) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('affirmation_favorites').insert({
      'user_id': user.id,
      'affirmation': affirmation,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavorite(String affirmation) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase
        .from('affirmation_favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('affirmation', affirmation);
  }
}