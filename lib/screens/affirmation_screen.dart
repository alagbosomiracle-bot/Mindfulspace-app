import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/affirmation_controller.dart';
import '../widgets/affirmation_card.dart';

class AffirmationScreen extends StatefulWidget {
  const AffirmationScreen({super.key});

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  final controller = AffirmationController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Daily Affirmations"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 10),

                const Text(
                  "Today's Reminder ✨",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                AffirmationCard(
                  text: controller.currentAffirmation,
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.toggleFavorite,
                        icon: Icon(
                          controller.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        label: const Text("Favorite"),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Share.share(controller.currentAffirmation);
                        },
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton.icon(
                    onPressed: controller.nextAffirmation,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      "New Affirmation",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Favorites (${controller.favorites.length})",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

              Expanded(
  child: controller.isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : controller.favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite affirmations yet.",
              ),
            )
          : ListView.builder(
              itemCount: controller.favorites.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: Text(
                      controller.favorites[index],
                    ),
                  ),
                );
              },
            ),
),
              ],
            ),
          ),
        );
      },
    );
  }
}