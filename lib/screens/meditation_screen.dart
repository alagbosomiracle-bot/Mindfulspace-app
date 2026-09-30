import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/breathing_circle.dart';
import '../widgets/sound_card.dart';
import '../widgets/meditation_header.dart';
import '../widgets/meditation_timer.dart';
import '../services/meditation_service.dart';
import 'meditation_history_screen.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final MeditationService _meditationService = MeditationService();

  int selectedMinutes = 5;
  int remainingSeconds = 300;

  Timer? timer;
  bool isRunning = false;

  final AudioPlayer player = AudioPlayer();

  String? currentSound;
  double volume = 1.0;

  int totalMinutes = 0;
  int totalSessions = 0;
  bool isLoadingProgress = true;

  @override
  void initState() {
    super.initState();
    loadMeditationProgress();
  }

  Future<void> loadMeditationProgress() async {
    try {
      final history =
          await _meditationService.getMeditationHistory();

      int minutes = 0;

      for (final session in history) {
        minutes += (session['minutes'] as num).toInt();
      }

      if (!mounted) return;

      setState(() {
        totalMinutes = minutes;
        totalSessions = history.length;
        isLoadingProgress = false;
      });
    } catch (e) {
      debugPrint("Meditation progress error: $e");

      if (!mounted) return;

      setState(() {
        isLoadingProgress = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    player.dispose();
    super.dispose();
  }

  Future<void> playSound(String fileName) async {
    try {
      if (currentSound == fileName) {
        await player.stop();

        if (!mounted) return;

        setState(() {
          currentSound = null;
        });

        return;
      }

      await player.stop();
      await player.setVolume(volume);

      await player.play(
        AssetSource('sounds/$fileName'),
      );

      if (!mounted) return;

      setState(() {
        currentSound = fileName;
      });
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  void startMeditation() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
      remainingSeconds = selectedMinutes * 60;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) async {
        if (remainingSeconds <= 1) {
          t.cancel();

          await player.stop();

          try {
            await _meditationService.saveSession(
              selectedMinutes,
            );

            if (!mounted) return;

            await loadMeditationProgress();
          } catch (e) {
            debugPrint("Meditation save error: $e");
          }

          if (!mounted) return;

          setState(() {
            isRunning = false;
            currentSound = null;
            remainingSeconds = 0;
          });

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Session Complete 🌿"),
              content: Text(
                "You completed a $selectedMinutes-minute meditation.\n\n"
                "You took a moment for yourself today.\n\n"
                "Be proud of that.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Thank You"),
                ),
              ],
            ),
          );

          return;
        }

        if (!mounted) return;

        setState(() {
          remainingSeconds--;
        });
      },
    );
  }

  void stopMeditation() {
    timer?.cancel();
    player.stop();

    setState(() {
      isRunning = false;
      currentSound = null;
      remainingSeconds = selectedMinutes * 60;
    });
  }

  String formatTime(int seconds) {
    final mins =
        (seconds ~/ 60).toString().padLeft(2, '0');

    final secs =
        (seconds % 60).toString().padLeft(2, '0');

    return "$mins:$secs";
  }

  Widget minuteChip(int minute) {
    final selected = selectedMinutes == minute;

    return ChoiceChip(
      label: Text("$minute min"),
      selected: selected,
      onSelected: (_) {
        if (isRunning) return;

        setState(() {
          selectedMinutes = minute;
          remainingSeconds = minute * 60;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meditation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MeditationHeader(),

              const SizedBox(height: 20),

              isLoadingProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Your Meditation Journey 🌿",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "$totalMinutes",
                                      style:
                                          const TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Colors.deepPurple,
                                      ),
                                    ),
                                    const Text(
                                      "Total Minutes",
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 45,
                                color: Colors
                                    .deepPurple.shade200,
                              ),

                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "$totalSessions",
                                      style:
                                          const TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Colors.deepPurple,
                                      ),
                                    ),
                                    const Text(
                                      "Sessions",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          TextButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MeditationHistoryScreen(),
                                ),
                              );

                              if (!mounted) return;

                              loadMeditationProgress();
                            },
                            icon:
                                const Icon(Icons.history),
                            label: const Text(
                              "View Meditation History",
                            ),
                          ),
                        ],
                      ),
                    ),

              const SizedBox(height: 25),

              const BreathingCircle(),

              const SizedBox(height: 25),

              MeditationTimer(
                time: formatTime(remainingSeconds),
              ),

              const SizedBox(height: 30),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  minuteChip(2),
                  minuteChip(5),
                  minuteChip(10),
                  minuteChip(15),
                ],
              ),

              const SizedBox(height: 35),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ambient Sounds",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SoundCard(
                icon: Icons.water_drop,
                title: currentSound == "rain.mp3"
                    ? "Gentle Rain • Playing"
                    : "Gentle Rain",
                subtitle: "Perfect for relaxation",
                onTap: () => playSound("rain.mp3"),
              ),

              const SizedBox(height: 12),

              SoundCard(
                icon: Icons.waves,
                title: currentSound == "ocean.mp3"
                    ? "Ocean Waves • Playing"
                    : "Ocean Waves",
                subtitle: "Peaceful shoreline",
                onTap: () => playSound("ocean.mp3"),
              ),

              const SizedBox(height: 12),

              SoundCard(
                icon: Icons.park,
                title: currentSound == "forest.mp3"
                    ? "Forest Breeze • Playing"
                    : "Forest Breeze",
                subtitle: "Birds and leaves",
                onTap: () => playSound("forest.mp3"),
              ),

              const SizedBox(height: 12),

              SoundCard(
                icon: Icons.local_fire_department,
                title: currentSound == "fireplace.mp3"
                    ? "Fireplace • Playing"
                    : "Fireplace",
                subtitle: "Warm and cozy ambience",
                onTap: () => playSound("fireplace.mp3"),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isRunning
                      ? stopMeditation
                      : startMeditation,
                  child: Text(
                    isRunning
                        ? "Stop Session"
                        : "Begin Meditation",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
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