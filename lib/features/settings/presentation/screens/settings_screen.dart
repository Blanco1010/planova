import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/money.dart';
import '../../../../l10n/app_l10n.dart';
import '../../data/services/demo_data_service.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n t = AppL10n.of(context);
    final ThemeData theme = Theme.of(context);
    final AppThemeMode selected =
        ref.watch(themeModeProvider).value ?? AppThemeMode.system;
    final AppLanguage language =
        ref.watch(languageProvider).value ?? AppLanguage.system;
    final MoneyFormat money = ref.watch(moneyProvider).value ?? MoneyFormat.cop;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.settingsAppearance, style: theme.textTheme.titleMedium),
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
                      title: Text(mode.label(t)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(t.settingsLanguage, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<AppLanguage>(
              groupValue: language,
              onChanged: (AppLanguage? chosen) {
                if (chosen == null) return;
                ref.read(settingsRepositoryProvider).saveLanguage(chosen);
              },
              child: Column(
                children: [
                  for (final AppLanguage option in AppLanguage.values)
                    RadioListTile<AppLanguage>(
                      value: option,
                      title: Text(option.label(t)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(t.settingsCurrency, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            t.currencyNote,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<MoneyFormat>(
              groupValue: money,
              onChanged: (MoneyFormat? chosen) {
                if (chosen == null) return;
                ref.read(settingsRepositoryProvider).saveMoney(chosen);
              },
              child: Column(
                children: [
                  for (final MoneyFormat option in MoneyFormat.values)
                    RadioListTile<MoneyFormat>(
                      value: option,
                      title: Text(option.label(t)),
                      subtitle: Text(option.example),
                    ),
                ],
              ),
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            Text(t.settingsTesting, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: Text(t.demoTitle),
                subtitle: Text(t.demoBody),
                onTap: () => _seedDemo(context, ref, t),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Siembra el proyecto de ejemplo y lo dice.
  Future<void> _seedDemo(
    BuildContext context,
    WidgetRef ref,
    AppL10n t,
  ) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(demoDataProvider).seed();
      messenger.showSnackBar(
        SnackBar(content: Text(t.demoDone(DemoDataService.projectName))),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(t.demoFailed('$error'))),
      );
    }
  }
}
