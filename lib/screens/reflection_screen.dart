import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/dashboard_service.dart';
import '../widgets/reflection_card.dart';
import '../widgets/wellness_card.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() =>
      _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final JournalService journalService = JournalService();
  final DashboardService dashboardService = DashboardService();

  List<JournalEntry> entries = [];

  String latestMood = "No Mood";
  int meditationMinutes = 0;
  int dayStreak = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReflectionData();
  }

  Future<void> loadReflectionData() async {
    try {
      final journalData = await journalService.getEntries();

      final mood = await dashboardService.getLatestMood();
      final meditation =
          await dashboardService.getMeditationMinutes();
      final streak =
          await dashboardService.getDayStreak();

      if (!mounted) return;

      setState(() {
        entries = journalData
            .map((e) => JournalEntry.fromMap(e))
            .toList();

        latestMood = mood;
        meditationMinutes = meditation;
        dayStreak = streak;

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Reflection Error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String getReflectionMessage() {
    if (entries.isEmpty) {
      return "Your journey is just beginning. "
          "Start by writing your first reflection.";
    }

    if (entries.length == 1) {
      return "You've taken your first step. "
          "Keep checking in with yourself.";
    }

    if (entries.length < 5) {
      return "You're beginning to build a reflection habit. "
          "Keep going. 🌱";
    }

    if (entries.length < 10) {
      return "You're creating a meaningful record "
          "of your wellness journey. 🌿";
    }

    return "You've made reflection part of your journey. "
        "Keep growing. 💚";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reflection"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadReflectionData,
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Wellness Journey 🌿",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "A look back at your progress and reflections.",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // WELLNESS SUMMARY
                    GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        WellnessCard(
                          icon: Icons.menu_book,
                          title: "Reflections",
                          value: "${entries.length}",
                          color: Colors.deepPurple,
                        ),
                        WellnessCard(
                          icon: Icons.favorite,
                          title: "Latest Mood",
                          value: latestMood,
                          color: Colors.pink,
                        ),
                        WellnessCard(
                          icon: Icons.self_improvement,
                          title: "Meditation",
                          value: "${meditationMinutes}m",
                          color: Colors.teal,
                        ),
                        WellnessCard(
                          icon:
                              Icons.local_fire_department,
                          title: "Day Streak",
                          value: "$dayStreak",
                          color: Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // PROGRESS MESSAGE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(22),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "🌱",
                            style: TextStyle(
                              fontSize: 32,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your Progress",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  getReflectionMessage(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors
                                        .grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // REFLECTIONS
                    const Text(
                      "Your Reflections",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      entries.isEmpty
                          ? "No reflections yet."
                          : "${entries.length} reflections recorded",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (entries.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        child: Center(
                          child: Text(
                            "Your reflection timeline is empty.\n\n"
                            "Start journaling to see your journey.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ),
                      )
                    else
                      ...entries.map(
                        (entry) => ReflectionCard(
                          entry: entry,
                        ),
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}