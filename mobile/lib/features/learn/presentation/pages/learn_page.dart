import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/backend_status_badge.dart';
import '../bloc/learn_bloc.dart';
import '../bloc/learn_event.dart';
import '../bloc/learn_state.dart';
import '../../domain/entities/learn_item.dart';
import '../widgets/learn_item_card.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  void initState() {
    super.initState();
    context.read<LearnBloc>().add(LoadLearnMaterialsEvent());
  }

  void _showDetailBottomSheet(BuildContext context, LearnItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigher,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight, width: 0.8),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (item.imageAsset != null)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        item.imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Center(
                          child: Icon(
                            Icons.sign_language,
                            size: 48,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Instruksi Gerakan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.surface,
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: AppColors.surface,
                elevation: 0,
                title: const Text(
                  'Panduan Alfabet BISINDO',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 3.5,
                  child: Image.asset(
                    'assets/images/bisindo_chart.png',
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Gagal memuat gambar chart.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Belajar Bahasa Isyarat'),
        actions: const [
          BackendStatusBadge(),
        ],
      ),
      body: BlocBuilder<LearnBloc, LearnState>(
        builder: (context, state) {
          if (state is LearnLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is LearnLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada materi pembelajaran.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: state.items.length + 1,
              itemBuilder: (context, index) {
                // Header banner for full chart
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.menu_book,
                            color: AppColors.primaryLight,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bagan Lengkap BISINDO',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Panduan visual abjad A sampai Z & angka',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showChartDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Buka',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final item = state.items[index - 1];
                return LearnItemCard(
                  item: item,
                  onTap: () => _showDetailBottomSheet(context, item),
                );
              },
            );
          } else if (state is LearnError) {
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
                      context.read<LearnBloc>().add(LoadLearnMaterialsEvent());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'Siap memulai belajar.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }
}
