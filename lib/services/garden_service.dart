import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/garden_stage.dart';

class GardenService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<int> getJournalCount() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return 0;
    }

    final data = await supabase
        .from('journal_entries')
        .select('id')
        .eq('user_id', user.id);

    return data.length;
  }

  Future<GardenStage> getGardenStage() async {
    final journals = await getJournalCount();

    if (journals == 0) {
      return GardenStage.seed;
    }

    if (journals < 7) {
      return GardenStage.sprout;
    }

    if (journals < 15) {
      return GardenStage.sapling;
    }

    if (journals < 25) {
      return GardenStage.tree;
    }

    return GardenStage.blossom;
  }
}

