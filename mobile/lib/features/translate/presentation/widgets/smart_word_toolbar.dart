import 'package:flutter/material.dart';

class SmartWordToolbar extends StatelessWidget {
  final String currentText;
  final List<String> suggestions;
  final VoidCallback onSpeak;
  final VoidCallback onSpace;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onCopy;
  final ValueChanged<String> onSelectSuggestion;
  final bool isSpeaking;

  const SmartWordToolbar({
    super.key,
    required this.currentText,
    required this.suggestions,
    required this.onSpeak,
    required this.onSpace,
    required this.onBackspace,
    required this.onClear,
    required this.onCopy,
    required this.onSelectSuggestion,
    this.isSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = currentText.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Word Suggestions Chips
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final word = suggestions[index];
                  return ActionChip(
                    avatar: const Icon(Icons.auto_awesome, size: 16, color: Colors.blueAccent),
                    label: Text(
                      word,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    onPressed: () => onSelectSuggestion(word),
                  );
                },
              ),
            ),
          ),

        // 2. Action Toolbar Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              // TTS Speak Button
              IconButton.filledTonal(
                tooltip: 'Suarakan Kalimat (TTS)',
                onPressed: hasText ? onSpeak : null,
                icon: Icon(
                  isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                  color: isSpeaking ? Colors.green : theme.colorScheme.primary,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size(40, 40),
                ),
              ),
              const SizedBox(width: 6),

              // Copy Button
              IconButton.outlined(
                tooltip: 'Salin Teks',
                onPressed: hasText ? onCopy : null,
                icon: const Icon(Icons.copy_rounded, size: 18),
                style: IconButton.styleFrom(
                  minimumSize: const Size(38, 38),
                  padding: EdgeInsets.zero,
                ),
              ),

              const Spacer(),

              // Space Button
              FilledButton.tonalIcon(
                onPressed: hasText ? onSpace : null,
                icon: const Icon(Icons.space_bar, size: 18),
                label: const Text('Spasi', style: TextStyle(fontSize: 12)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 38),
                ),
              ),
              const SizedBox(width: 6),

              // Backspace Button
              IconButton.outlined(
                tooltip: 'Hapus Huruf Terakhir',
                onPressed: hasText ? onBackspace : null,
                icon: const Icon(Icons.backspace_outlined, size: 18),
                style: IconButton.styleFrom(
                  minimumSize: const Size(38, 38),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 4),

              // Clear All Button
              IconButton(
                tooltip: 'Bersihkan Semua',
                onPressed: hasText ? onClear : null,
                icon: Icon(
                  Icons.delete_outline,
                  color: hasText ? Colors.redAccent : theme.disabledColor,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size(38, 38),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
