import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
    final hasText = currentText.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Word Suggestions Chips
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final word = suggestions[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelectSuggestion(word),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: AppColors.primaryLight,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              word,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

        // 2. Action Toolbar Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              // TTS Speak Button with Violet Gradient
              GestureDetector(
                onTap: hasText ? onSpeak : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: hasText
                        ? (isSpeaking
                            ? const LinearGradient(
                                colors: [Color(0xFF059669), Color(0xFF10B981)],
                              )
                            : const LinearGradient(
                                colors: [AppColors.primaryDark, AppColors.primary],
                              ))
                        : null,
                    color: hasText ? null : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: hasText
                        ? [
                            BoxShadow(
                              color: (isSpeaking
                                      ? AppColors.accentGreen
                                      : AppColors.primary)
                                  .withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                    color: hasText ? Colors.white : AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Copy Button
              IconButton(
                tooltip: 'Salin Teks',
                onPressed: hasText ? onCopy : null,
                icon: const Icon(Icons.copy_rounded, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                  foregroundColor: hasText ? AppColors.textPrimary : AppColors.textMuted,
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const Spacer(),

              // Space Button
              ElevatedButton.icon(
                onPressed: hasText ? onSpace : null,
                icon: const Icon(Icons.space_bar, size: 18),
                label: const Text(
                  'Spasi',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                  foregroundColor: hasText ? AppColors.textPrimary : AppColors.textMuted,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.borderLight, width: 0.8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Backspace Button
              IconButton(
                tooltip: 'Hapus Huruf Terakhir',
                onPressed: hasText ? onBackspace : null,
                icon: const Icon(Icons.backspace_outlined, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                  foregroundColor: hasText ? AppColors.textPrimary : AppColors.textMuted,
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Clear All Button
              IconButton(
                tooltip: 'Bersihkan Semua',
                onPressed: hasText ? onClear : null,
                icon: const Icon(Icons.delete_outline, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                  foregroundColor: hasText ? Colors.redAccent : AppColors.textMuted,
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
