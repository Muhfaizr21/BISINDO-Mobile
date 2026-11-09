import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/backend_status_badge.dart';
import '../../../history/domain/entities/history_item.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../domain/entities/gesture.dart';
import '../bloc/translate_bloc.dart';
import '../bloc/translate_event.dart';
import '../bloc/translate_state.dart';
import '../widgets/camera_preview_placeholder.dart';

class TranslatePage extends StatelessWidget {
  const TranslatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terjemahkan'),
        actions: [
          const BackendStatusBadge(),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
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
                return CameraPreviewPlaceholder(isDetecting: isDetecting);
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<TranslateBloc, TranslateState>(
              builder: (context, state) {
                String resultText = 'Belum ada deteksi gesture';
                List<Gesture> gestures = [];

                if (state is TranslateDetecting) {
                  resultText = state.translatedText.isEmpty
                      ? 'Mendeteksi...'
                      : state.translatedText;
                  gestures = state.detectedGestures;
                } else if (state is TranslateStopped) {
                  resultText = state.finalTranslation.isEmpty
                      ? 'Deteksi dihentikan'
                      : state.finalTranslation;
                }

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hasil Terjemahan:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resultText,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (gestures.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Gestur Terdeteksi:',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            children: gestures.map((g) {
                              return Chip(
                                label: Text(
                                  '${g.label} (${(g.confidence * 100).toStringAsFixed(0)}%)',
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
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
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor:
                              isDetecting ? Colors.red : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (isDetecting) {
                            context
                                .read<TranslateBloc>()
                                .add(StopDetectionEvent());
                          } else {
                            context
                                .read<TranslateBloc>()
                                .add(StartDetectionEvent());
                          }
                        },
                        icon: Icon(isDetecting ? Icons.stop : Icons.play_arrow),
                        label: Text(
                          isDetecting ? 'Hentikan Deteksi' : 'Mulai Deteksi',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    if (isDetecting) ...[
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Simulasi Gesture (Test)',
                        onPressed: () {
                          context.read<TranslateBloc>().add(
                                const GestureDetectedEvent(
                                  Gesture(label: 'Halo', confidence: 0.98),
                                ),
                              );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<TranslateBloc, TranslateState>(
              builder: (context, state) {
                if (state is TranslateStopped &&
                    state.finalTranslation.isNotEmpty) {
                  return OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      final item = HistoryItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        text: state.finalTranslation,
                        timestamp: DateTime.now(),
                      );
                      context.read<HistoryBloc>().add(AddHistoryItemEvent(item));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tersimpan ke Riwayat & Tersinkron ke Backend'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Simpan ke Riwayat'),
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

