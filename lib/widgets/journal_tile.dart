import 'package:flutter/material.dart';

class JournalTile extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onDelete;

  const JournalTile({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              entry['mood'] ?? "😊 Happy",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 12),

            Text(
              entry['content'] ?? "",
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  (entry['created_at'] ?? "")
                      .toString()
                      .substring(0, 10),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}