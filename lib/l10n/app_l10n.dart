import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearance;

  /// No description provided for @optionSystem.
  ///
  /// In es, this message translates to:
  /// **'Igual que el sistema'**
  String get optionSystem;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  /// No description provided for @settingsCurrency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get settingsCurrency;

  /// No description provided for @currencyNote.
  ///
  /// In es, this message translates to:
  /// **'Cambia cómo se escriben los precios. No los convierte: lo que está escrito sigue valiendo lo mismo.'**
  String get currencyNote;

  /// No description provided for @currencyCop.
  ///
  /// In es, this message translates to:
  /// **'Peso colombiano'**
  String get currencyCop;

  /// No description provided for @currencyUsd.
  ///
  /// In es, this message translates to:
  /// **'Dólar'**
  String get currencyUsd;

  /// No description provided for @settingsTesting.
  ///
  /// In es, this message translates to:
  /// **'Pruebas'**
  String get settingsTesting;

  /// No description provided for @demoTitle.
  ///
  /// In es, this message translates to:
  /// **'Cargar un proyecto de ejemplo'**
  String get demoTitle;

  /// No description provided for @demoBody.
  ///
  /// In es, this message translates to:
  /// **'Crea una casa con tres habitaciones, precios y acabados para ver el presupuesto y el PDF sin medir nada.'**
  String get demoBody;

  /// No description provided for @demoDone.
  ///
  /// In es, this message translates to:
  /// **'Listo: «{project}» está en tus proyectos.'**
  String demoDone(String project);

  /// No description provided for @demoFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear el ejemplo: {error}'**
  String demoFailed(String error);

  /// No description provided for @projectsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron leer los proyectos'**
  String get projectsLoadError;

  /// No description provided for @projectsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay proyectos'**
  String get projectsEmptyTitle;

  /// No description provided for @projectsEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Crea el primero para empezar a guardar habitaciones, planos y presupuestos.'**
  String get projectsEmptyBody;

  /// No description provided for @newProject.
  ///
  /// In es, this message translates to:
  /// **'Nuevo proyecto'**
  String get newProject;

  /// No description provided for @editProject.
  ///
  /// In es, this message translates to:
  /// **'Editar proyecto'**
  String get editProject;

  /// No description provided for @createProject.
  ///
  /// In es, this message translates to:
  /// **'Crear proyecto'**
  String get createProject;

  /// No description provided for @deleteProject.
  ///
  /// In es, this message translates to:
  /// **'Eliminar proyecto'**
  String get deleteProject;

  /// No description provided for @deleteProjectMessage.
  ///
  /// In es, this message translates to:
  /// **'Se borrará «{project}» y todo lo que guardes dentro. Esto no se puede deshacer.'**
  String deleteProjectMessage(String project);

  /// No description provided for @updatedOn.
  ///
  /// In es, this message translates to:
  /// **'Actualizado el {date}'**
  String updatedOn(String date);

  /// No description provided for @projectName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proyecto'**
  String get projectName;

  /// No description provided for @projectNameHint.
  ///
  /// In es, this message translates to:
  /// **'Casa de dos pisos, remodelación cocina…'**
  String get projectNameHint;

  /// No description provided for @projectNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre al proyecto'**
  String get projectNameRequired;

  /// No description provided for @client.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get client;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notes;

  /// No description provided for @projectCreated.
  ///
  /// In es, this message translates to:
  /// **'Proyecto creado'**
  String get projectCreated;

  /// No description provided for @projectUpdated.
  ///
  /// In es, this message translates to:
  /// **'Proyecto actualizado'**
  String get projectUpdated;

  /// No description provided for @saveFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar: {error}'**
  String saveFailed(String error);
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'es':
      return AppL10nEs();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
