import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/history_item.dart';

class HistoryItemTile extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const HistoryItemTile({
    super.key,
    required this.item,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${item.timestamp.day.toString().padLeft(2, '0')}/${item.timestamp.month.toString().padLeft(2, '0')}/${item.timestamp.year} ${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.history, color: Colors.blue),
          ),
          title: Text(
            item.text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            dateStr,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Salin Teks',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: item.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Teks disalin ke papan klip'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                tooltip: 'Hapus',
                onPressed: onDelete,
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
