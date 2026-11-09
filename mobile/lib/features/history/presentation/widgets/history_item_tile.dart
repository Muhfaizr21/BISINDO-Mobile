import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
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
        '${item.timestamp.day.toString().padLeft(2, '0')}/${item.timestamp.month.toString().padLeft(2, '0')}/${item.timestamp.year} • ${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: AppColors.primaryLight,
              size: 20,
            ),
          ),
          title: Text(
            item.text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            dateStr,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'Salin Teks',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: item.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Teks disalin ke papan klip'),
                      backgroundColor: AppColors.surfaceElevated,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 19,
                  color: Color(0xFFEF4444),
                ),
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
