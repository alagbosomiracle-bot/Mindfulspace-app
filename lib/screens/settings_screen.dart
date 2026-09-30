import 'package:flutter/material.dart';

import '../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeController themeController;

  const SettingsScreen({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          const SizedBox(height: 10),

          const Text(
            "Appearance",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            child: SwitchListTile(
              secondary: Icon(
                themeController.isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),

              title: const Text("Dark Mode"),

              subtitle: const Text(
                "Reduce eye strain at night.",
              ),

              value: themeController.isDark,

              onChanged: (_) {
                themeController.toggleTheme();
              },
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "General",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            subtitle: const Text("Coming Soon"),
            trailing: const Icon(Icons.chevron_right),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            subtitle: const Text("Coming Soon"),
            trailing: const Icon(Icons.chevron_right),
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Privacy"),
            subtitle: const Text("Coming Soon"),
            trailing: const Icon(Icons.chevron_right),
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              "MindfulSpace v1.0",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}