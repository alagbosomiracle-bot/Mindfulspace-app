import 'package:flutter/material.dart';

import '../models/garden_stage.dart';
import '../services/garden_service.dart';

class GrowthGardenCard extends StatefulWidget {
  final int refreshTrigger;

  const GrowthGardenCard({
    super.key,
    this.refreshTrigger = 0,
  });

  @override
  State<GrowthGardenCard> createState() => _GrowthGardenCardState();
}

class _GrowthGardenCardState extends State<GrowthGardenCard> {
  final GardenService gardenService = GardenService();

  GardenStage stage = GardenStage.seed;

  int journals = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadGarden();
    });
  }

  @override
  void didUpdateWidget(covariant GrowthGardenCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshTrigger != widget.refreshTrigger) {
      loadGarden();
    }
  }

  Future<void> loadGarden() async {
    try {
      final journalCount =
          await gardenService.getJournalCount();

      final gardenStage =
          await gardenService.getGardenStage();

      if (!mounted) return;

      setState(() {
        journals = journalCount;
        stage = gardenStage;
        loading = false;
      });
    } catch (e) {
      debugPrint("Garden Error: $e");

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  String stageEmoji() {
    switch (stage) {
      case GardenStage.seed:
        return "🌰";

      case GardenStage.sprout:
        return "🌱";

      case GardenStage.sapling:
        return "🌿";

      case GardenStage.tree:
        return "🌳";

      case GardenStage.blossom:
        return "🌸";
    }
  }

  String stageTitle() {
    switch (stage) {
      case GardenStage.seed:
        return "Tiny Seed";

      case GardenStage.sprout:
        return "Fresh Sprout";

      case GardenStage.sapling:
        return "Growing Sapling";

      case GardenStage.tree:
        return "Strong Tree";

      case GardenStage.blossom:
        return "Blooming Garden";
    }
  }

  String stageMessage() {
    switch (stage) {
      case GardenStage.seed:
        return "Every healing journey begins with one small step.";

      case GardenStage.sprout:
        return "You're showing up for yourself. Keep growing.";

      case GardenStage.sapling:
        return "Your consistency is becoming something beautiful.";

      case GardenStage.tree:
        return "Your emotional resilience is getting stronger every day.";

      case GardenStage.blossom:
        return "Look how far you've come. Your garden is flourishing.";
    }
  }

  double progress() {
    switch (stage) {
      case GardenStage.seed:
        return (journals / 3).clamp(0.0, 1.0);

      case GardenStage.sprout:
        return (journals / 7).clamp(0.0, 1.0);

      case GardenStage.sapling:
        return (journals / 15).clamp(0.0, 1.0);

      case GardenStage.tree:
        return (journals / 25).clamp(0.0, 1.0);

      case GardenStage.blossom:
        return 1.0;
    }
  }

  String progressText() {
    switch (stage) {
      case GardenStage.seed:
        return "$journals / 3 entries to sprout";

      case GardenStage.sprout:
        return "$journals / 7 entries to become a sapling";

      case GardenStage.sapling:
        return "$journals / 15 entries to become a strong tree";

      case GardenStage.tree:
        return "$journals / 25 entries to bloom";

      case GardenStage.blossom:
        return "Your garden is fully blooming 🌸";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            stageEmoji(),
            style: const TextStyle(fontSize: 70),
          ),

          const SizedBox(height: 12),

          Text(
            stageTitle(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            stageMessage(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 25),

          LinearProgressIndicator(
            value: progress(),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 12),

          Text(
            progressText(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
