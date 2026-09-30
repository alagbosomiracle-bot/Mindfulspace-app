import 'package:flutter/material.dart';
import '../services/journal_service.dart';

class JournalController extends ChangeNotifier {
  final JournalService _service = JournalService();

  final TextEditingController textController = TextEditingController();

  List<Map<String, dynamic>> entries = [];

  bool isLoading = false;

  String selectedMood = "😊 Happy";

  Future<void> loadEntries() async {
    isLoading = true;
    notifyListeners();

    try {
      entries = await _service.getEntries();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> saveEntry() async {
    if (textController.text.trim().isEmpty) return;

    try {
      await _service.addEntry(
        textController.text.trim(),
        selectedMood,
      );

      textController.clear();

      await loadEntries();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteEntry(int id) async {
    await _service.deleteEntry(id);

    await loadEntries();
  }

  void changeMood(String mood) {
    selectedMood = mood;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}