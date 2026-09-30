class JournalEntry {
  final int id;
  final String content;
  final String mood;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.content,
    required this.mood,
    required this.createdAt,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      content: map['content'],
      mood: map['mood'] ?? "😌",
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}