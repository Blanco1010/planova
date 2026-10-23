import 'package:drift/drift.dart';

/// Tabla de proyectos de obra. Cada proyecto agrupa habitaciones, planos,
/// cálculos de materiales y presupuesto.
@DataClassName('ProjectRow')
class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Cliente o propietario de la obra.
  TextColumn get client => text().nullable()();

  /// Dirección o ubicación de la obra.
  TextColumn get address => text().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
