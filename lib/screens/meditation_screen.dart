import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../services/meditation_service.dart';
import '../widgets/breathing_circle.dart';
import '../widgets/meditation_header.dart';
import '../widgets/meditation_timer.dart';
import '../widgets/sound_card.dart';
import 'meditation_history_screen.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final MeditationService _meditationService = MeditationService();
  final AudioPlayer player = AudioPlayer();

  Timer? timer;

  int selectedMinutes = 5;
  int remainingSeconds = 300;

  bool isRunning = false;
  bool isPaused = false;

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
      isPaused = false;

      if (remainingSeconds <= 0) {
        remainingSeconds = selectedMinutes * 60;
      }
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
            isPaused = false;
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

        if (!mounted || isPaused) return;

        setState(() {
          remainingSeconds--;
        });
      },
    );
  }

  void pauseMeditation() {
    if (!isRunning) return;

    timer?.cancel();

    setState(() {
      isPaused = true;
    });
  }

  void resumeMeditation() {
    if (!isRunning || !isPaused) return;

    setState(() {
      isPaused = false;
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
            isPaused = false;
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

        if (!mounted || isPaused) return;

        setState(() {
          remainingSeconds--;
        });
      },
    );
  }

  Future<void> stopMeditation() async {
    timer?.cancel();
    await player.stop();

    if (!mounted) return;

    setState(() {
      isRunning = false;
      isPaused = false;
      currentSound = null;
      remainingSeconds = selectedMinutes * 60;
    });
  }

  String formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');

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

  Widget buildControlButton() {
    if (!isRunning) {
      return ElevatedButton.icon(
        onPressed: startMeditation,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text("Begin Meditation"),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                isPaused ? resumeMeditation : pauseMeditation,
            icon: Icon(
              isPaused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
            ),
            label: Text(
              isPaused ? "Resume" : "Pause",
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          width: 56,
          child: OutlinedButton(
            onPressed: stopMeditation,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Icon(Icons.stop_rounded),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text("Meditation"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            children: [
              const MeditationHeader(),

              const SizedBox(height: 8),

              // Meditation focus area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEDE7F6),
                      Color(0xFFE8F5F2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const BreathingCircle(),

                    const SizedBox(height: 18),

                    MeditationTimer(
                      time: formatTime(remainingSeconds),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      isPaused
                          ? "Paused"
                          : isRunning
                              ? "Stay present"
                              : "Find your stillness",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        minuteChip(2),
                        minuteChip(5),
                        minuteChip(10),
                        minuteChip(15),
                      ],
                    ),

                    const SizedBox(height: 22),

                    buildControlButton(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Ambient sounds
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your atmosphere",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose a sound to accompany your meditation.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SoundCard(
                icon: Icons.water_drop_rounded,
                title: currentSound == "rain.mp3"
                    ? "Gentle Rain • Playing"
                    : "Gentle Rain",
                subtitle: "Soft rainfall for relaxation",
                onTap: () => playSound("rain.mp3"),
              ),

              const SizedBox(height: 12),

              SoundCard(
                icon: Icons.waves_rounded,
                title: currentSound == "ocean.mp3"
                    ? "Ocean Waves • Playing"
                    : "Ocean Waves",
                subtitle: "Peaceful shoreline ambience",
                onTap: () => playSound("ocean.mp3"),
              ),

              const SizedBox(height: 12),

              SoundCard(
                icon: Icons.park_rounded,
                title: currentSound == "forest.mp3"
                    ? "Forest Breeze • Playing"
                    : "Forest Breeze",
                subtitle: "Birds, leaves and fresh air",
                onTap: () => playSound("forest.mp3"),
              ),

              const SizedBox(height: 12),

              SoundCard(
                icon: Icons.local_fire_department_rounded,
                title: currentSound == "fireplace.mp3"
                    ? "Fireplace • Playing"
                    : "Fireplace",
                subtitle: "Warm and cozy ambience",
                onTap: () => playSound("fireplace.mp3"),
              ),

              const SizedBox(height: 20),

              // Volume
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      volume == 0
                          ? Icons.volume_off_rounded
                          : Icons.volume_down_rounded,
                      color: Colors.deepPurple,
                    ),
                    Expanded(
                      child: Slider(
                        value: volume,
                        min: 0,
                        max: 1,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            volume = value;
                          });

                          player.setVolume(value);
                        },
                      ),
                    ),
                    const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Progress
              if (isLoadingProgress)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Your meditation journey",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: _ProgressStat(
                              value: "$totalSessions",
                              label: "Sessions",
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 42,
                            color: Colors.grey.shade200,
                          ),
                          Expanded(
                            child: _ProgressStat(
                              value: "$totalMinutes",
                              label: "Minutes",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

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

                          await loadMeditationProgress();
                        },
                        icon: const Icon(
                          Icons.history_rounded,
                        ),
                        label: const Text(
                          "View Meditation History",
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProgressStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}