/// Un proyecto de obra: agrupa habitaciones, planos, materiales y presupuesto.
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.client,
    this.address,
    this.notes,
  });

  final int id;
  final String name;
  final String? client;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) {
    return other is Project &&
        other.id == id &&
        other.name == name &&
        other.client == client &&
        other.address == address &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, client, address, notes, createdAt, updatedAt);
}
