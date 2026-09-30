import 'package:flutter/material.dart';

import '../data/mood_messages.dart';
import '../services/mood_service.dart';
import 'mood_history_screen.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final MoodService _moodService = MoodService();

  String? selectedMood;
  String? affirmation;

  List<Map<String, dynamic>> moodHistory = [];

  bool isLoading = true;
  bool isSaving = false;

  final List<Map<String, String>> moods = [
    {"emoji": "😊", "name": "Happy"},
    {"emoji": "😔", "name": "Sad"},
    {"emoji": "😰", "name": "Anxious"},
    {"emoji": "😡", "name": "Angry"},
    {"emoji": "😴", "name": "Tired"},
    {"emoji": "❤️", "name": "Loved"},
  ];

  @override
  void initState() {
    super.initState();
    loadMoodData();
  }

  Future<void> loadMoodData() async {
    try {
      final latestMood = await _moodService.getLatestMood();
      final history = await _moodService.getMoodHistory();

      if (!mounted) return;

      setState(() {
        selectedMood = latestMood;
        affirmation =
            latestMood == null ? null : moodMessages[latestMood];
        moodHistory = history;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Mood loading error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> selectMood(String mood) async {
    setState(() {
      selectedMood = mood;
      affirmation = moodMessages[mood];
      isSaving = true;
    });

    try {
      await _moodService.saveMood(mood);

      final history = await _moodService.getMoodHistory();

      if (!mounted) return;

      setState(() {
        moodHistory = history;
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mood saved: $mood"),
        ),
      );
    } catch (e) {
      debugPrint("Mood save error: $e");

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to save your mood. Please try again.",
          ),
        ),
      );
    }
  }

  String getMoodEmoji(String mood) {
    for (final item in moods) {
      if (item["name"] == mood) {
        return item["emoji"] ?? "💭";
      }
    }

    return "💭";
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString).toLocal();

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String formatTime(String dateString) {
    final date = DateTime.parse(dateString).toLocal();

    final hour = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadMoodData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "How are you feeling today?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      alignment: WrapAlignment.center,
                      children: moods.map((mood) {
                        final isSelected =
                            selectedMood == mood["name"];

                        return GestureDetector(
                          onTap: isSaving
                              ? null
                              : () => selectMood(
                                    mood["name"]!,
                                  ),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 300),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.deepPurple
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  mood["emoji"]!,
                                  style: const TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  mood["name"]!,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 35),

                    if (affirmation != null)
                      AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 400),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "✨ Mood Message",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              affirmation!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Mood Journey 💗",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              moodHistory.isEmpty
                                  ? "No mood records yet."
                                  : "${moodHistory.length} mood records",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                        TextButton(
                          onPressed: moodHistory.isEmpty
                              ? null
                              : () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MoodHistoryScreen(),
                                    ),
                                  );

                                  if (!mounted) return;

                                  loadMoodData();
                                },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (moodHistory.isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "Your mood history will appear here\n"
                          "as you check in with yourself.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount:
                            moodHistory.length > 3
                                ? 3
                                : moodHistory.length,
                        itemBuilder: (context, index) {
                          final record = moodHistory[index];

                          final mood =
                              record["mood"].toString();

                          final createdAt =
                              record["created_at"].toString();

                          return Card(
                            elevation: 1,
                            margin:
                                const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .deepPurple
                                          .shade50,
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        getMoodEmoji(mood),
                                        style: const TextStyle(
                                          fontSize: 28,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mood,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          formatDate(createdAt),
                                          style: TextStyle(
                                            color:
                                                Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    formatTime(createdAt),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}