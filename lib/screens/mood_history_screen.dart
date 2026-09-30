import 'package:flutter/material.dart';
import '../services/mood_service.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  final MoodService _moodService = MoodService();

  List<Map<String, dynamic>> moodHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMoodHistory();
  }

  Future<void> loadMoodHistory() async {
    try {
      final data = await _moodService.getMoodHistory();

      if (!mounted) return;

      setState(() {
        moodHistory = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Mood history error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString).toLocal();

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatTime(String dateString) {
    final date = DateTime.parse(dateString).toLocal();

    final hour = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  String getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Sad':
        return '😔';
      case 'Anxious':
        return '😰';
      case 'Angry':
        return '😡';
      case 'Tired':
        return '😴';
      case 'Loved':
        return '❤️';
      default:
        return '🌿';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : moodHistory.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'No mood records yet.\n\n'
                      'Start tracking your mood to see your journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadMoodHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: moodHistory.length,
                    itemBuilder: (context, index) {
                      final record = moodHistory[index];

                      final mood = record['mood'].toString();
                      final createdAt =
                          record['created_at'].toString();

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius:
                                      BorderRadius.circular(17),
                                ),
                                child: Center(
                                  child: Text(
                                    getMoodEmoji(mood),
                                    style: const TextStyle(
                                      fontSize: 30,
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      formatDate(createdAt),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
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
                ),
    );
  }
}