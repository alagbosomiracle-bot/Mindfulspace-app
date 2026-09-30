import 'package:flutter/material.dart';

import '../services/journal_service.dart';
import '../widgets/journal_header.dart';
import '../widgets/journal_input_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/journal_list.dart';
import '../widgets/primary_button.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalService _journalService = JournalService();

  final TextEditingController _controller =
      TextEditingController();

  List<Map<String, dynamic>> entries = [];

  bool isLoading = true;
  bool isSaving = false;

  String selectedMood = "😊 Happy";

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final data = await _journalService.getEntries();

      if (!mounted) return;

      setState(() {
        entries = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Journal loading error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveEntry() async {
    final text = _controller.text.trim();

    if (text.isEmpty || isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await _journalService.addEntry(
        text,
        selectedMood,
      );

      _controller.clear();

      await loadEntries();

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "🌿 Your thoughts have been safely planted.",
          ),
        ),
      );
    } catch (e) {
      debugPrint("Journal save error: $e");

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to save your journal entry. Please try again.",
          ),
        ),
      );
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await _journalService.deleteEntry(id);

      await loadEntries();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Journal entry deleted."),
        ),
      );
    } catch (e) {
      debugPrint("Journal delete error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to delete this entry. Please try again.",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const JournalHeader(),

            const SizedBox(height: 20),

            MoodSelector(
              selectedMood: selectedMood,
              onChanged: (mood) {
                setState(() {
                  selectedMood = mood;
                });
              },
            ),

            const SizedBox(height: 20),

            JournalInputCard(
              controller: _controller,
            ),

            const SizedBox(height: 20),

            PrimaryButton(
              text: isSaving ? "Saving..." : "Save Entry",
              icon: isSaving
                  ? Icons.hourglass_top
                  : Icons.book,
              onPressed: () {
                if (!isSaving) {
                  saveEntry();
                }
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : JournalList(
                      entries: entries,
                      onDelete: deleteEntry,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}