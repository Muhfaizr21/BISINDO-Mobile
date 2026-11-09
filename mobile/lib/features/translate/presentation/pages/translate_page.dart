import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/backend_status_badge.dart';
import '../../../history/domain/entities/history_item.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../domain/entities/gesture.dart';
import '../../domain/services/indonesian_word_dictionary.dart';
import '../bloc/translate_bloc.dart';
import '../bloc/translate_event.dart';
import '../bloc/translate_state.dart';
import '../widgets/camera_view_widget.dart';
import '../widgets/smart_word_toolbar.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    sl.ttsService.initialize();
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pilih Gestur Huruf BISINDO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: letters.map((letter) {
                    return SizedBox(
                      width: 46,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
              ],
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
        content: Text('Tersinkron ke Riwayat & Backend: "$text"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terjemahkan'),
        actions: [
          const BackendStatusBadge(),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Teks',
            onPressed: () {
              context.read<TranslateBloc>().add(ClearTranslationEvent());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<TranslateBloc, TranslateState>(
              builder: (context, state) {
                final isDetecting = state is TranslateDetecting;
                return CameraViewWidget(
                  cameraService: sl.cameraService,
                  isDetecting: isDetecting,
                  detectedHands: const [],
                  onGestureConfirmed: (gesture) {
                    context
                        .read<TranslateBloc>()
                        .add(GestureDetectedEvent(gesture));
                  },
                );
              },
            ),
            const SizedBox(height: 16),
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
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Hasil Terjemahan:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
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
                                              ? Colors.green
                                              : Colors.blueAccent,
                                          size: 22,
                                        ),
                                        tooltip: 'Suarakan Kalimat (TTS)',
                                        onPressed: () => _speakText(resultText),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy, size: 20),
                                        tooltip: 'Salin Teks',
                                        onPressed: () {
                                          Clipboard.setData(
                                              ClipboardData(text: resultText));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Teks disalin ke papan klip'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              resultText,
                              style: TextStyle(
                                fontSize: 22,
                                color: hasText
                                    ? Colors.blue.shade800
                                    : Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (gestures.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Gestur Terdeteksi:',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: gestures.map((g) {
                                  return Chip(
                                    visualDensity: VisualDensity.compact,
                                    label: Text(
                                      '${g.label} (${(g.confidence * 100).toStringAsFixed(0)}%)',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
            BlocBuilder<TranslateBloc, TranslateState>(
              builder: (context, state) {
                final isDetecting = state is TranslateDetecting;

                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDetecting ? Colors.red : Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                          icon:
                              Icon(isDetecting ? Icons.stop : Icons.play_arrow),
                          label: Text(
                            isDetecting ? 'Hentikan' : 'Mulai Deteksi',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    if (isDetecting) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: Tooltip(
                          message: 'Simulasi Alfabet BISINDO',
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _showAlphabetPicker(context),
                            icon: const Icon(Icons.touch_app),
                            label: const Text('Input Huruf'),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _saveToHistory(context, translationText),
                      icon: const Icon(Icons.bookmark_add_outlined),
                      label: const Text('Simpan ke Riwayat'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
