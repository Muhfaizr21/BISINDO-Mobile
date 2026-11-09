import 'package:flutter/material.dart';
import '../di/injection.dart';
import '../network/backend_health_service.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final info = _healthInfo;
        final isConnected = info?.isConnected ?? false;
        final isSupabaseOk = info?.isSupabaseConnected ?? false;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: isConnected ? Colors.green : Colors.red,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Status Koneksi Backend & Supabase',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.computer, color: Colors.blue),
                title: const Text('Golang Backend API'),
                subtitle: Text(
                  isConnected ? 'Online (REST API Aktif)' : 'Offline / Tidak terhubung',
                ),
                trailing: Text(
                  isConnected ? 'AKTIF' : 'OFFLINE',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.storage, color: Colors.purple),
                title: const Text('Supabase Database & Auth'),
                subtitle: Text(
                  isSupabaseOk
                      ? 'Tersambung (https://kdhsejrotfajtqygkcse.supabase.co)'
                      : (info?.errorMessage ?? 'Belum tersambung'),
                ),
                trailing: Text(
                  isSupabaseOk ? 'TERHUBUNG' : 'OFFLINE',
                  style: TextStyle(
                    color: isSupabaseOk ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _checkStatus();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Cek Ulang Koneksi'),
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
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final isOnline = _healthInfo?.isConnected ?? false;

    return InkWell(
      onTap: _showDetailDialog,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isOnline
              ? Colors.green.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOnline ? Colors.green : Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isOnline ? 'Backend Online' : 'Cek Backend',
              style: TextStyle(
                fontSize: 12,
                color: isOnline ? Colors.green.shade800 : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

