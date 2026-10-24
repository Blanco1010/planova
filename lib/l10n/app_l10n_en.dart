// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get delete => 'Delete';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get optionSystem => 'Same as the system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get currencyNote =>
      'Changes how prices are written. It does not convert them: what you typed is still worth the same.';

  @override
  String get currencyCop => 'Colombian peso';

  @override
  String get currencyUsd => 'Dollar';

  @override
  String get settingsTesting => 'Testing';

  @override
  String get demoTitle => 'Load a sample project';

  @override
  String get demoBody =>
      'Creates a house with three rooms, prices and finishes so you can see the budget and the PDF without measuring anything.';

  @override
  String demoDone(String project) {
    return 'Done: «$project» is in your projects.';
  }

  @override
  String demoFailed(String error) {
    return 'Couldn\'t create the sample: $error';
  }

  @override
  String get projectsLoadError => 'Your projects couldn\'t be read';

  @override
  String get projectsEmptyTitle => 'No projects yet';

  @override
  String get projectsEmptyBody =>
      'Create the first one to start saving rooms, plans and budgets.';

  @override
  String get newProject => 'New project';

  @override
  String get editProject => 'Edit project';

  @override
  String get createProject => 'Create project';

  @override
  String get deleteProject => 'Delete project';

  @override
  String deleteProjectMessage(String project) {
    return '«$project» and everything you keep inside it will be deleted. This can\'t be undone.';
  }

  @override
  String updatedOn(String date) {
    return 'Updated on $date';
  }

  @override
  String get projectName => 'Project name';

  @override
  String get projectNameHint => 'Two-storey house, kitchen remodel…';

  @override
  String get projectNameRequired => 'Give the project a name';

  @override
  String get client => 'Client';

  @override
  String get address => 'Address';

  @override
  String get notes => 'Notes';

  @override
  String get projectCreated => 'Project created';

  @override
  String get projectUpdated => 'Project updated';

  @override
  String saveFailed(String error) {
    return 'Couldn\'t save: $error';
  }
}
