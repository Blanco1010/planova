import 'dart:async';

import 'package:planova/features/room_scan/domain/entities/device_aim.dart';
import 'package:planova/features/room_scan/domain/services/orientation_tracker.dart';

/// Sensores de mentira: la prueba decide hacia dónde apunta el teléfono.
class FakeOrientationTracker implements OrientationTracker {
  final StreamController<DeviceAim> _aims =
      StreamController<DeviceAim>.broadcast();
  DeviceAim? _last;

  void emit(DeviceAim aim) {
    _last = aim;
    _aims.add(aim);
  }

  void dispose() => _aims.close();

  @override
  Stream<DeviceAim> watch() async* {
    final DeviceAim? last = _last;
    if (last != null) yield last;
    yield* _aims.stream;
  }
}
