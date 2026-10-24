import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/settings/domain/entities/app_language.dart';
import '../features/settings/domain/entities/app_theme_mode.dart';
import '../features/settings/presentation/providers/settings_providers.dart';
import '../l10n/app_l10n.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class PlanovaApp extends ConsumerWidget {
  const PlanovaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeMode mode =
        ref.watch(themeModeProvider).value ?? AppThemeMode.system;
    final AppLanguage language =
        ref.watch(languageProvider).value ?? AppLanguage.system;
    final String? code = language.code;

    // Los números y las fechas siguen al idioma elegido, no al del teléfono.
    Intl.defaultLocale = code ?? _systemLanguage();

    return MaterialApp.router(
      title: 'Planova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode.themeMode,
      routerConfig: ref.watch(routerProvider),
      locale: code == null ? null : Locale(code),
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: AppL10n.localizationsDelegates,
    );
  }

  /// El idioma del teléfono, si lo hablamos; si no, español.
  static String _systemLanguage() {
    final String system = PlatformDispatcher.instance.locale.languageCode;
    return system == 'en' ? 'en' : 'es';
  }
}
