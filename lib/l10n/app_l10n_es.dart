// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppL10nEs extends AppL10n {
  AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get delete => 'Eliminar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get optionSystem => 'Igual que el sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get currencyNote =>
      'Cambia cómo se escriben los precios. No los convierte: lo que está escrito sigue valiendo lo mismo.';

  @override
  String get currencyCop => 'Peso colombiano';

  @override
  String get currencyUsd => 'Dólar';

  @override
  String get settingsTesting => 'Pruebas';

  @override
  String get demoTitle => 'Cargar un proyecto de ejemplo';

  @override
  String get demoBody =>
      'Crea una casa con tres habitaciones, precios y acabados para ver el presupuesto y el PDF sin medir nada.';

  @override
  String demoDone(String project) {
    return 'Listo: «$project» está en tus proyectos.';
  }

  @override
  String demoFailed(String error) {
    return 'No se pudo crear el ejemplo: $error';
  }

  @override
  String get projectsLoadError => 'No se pudieron leer los proyectos';

  @override
  String get projectsEmptyTitle => 'Todavía no hay proyectos';

  @override
  String get projectsEmptyBody =>
      'Crea el primero para empezar a guardar habitaciones, planos y presupuestos.';

  @override
  String get newProject => 'Nuevo proyecto';

  @override
  String get editProject => 'Editar proyecto';

  @override
  String get createProject => 'Crear proyecto';

  @override
  String get deleteProject => 'Eliminar proyecto';

  @override
  String deleteProjectMessage(String project) {
    return 'Se borrará «$project» y todo lo que guardes dentro. Esto no se puede deshacer.';
  }

  @override
  String updatedOn(String date) {
    return 'Actualizado el $date';
  }

  @override
  String get projectName => 'Nombre del proyecto';

  @override
  String get projectNameHint => 'Casa de dos pisos, remodelación cocina…';

  @override
  String get projectNameRequired => 'Ponle un nombre al proyecto';

  @override
  String get client => 'Cliente';

  @override
  String get address => 'Dirección';

  @override
  String get notes => 'Notas';

  @override
  String get projectCreated => 'Proyecto creado';

  @override
  String get projectUpdated => 'Proyecto actualizado';

  @override
  String saveFailed(String error) {
    return 'No se pudo guardar: $error';
  }
}
