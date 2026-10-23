import 'package:flutter/foundation.dart';
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
          Text('Apariencia', style: Theme.of(context).textTheme.titleMedium),
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
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            Text('Pruebas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: const Text('Cargar un proyecto de ejemplo'),
                subtitle: const Text(
                  'Crea una casa con tres habitaciones, precios y acabados '
                  'para ver el presupuesto y el PDF sin medir nada.',
                ),
                onTap: () => _seedDemo(context, ref),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Siembra el proyecto de ejemplo y lo dice.
  Future<void> _seedDemo(BuildContext context, WidgetRef ref) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(demoDataProvider).seed();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Listo: «Casa de ejemplo» está en tus proyectos.'),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo cargar: $error')),
      );
    }
  }
}
