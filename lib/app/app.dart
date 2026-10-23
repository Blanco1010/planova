import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/domain/entities/app_theme_mode.dart';
import '../features/settings/presentation/providers/settings_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class PlanovaApp extends ConsumerWidget {
  const PlanovaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeMode mode =
        ref.watch(themeModeProvider).value ?? AppThemeMode.system;

    return MaterialApp.router(
      title: 'Planova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode.themeMode,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('es'),
      supportedLocales: const <Locale>[Locale('es'), Locale('en')],
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
