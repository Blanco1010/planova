import 'package:drift/drift.dart';

/// Ajustes de la app guardados como pares clave/valor.
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
