import 'package:flutter/material.dart';

class HopeNotesScreen extends StatefulWidget {
  const HopeNotesScreen({super.key});

  @override
  State<HopeNotesScreen> createState() => _HopeNotesScreenState();
}

class _HopeNotesScreenState extends State<HopeNotesScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hope Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Write something your future self may need to hear.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText:
                      "Dear future me...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Hope Note saved."),
                    ),
                  );
                },
                child: const Text("Save Hope Note"),
              ),
            )
          ],
        ),
      ),
    );
  }
}