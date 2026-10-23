import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_theme_mode.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeMode selected =
        ref.watch(themeModeProvider).value ?? AppThemeMode.system;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Apariencia',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<AppThemeMode>(
              groupValue: selected,
              onChanged: (AppThemeMode? mode) {
                if (mode == null) return;
                ref.read(settingsRepositoryProvider).saveThemeMode(mode);
              },
              child: Column(
                children: [
                  for (final AppThemeMode mode in AppThemeMode.values)
                    RadioListTile<AppThemeMode>(
                      value: mode,
                      title: Text(mode.label),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
