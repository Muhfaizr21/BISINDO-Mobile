import 'package:flutter/material.dart';
import '../di/injection.dart';
import '../network/backend_health_service.dart';
import '../theme/app_theme.dart';

class BackendStatusBadge extends StatefulWidget {
  const BackendStatusBadge({super.key});

  @override
  State<BackendStatusBadge> createState() => _BackendStatusBadgeState();
}

class _BackendStatusBadgeState extends State<BackendStatusBadge> {
  BackendHealthInfo? _healthInfo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() {
      _isLoading = true;
    });

    final info = await sl.backendHealthService.checkBackendStatus();

    if (mounted) {
      setState(() {
        _healthInfo = info;
        _isLoading = false;
      });
    }
  }

  void _showDetailDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      builder: (ctx) {
        final info = _healthInfo;
        final isConnected = info?.isConnected ?? false;
        final isSupabaseOk = info?.isSupabaseConnected ?? false;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isConnected ? AppColors.accentGreen : const Color(0xFFEF4444))
                            .withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isConnected ? Icons.cloud_done : Icons.cloud_off,
                        color: isConnected ? AppColors.accentGreen : const Color(0xFFEF4444),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Status Koneksi Server & AI',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28, color: AppColors.border),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.computer, color: AppColors.accentCyan, size: 20),
                  ),
                  title: const Text(
                    'Golang Backend API',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    isConnected ? 'Online (REST API Aktif)' : 'Offline (Mode lokal aktif)',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isConnected ? AppColors.accentGreen : const Color(0xFFEF4444))
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isConnected ? AppColors.accentGreen : const Color(0xFFEF4444),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      isConnected ? 'AKTIF' : 'OFFLINE',
                      style: TextStyle(
                        color: isConnected ? AppColors.accentGreen : const Color(0xFFEF4444),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.storage, color: AppColors.primaryLight, size: 20),
                  ),
                  title: const Text(
                    'Supabase Database & Auth',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    isSupabaseOk
                        ? 'Tersambung (Cloud Database)'
                        : (info?.errorMessage ?? 'Belum tersambung (Fallback lokal)'),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isSupabaseOk ? AppColors.accentGreen : AppColors.accentAmber)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSupabaseOk ? AppColors.accentGreen : AppColors.accentAmber,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      isSupabaseOk ? 'TERHUBUNG' : 'OFFLINE',
                      style: TextStyle(
                        color: isSupabaseOk ? AppColors.accentGreen : AppColors.accentAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _checkStatus();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      'Cek Ulang Koneksi',
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryLight,
          ),
        ),
      );
    }

    final isOnline = _healthInfo?.isConnected ?? false;

    return InkWell(
      onTap: _showDetailDialog,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: (isOnline ? AppColors.accentGreen : AppColors.surfaceHigher)
              .withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOnline ? AppColors.accentGreen.withValues(alpha: 0.6) : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? AppColors.accentGreen : AppColors.textMuted,
                boxShadow: isOnline
                    ? [
                        BoxShadow(
                          color: AppColors.accentGreen.withValues(alpha: 0.6),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              isOnline ? 'Online' : 'Lokal',
              style: TextStyle(
                fontSize: 11.5,
                color: isOnline ? AppColors.accentGreen : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
