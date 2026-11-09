import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/backend_status_badge.dart';
import '../../../history/domain/entities/history_item.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../domain/entities/gesture.dart';
import '../../domain/services/indonesian_word_dictionary.dart';
import '../../data/datasources/bisindo_landmark_classifier.dart';
import '../bloc/translate_bloc.dart';
import '../bloc/translate_event.dart';
import '../bloc/translate_state.dart';
import '../widgets/bento_insight_cards.dart';
import '../widgets/camera_view_widget.dart';
import '../widgets/smart_word_toolbar.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  bool _isSpeaking = false;
  BisindoTargetMode _targetMode = BisindoTargetMode.alphabet;
  int _activeTabIndex = 0; // 0: Abjad, 1: Angka, 2: Real-time, 3: Kamus

  @override
  void initState() {
    super.initState();
    sl.ttsService.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TranslateBloc>().add(StartDetectionEvent());
      }
    });
  }

  Future<void> _speakText(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;
    setState(() => _isSpeaking = true);
    await sl.ttsService.speak(clean);
    if (mounted) {
      setState(() => _isSpeaking = false);
    }
  }

  void _showAlphabetPicker(BuildContext context) {
    const letters = [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ];
    const numbers = [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      builder: (ctx) {
        return DefaultTabController(
          length: 2,
          initialIndex: _targetMode == BisindoTargetMode.numbers ? 1 : 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Gestur BISINDO',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textSecondary,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Abjad (A - Z)', icon: Icon(Icons.spellcheck, size: 18)),
                        Tab(text: 'Angka (0 - 9)', icon: Icon(Icons.pin, size: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 230,
                    child: TabBarView(
                      children: [
                        // Abjad Grid
                        SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: letters.map((letter) {
                              return SizedBox(
                                width: 46,
                                height: 46,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.surfaceElevated,
                                    foregroundColor: AppColors.textPrimary,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(color: AppColors.border),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context.read<TranslateBloc>().add(
                                          GestureDetectedEvent(
                                            Gesture(label: letter, confidence: 0.96),
                                          ),
                                        );
                                  },
                                  child: Text(
                                    letter,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // Numbers Grid
                        SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: numbers.map((numStr) {
                              return SizedBox(
                                width: 56,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.surfaceElevated,
                                    foregroundColor: AppColors.accentCyan,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: BorderSide(
                                        color: AppColors.accentCyan.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context.read<TranslateBloc>().add(
                                          GestureDetectedEvent(
                                            Gesture(label: numStr, confidence: 0.96),
                                          ),
                                        );
                                  },
                                  child: Text(
                                    numStr,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveToHistory(BuildContext context, String text) {
    if (text.isEmpty ||
        text == 'Belum ada deteksi gesture' ||
        text == 'Mendeteksi gestur...' ||
        text == 'Deteksi dihentikan') {
      return;
    }
    final item = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
    );
    context.read<HistoryBloc>().add(AddHistoryItemEvent(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tersinkron ke Riwayat: "$text"'),
        backgroundColor: AppColors.surfaceElevated,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayNum = now.day.toString();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Custom App Header (Inspired by Twitch Reference Screenshot)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Brand/Profile Capsule
                    InkWell(
                      onTap: () => _showAlphabetPicker(context),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.primaryDark, AppColors.primary],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sign_language,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'bisindo.ai',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right: Date Badge & Actions
                    Row(
                      children: [
                        // Calendar Day Badge (Matching [ 14 ] in reference)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.textSecondary,
                                size: 13,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                dayNum,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const BackendStatusBadge(),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          tooltip: 'Reset Teks',
                          onPressed: () {
                            context.read<TranslateBloc>().add(ClearTranslationEvent());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Horizontal Pill Filter Tabs (Matching Reference Tab bar)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPillTab(
                        title: 'Abjad A-Z',
                        icon: Icons.spellcheck,
                        index: 0,
                        onTap: () {
                          setState(() {
                            _activeTabIndex = 0;
                            _targetMode = BisindoTargetMode.alphabet;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildPillTab(
                        title: 'Angka 0-9',
                        icon: Icons.pin,
                        index: 1,
                        onTap: () {
                          setState(() {
                            _activeTabIndex = 1;
                            _targetMode = BisindoTargetMode.numbers;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildPillTab(
                        title: 'Real-Time AI',
                        icon: Icons.bolt,
                        index: 2,
                        onTap: () {
                          setState(() => _activeTabIndex = 2);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildPillTab(
                        title: 'Kamus Isyarat',
                        icon: Icons.menu_book,
                        index: 3,
                        onTap: () {
                          setState(() => _activeTabIndex = 3);
                          _showAlphabetPicker(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bento 2x2 Grid of Insight Cards (Twitch Design recreation)
              BlocBuilder<TranslateBloc, TranslateState>(
                builder: (context, state) {
                  final isDetecting = state is TranslateDetecting;
                  return BentoInsightCards(
                    isDetecting: isDetecting,
                    confidence: 0.984,
                  );
                },
              ),
              const SizedBox(height: 20),

              // 4. Section Label: Kamera Real-Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kamera Real-Time',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigher,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _targetMode == BisindoTargetMode.numbers ? 'Mode Angka' : 'Mode Huruf',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 5. Camera Live Viewport Card
              BlocBuilder<TranslateBloc, TranslateState>(
                builder: (context, state) {
                  final isDetecting = state is TranslateDetecting;
                  return CameraViewWidget(
                    cameraService: sl.cameraService,
                    isDetecting: isDetecting,
                    detectedHands: const [],
                    targetMode: _targetMode,
                    onGestureConfirmed: (gesture) {
                      context
                          .read<TranslateBloc>()
                          .add(GestureDetectedEvent(gesture));
                    },
                    onToggleDetection: () {
                      context.read<TranslateBloc>().add(StartDetectionEvent());
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // 6. Translation Results Card & Smart Toolbar
              BlocBuilder<TranslateBloc, TranslateState>(
                builder: (context, state) {
                  String resultText = 'Belum ada deteksi gesture';
                  List<Gesture> gestures = [];

                  if (state is TranslateDetecting) {
                    resultText = state.translatedText.isEmpty
                        ? 'Mendeteksi gestur...'
                        : state.translatedText;
                    gestures = state.detectedGestures;
                  } else if (state is TranslateStopped) {
                    resultText = state.finalTranslation.isEmpty
                        ? 'Deteksi dihentikan'
                        : state.finalTranslation;
                  }

                  final hasText = resultText.isNotEmpty &&
                      resultText != 'Belum ada deteksi gesture' &&
                      resultText != 'Mendeteksi gestur...' &&
                      resultText != 'Deteksi dihentikan';

                  final suggestions =
                      hasText ? IndonesianWordDictionary.getSuggestions(resultText) : const <String>[];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hasil Terjemahan Container
                      Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasText ? AppColors.accentGreen : AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Hasil Terjemahan',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                if (hasText)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          _isSpeaking
                                              ? Icons.volume_up
                                              : Icons.volume_up_outlined,
                                          color: _isSpeaking
                                              ? AppColors.accentGreen
                                              : AppColors.primaryLight,
                                          size: 20,
                                        ),
                                        tooltip: 'Suarakan Kalimat (TTS)',
                                        onPressed: () => _speakText(resultText),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.copy_rounded,
                                          size: 18,
                                          color: AppColors.textSecondary,
                                        ),
                                        tooltip: 'Salin Teks',
                                        onPressed: () {
                                          Clipboard.setData(
                                              ClipboardData(text: resultText));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Teks disalin ke papan klip'),
                                              backgroundColor: AppColors.surfaceElevated,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              resultText,
                              style: TextStyle(
                                fontSize: 24,
                                color: hasText
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (gestures.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Text(
                                'Gestur Terdeteksi:',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: gestures.map((g) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceElevated,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.borderLight,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      '${g.label} (${(g.confidence * 100).toStringAsFixed(0)}%)',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentCyan,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Smart Word Toolbar
                      SmartWordToolbar(
                        currentText: hasText ? resultText : '',
                        suggestions: suggestions,
                        isSpeaking: _isSpeaking,
                        onSpeak: () => _speakText(resultText),
                        onSpace: () {
                          context.read<TranslateBloc>().add(AppendSpaceEvent());
                        },
                        onBackspace: () {
                          context.read<TranslateBloc>().add(BackspaceEvent());
                        },
                        onClear: () {
                          context.read<TranslateBloc>().add(ClearTranslationEvent());
                        },
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: resultText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Teks disalin ke papan klip'),
                              backgroundColor: AppColors.surfaceElevated,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        onSelectSuggestion: (word) {
                          final updated = IndonesianWordDictionary.applySuggestion(
                              resultText, word);
                          context
                              .read<TranslateBloc>()
                              .add(SetTranslatedTextEvent(updated));
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // 7. Detection Actions Bar
              BlocBuilder<TranslateBloc, TranslateState>(
                builder: (context, state) {
                  final isDetecting = state is TranslateDetecting;

                  return Row(
                    children: [
                      // Start/Stop Detection Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDetecting
                                  ? const Color(0xFFDC2626)
                                  : AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadowColor: (isDetecting
                                      ? const Color(0xFFDC2626)
                                      : AppColors.primary)
                                  .withValues(alpha: 0.4),
                            ),
                            onPressed: () {
                              if (isDetecting) {
                                final currentText = state.translatedText;
                                context
                                    .read<TranslateBloc>()
                                    .add(StopDetectionEvent());
                                if (currentText.isNotEmpty) {
                                  _saveToHistory(context, currentText);
                                }
                              } else {
                                context
                                    .read<TranslateBloc>()
                                    .add(StartDetectionEvent());
                              }
                            },
                            icon: Icon(
                              isDetecting ? Icons.stop : Icons.play_arrow_rounded,
                              size: 20,
                            ),
                            label: Text(
                              isDetecting ? 'Hentikan' : 'Mulai Deteksi',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isDetecting) ...[
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.borderLight),
                              backgroundColor: AppColors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            onPressed: () => _showAlphabetPicker(context),
                            icon: const Icon(
                              Icons.touch_app_outlined,
                              size: 18,
                              color: AppColors.primaryLight,
                            ),
                            label: const Text(
                              'Input Isyarat',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              // 8. Save to History Button (When translation available)
              BlocBuilder<TranslateBloc, TranslateState>(
                builder: (context, state) {
                  String translationText = '';
                  if (state is TranslateStopped &&
                      state.finalTranslation.isNotEmpty) {
                    translationText = state.finalTranslation;
                  } else if (state is TranslateDetecting &&
                      state.translatedText.isNotEmpty) {
                    translationText = state.translatedText;
                  }

                  if (translationText.isNotEmpty &&
                      translationText != 'Belum ada deteksi gesture') {
                    return SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => _saveToHistory(context, translationText),
                        icon: const Icon(
                          Icons.bookmark_add_outlined,
                          size: 18,
                          color: AppColors.accentCyan,
                        ),
                        label: const Text(
                          'Simpan ke Riwayat',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Bottom padding so floating bottom dock does not obscure content
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillTab({
    required String title,
    required IconData icon,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = _activeTabIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
