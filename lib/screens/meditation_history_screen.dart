import 'package:flutter/material.dart';
import '../services/meditation_service.dart';

class MeditationHistoryScreen extends StatefulWidget {
  const MeditationHistoryScreen({super.key});

  @override
  State<MeditationHistoryScreen> createState() =>
      _MeditationHistoryScreenState();
}

class _MeditationHistoryScreenState
    extends State<MeditationHistoryScreen> {
  final MeditationService _meditationService =
      MeditationService();

  List<Map<String, dynamic>> meditationHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeditationHistory();
  }

  Future<void> loadMeditationHistory() async {
    try {
      final data =
          await _meditationService.getMeditationHistory();

      if (!mounted) return;

      setState(() {
        meditationHistory = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Meditation history error: $e');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation History'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadMeditationHistory,
              child: meditationHistory.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 180),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No meditation sessions yet.\n\n'
                              'Complete a meditation session to begin your journey. 🌿',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: meditationHistory.length,
                      itemBuilder: (context, index) {
                        final record = meditationHistory[index];

                        final minutes =
                            (record['minutes'] as num).toInt();

                        final createdAt =
                            record['created_at'].toString();

                        return Card(
                          margin:
                              const EdgeInsets.only(bottom: 15),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .deepPurple
                                        .shade50,
                                    borderRadius:
                                        BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.self_improvement,
                                    color: Colors.deepPurple,
                                    size: 30,
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$minutes-minute meditation',
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
            ),
    );
  }
}