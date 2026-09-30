import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ezklvuygkwjjrctenjtq.supabase.co',

    // ⬇️ IMPORTANT:
    // Paste your COMPLETE anon key here from Supabase.
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV6a2x2dXlna3dqanJjdGVuanRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkyMTkwMDUsImV4cCI6MjA5NDc5NTAwNX0.-FH08jaU8tTKrt6I5d0UT-XmAolyn8L7nI_K3epcAB4',
  );

  runApp(MindfulSpaceApp());
}

class MindfulSpaceApp extends StatefulWidget {
  MindfulSpaceApp({super.key});

  @override
  State<MindfulSpaceApp> createState() => _MindfulSpaceAppState();
}

class _MindfulSpaceAppState extends State<MindfulSpaceApp> {
  final ThemeController themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MindfulSpace',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeController.isDark ? ThemeMode.dark : ThemeMode.light,
          home: HomeWrapper(
            themeController: themeController,
          ),
        );
      },
    );
  }
}

class HomeWrapper extends StatelessWidget {
  final ThemeController themeController;

  const HomeWrapper({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      themeController: themeController,
    );
  }
}

class AuthGate extends StatelessWidget {
  final ThemeController? themeController;

  const AuthGate({
    super.key,
    this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final controller = themeController ?? ThemeController();

    if (user != null) {
      return HomeScreen(
        themeController: controller,
      );
    }

    return const AuthScreen();
  }
}