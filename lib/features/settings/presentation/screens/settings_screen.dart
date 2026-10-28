import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../services/backup_service.dart';
import '../services/biometric_service.dart';

final biometricEnabledProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final BackupService _backupService = BackupService();
  final BiometricService _biometricService = BiometricService();
  bool _biometricSupported = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await _biometricService.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _biometricSupported = available;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBiometricOn = ref.watch(biometricEnabledProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt & Bảo Mật'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Security Section
          const Text(
            'BẢO MẬT & QUYỀN RIÊNG TƯ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: isBiometricOn,
                  activeColor: AppColors.primary,
                  secondary: const Icon(CupertinoIcons.lock_shield_fill,
                      color: AppColors.primary),
                  title: const Text('Khóa ứng dụng bằng Face ID'),
                  subtitle: Text(
                    _biometricSupported
                        ? 'Yêu cầu mở khóa mỗi khi vào ứng dụng'
                        : 'Thiết bị không hỗ trợ Face ID / Touch ID',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onChanged: _biometricSupported
                      ? (val) async {
                          if (val) {
                            final success =
                                await _biometricService.authenticate();
                            if (success) {
                              ref.read(biometricEnabledProvider.notifier).state =
                                  true;
                            }
                          } else {
                            ref.read(biometricEnabledProvider.notifier).state =
                                false;
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data & Backup Section
          const Text(
            'DỮ LIỆU & SAO LƯU (OFFLINE)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(CupertinoIcons.share,
                      color: AppColors.primary),
                  title: const Text('Xuất file sao lưu (JSON)'),
                  subtitle: const Text(
                    'Chia sẻ qua AirDrop, Lưu vào Files app hoặc iCloud',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(CupertinoIcons.chevron_forward,
                      size: 16, color: AppColors.textSecondaryLight),
                  onTap: () async {
                    try {
                      await _backupService.exportDataToShareSheet();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi xuất dữ liệu: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // App Info
          const Text(
            'THÔNG TIN ỨNG DỤNG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(CupertinoIcons.info_circle_fill,
                      color: AppColors.primary),
                  title: Text('Phiên bản'),
                  trailing: Text(
                    '1.0.0 (Local Build)',
                    style: TextStyle(color: AppColors.textSecondaryLight),
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(CupertinoIcons.shield_lefthalf_fill,
                      color: AppColors.income),
                  title: Text('Chế độ hoạt động'),
                  trailing: Text(
                    '100% Offline / Riêng tư',
                    style: TextStyle(color: AppColors.income, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
