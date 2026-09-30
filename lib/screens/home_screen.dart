import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/premium_header.dart';
import '../widgets/growth_garden_card.dart';
import '../widgets/wellness_card.dart';
import '../widgets/daily_quote_card.dart';
import '../widgets/dashboard_card.dart';
import '../services/dashboard_service.dart';

import 'journal_screen.dart';
import 'mood_screen.dart';
import 'meditation_screen.dart';
import 'affirmation_screen.dart';
import 'reflection_screen.dart';
import 'settings_screen.dart';
import '../controllers/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  final ThemeController themeController;

  const HomeScreen({
    super.key,
    required this.themeController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardService dashboardService = DashboardService();

  int journalCount = 0;
  String latestMood = "No Mood";
  int meditationMinutes = 0;
  int dayStreak = 0;

  bool loading = true;

  int gardenRefreshTrigger = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final journals = await dashboardService.getJournalCount();

      final mood = await dashboardService.getLatestMood();

      final meditation =
          await dashboardService.getMeditationMinutes();

      final streak = await dashboardService.getDayStreak();

      if (!mounted) return;

      setState(() {
        journalCount = journals;
        latestMood = mood;
        meditationMinutes = meditation;
        dayStreak = streak;
        loading = false;
      });
    } catch (e) {
      debugPrint("Dashboard Error: $e");

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀️";
    }

    if (hour < 17) {
      return "Good Afternoon 🌤️";
    }

    return "Good Evening 🌙";
  }

  String getUserName() {
    final user = Supabase.instance.client.auth.currentUser;

    return user?.userMetadata?['name'] ??
        user?.email?.split('@').first ??
        "Friend";
  }

  @override
  Widget build(BuildContext context) {
    final name = getUserName();

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PremiumHeader(
                      greeting: getGreeting(),
                      name: name,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: "Settings",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            themeController:
                                widget.themeController,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // GROWTH GARDEN
              GrowthGardenCard(
                refreshTrigger: gardenRefreshTrigger,
              ),

              const SizedBox(height: 25),

              // WELLNESS CARDS
              if (loading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              else
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
                      icon: Icons.local_fire_department,
                      title: "Day Streak",
                      value: "$dayStreak",
                      color: Colors.orange,
                    ),
                    WellnessCard(
                      icon: Icons.favorite,
                      title: "Mood",
                      value: latestMood,
                      color: Colors.pink,
                    ),
                    WellnessCard(
                      icon: Icons.menu_book,
                      title: "Journal",
                      value: "$journalCount",
                      color: Colors.deepPurple,
                    ),
                    WellnessCard(
                      icon: Icons.self_improvement,
                      title: "Meditation",
                      value: "${meditationMinutes}m",
                      color: Colors.teal,
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              // DAILY QUOTE
              const DailyQuoteCard(),

              const SizedBox(height: 30),

              // QUICK ACTIONS TITLE
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Quick Actions",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),
              ),

              const SizedBox(height: 15),

              // QUICK ACTION CARDS
              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.95,
                children: [
                  // JOURNAL
                  DashboardCard(
                    icon: Icons.menu_book,
                    title: "Journal",
                    subtitle: "Write freely",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const JournalScreen(),
                        ),
                      );

                      if (!mounted) return;

                      await loadDashboard();

                      if (!mounted) return;

                      setState(() {
                        gardenRefreshTrigger++;
                      });
                    },
                  ),

                  // MOOD
                  DashboardCard(
                    icon: Icons.favorite,
                    title: "Mood",
                    subtitle: "Track feelings",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MoodScreen(),
                        ),
                      );

                      if (!mounted) return;

                      await loadDashboard();
                    },
                  ),

                  // MEDITATION
                  DashboardCard(
                    icon: Icons.self_improvement,
                    title: "Meditation",
                    subtitle: "Relax",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MeditationScreen(),
                        ),
                      );

                      if (!mounted) return;

                      await loadDashboard();
                    },
                  ),

                  // REFLECTION
                  DashboardCard(
                    icon: Icons.history,
                    title: "Reflection",
                    subtitle: "Your journey",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ReflectionScreen(),
                        ),
                      );
                    },
                  ),

                  // AFFIRMATIONS
                  DashboardCard(
                    icon: Icons.auto_awesome,
                    title: "Affirmations",
                    subtitle: "Stay Positive",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AffirmationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

