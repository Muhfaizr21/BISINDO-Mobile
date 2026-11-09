import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/backend_status_badge.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/history_item_tile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistoryEvent());
  }

  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Hapus Riwayat?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus seluruh riwayat terjemahan ini?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistoryEvent());
              Navigator.pop(ctx);
            },
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Terjemahan'),
        actions: [
          const BackendStatusBadge(),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.textSecondary,
            ),
            tooltip: 'Hapus Semua',
            onPressed: () => _showClearConfirmDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is HistoryLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.history_toggle_off_rounded,
                        size: 48,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum Ada Riwayat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Hasil terjemahan gestur akan tersimpan di sini',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<HistoryBloc>().add(LoadHistoryEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return HistoryItemTile(
                    item: item,
                    onDelete: () {
                      context
                          .read<HistoryBloc>()
                          .add(DeleteHistoryItemEvent(item.id));
                    },
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Terpilih: "${item.text}"'),
                          backgroundColor: AppColors.surfaceElevated,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Terjadi kesalahan: ${state.message}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoryBloc>().add(LoadHistoryEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'Memuat riwayat...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }
}
